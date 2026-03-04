module segDriver(
input wire mclk,
input wire rst_n,
input wire [6:0] ms_cnt,
input wire [5:0] sec_cnt,
input wire [6:0] min_cnt,
input wire lap_strobe,
input wire display_mode,
input wire timer_en,
input wire half_sec_tick,
input wire error_sig,
output reg [6:0] FND1,
output reg [6:0] FND2,
output reg [6:0] FND3,
output reg [6:0] FND4,
output reg [6:0] FND5,
output reg [6:0] FND6
);

reg [6:0] lap_ms;
reg [5:0] lap_sec;
reg [6:0] lap_min;

always @(posedge mclk or negedge rst_n) begin
if (!rst_n) begin
lap_ms <= 0; lap_sec <= 0; lap_min <= 0;
end else if (lap_strobe) begin
lap_ms <= ms_cnt; lap_sec <= sec_cnt; lap_min <= min_cnt;
end
end

reg [6:0] disp_ms;
reg [5:0] disp_sec;
reg [6:0] disp_min;

always @(*) begin
if (display_mode == 1) begin
disp_ms = lap_ms; disp_sec = lap_sec; disp_min = lap_min;
end else begin
disp_ms = ms_cnt; disp_sec = sec_cnt; disp_min = min_cnt;
end
end

reg [3:0] ms_ten, ms_one;
reg [3:0] sec_ten, sec_one;
reg [3:0] min_ten, min_one;

always @(*) begin
ms_ten = disp_ms / 10; ms_one = disp_ms % 10;
sec_ten = disp_sec / 10; sec_one = disp_sec % 10;
min_ten = disp_min / 10; min_one = disp_min % 10;
end

function [6:0] seg7;
input [3:0] num;
begin
case(num)
4'd0: seg7 = 7'b1111110;
4'd1: seg7 = 7'b0110000;
4'd2: seg7 = 7'b1101101;
4'd3: seg7 = 7'b1111001;
4'd4: seg7 = 7'b0110011;
4'd5: seg7 = 7'b1011011;
4'd6: seg7 = 7'b1011111;
4'd7: seg7 = 7'b1110010;
4'd8: seg7 = 7'b1111111;
4'd9: seg7 = 7'b1111011;
4'd10: seg7 = 7'b1001111;
4'd11: seg7 = 7'b0000101;
default: seg7 = 7'b0000000;
endcase
end
endfunction

wire is_time_non_zero = (|ms_cnt) | (|sec_cnt) | (|min_cnt);

always @(*) begin
if (error_sig) begin
FND4 = seg7(4'd10);
FND5 = seg7(4'd11);
FND6 = seg7(4'd11);
FND3 = 7'b0000000;
FND2 = 7'b0000000;
FND1 = 7'b0000000;
end
else if (!timer_en && is_time_non_zero && half_sec_tick) begin
FND6 = 7'b0000000;
FND5 = 7'b0000000;
FND4 = 7'b0000000;
FND3 = 7'b0000000;
FND2 = 7'b0000000;
FND1 = 7'b0000000;
end
else begin
FND6 = seg7(ms_one); // ms ?? ??
FND5 = seg7(ms_ten); // ms ?? ??
FND4 = seg7(sec_one); // sec ?? ??
FND3 = seg7(sec_ten); // sec ?? ??
FND2 = seg7(min_one); // min ?? ??
FND1 = seg7(min_ten); // min ?? ??
end
end

endmodule
