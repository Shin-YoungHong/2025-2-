module Timer (
input wire timer_en,
input wire timer_rst,
input wire mclk,
input wire rst_n,
output reg half_sec_tick,
output reg [6:0] min_cnt,
output reg [5:0] sec_cnt,
output reg [6:0] ms_cnt
);

reg [13:0] clk_div;
wire tick;
assign tick = (clk_div == 14'd9999);

reg [19:0] blink_cnt;
always @(posedge mclk or negedge rst_n) begin
if(!rst_n) blink_cnt <= 0;
else blink_cnt <= blink_cnt + 1;
end
wire blink_on = blink_cnt[19];

always @(posedge mclk or negedge rst_n) begin
if (!rst_n) begin
clk_div <= 14'd0;
ms_cnt <= 7'd0;
sec_cnt <= 6'd0;
min_cnt <= 7'd0;
half_sec_tick <= 1'b0;
end
else begin
half_sec_tick <= 1'b0;
if (timer_rst) begin
clk_div <= 14'd0;
ms_cnt <= 7'd0;
sec_cnt <= 6'd0;
min_cnt <= 7'd0;
end
else if (timer_en) begin
if (tick) begin
clk_div <= 14'd0;
end else begin
clk_div <= clk_div + 1'b1;
end

if (tick) begin
if (ms_cnt == 7'd49 || ms_cnt == 7'd99) begin
half_sec_tick <= 1'b1;
end

if (ms_cnt == 7'd99) begin
ms_cnt <= 7'd0;
if (sec_cnt == 6'd59) begin
sec_cnt <= 6'd0;
if(min_cnt == 7'd99) begin
min_cnt <= 7'd0;
end else begin
min_cnt <= min_cnt + 1'b1;
end
end else begin
sec_cnt <= sec_cnt + 1'b1;
end
end else begin
ms_cnt <= ms_cnt + 1'b1;
end
end
end
else if(!timer_en && (min_cnt || sec_cnt || ms_cnt) && blink_on) begin
half_sec_tick <= 1'b1;
end
end
end

endmodule

