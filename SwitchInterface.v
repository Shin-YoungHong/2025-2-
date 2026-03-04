module SwitchInterface (
    input wire mclk,
    input wire [2:0] SW,
    input wire rst_n,
    output reg run_stop_pulse,
    output reg reset_pulse,
    output reg lap_pulse
);

    reg [2:0] SW_INP_z1;
    reg [2:0] SW_INP_z2;
    reg [2:0] SW_INP_z3;

    always @(posedge mclk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            SW_INP_z1 <= 3'b000;
            SW_INP_z2 <= 3'b000;
            SW_INP_z3 <= 3'b000;
            run_stop_pulse <= 1'b0;
            reset_pulse <= 1'b0;
            lap_pulse <= 1'b0;
        end
        else
        begin
            SW_INP_z1 <= SW;
            SW_INP_z2 <= SW_INP_z1;
            SW_INP_z3 <= SW_INP_z2;
            
            run_stop_pulse <= (!SW_INP_z3[0] && SW_INP_z2[0]);
            reset_pulse <= (!SW_INP_z3[1] && SW_INP_z2[1]);
            lap_pulse <= (!SW_INP_z3[2] && SW_INP_z2[2]);
        end
    end

endmodule