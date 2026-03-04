module ledDriver(
    input wire mclk,
    input wire rst_n,
    input wire timer_en,
    input wire half_sec_tick,
    input wire timer_rst,
    output reg [7:0] LED
);

    always @(posedge mclk or negedge rst_n) begin
        if (!rst_n) begin
            LED <= 8'b00000000;
        end
        else if (timer_rst) begin
            LED <= 8'b00000000;
        end
        else if (timer_en && half_sec_tick) begin
            LED <= ~LED;
        end
        else begin
            LED <= LED;
        end
    end

endmodule