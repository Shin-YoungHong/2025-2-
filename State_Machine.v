module State_Machine (
    input wire rst_n,
    input wire mclk,
    input wire reset_pulse,
    input wire lap_pulse,
    input wire run_stop_pulse,
    output reg timer_en,
    output reg timer_rst,
    output reg lap_strobe,
    output reg display_mode,
    output reg error_sig
);

    localparam [1:0]
        STOP = 2'b00,
        RUN = 2'b01,
        LAP_DISPLAY = 2'b10,
        ERROR_STATE = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [1:0] previous_state;
    reg [19:0] err_cnt;

    always @(posedge mclk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STOP;
            err_cnt <= 0;
            previous_state <= STOP;
        end else begin
            current_state <= next_state;
            
            if (current_state == ERROR_STATE)
                err_cnt <= err_cnt + 1;
            else
                err_cnt <= 0;

            if ((current_state == RUN || current_state == LAP_DISPLAY) && reset_pulse) begin
                previous_state <= current_state;
            end
        end
    end

    always @(*) begin
        next_state = current_state;

        case (current_state)
            STOP: begin
                if (reset_pulse) next_state = STOP;
                else if (run_stop_pulse) next_state = RUN;
            end
            RUN: begin
                if (lap_pulse) next_state = LAP_DISPLAY;
                else if (run_stop_pulse) next_state = STOP;
                else if (reset_pulse) next_state = ERROR_STATE;
            end
            LAP_DISPLAY: begin
                if (run_stop_pulse) next_state = STOP;
                else if (lap_pulse) next_state = RUN;
                else if (reset_pulse) next_state = ERROR_STATE;
            end
            ERROR_STATE: begin
                if (err_cnt >= 20'd999_999)
                    next_state = previous_state;
                else
                    next_state = ERROR_STATE;
            end
            default: next_state = STOP;
        endcase
    end

    always @(*) begin
        timer_en = 1'b0;
        display_mode = 1'b0;
        timer_rst = 1'b0;
        lap_strobe = 1'b0;
        error_sig = 1'b0;

        case (current_state)
            STOP: begin
                timer_en = 1'b0;
                if (reset_pulse) timer_rst = 1'b1;
            end
            RUN: begin
                timer_en = 1'b1;
                if (lap_pulse) lap_strobe = 1'b1;
            end
            LAP_DISPLAY: begin
                timer_en = 1'b1;
                display_mode = 1'b1;
            end
            ERROR_STATE: begin
                timer_en = 1'b1;
                error_sig = 1'b1;
            end
        endcase
    end

endmodule