module Stopwatch (
    input wire mclk,
    input wire rst_n,
    input wire [2:0] SW,
    output wire [7:0] LED,
    output wire [6:0] FND1,
    output wire [6:0] FND2,
    output wire [6:0] FND3,
    output wire [6:0] FND4,
    output wire [6:0] FND5,
    output wire [6:0] FND6
);

    wire run_stop_pulse;
    wire reset_pulse;
    wire lap_pulse;
    wire timer_en;
    wire timer_rst;
    wire lap_strobe;
    wire display_mode;
    wire error_sig;
    wire half_sec_tick;
    wire [6:0] min_cnt;
    wire [5:0] sec_cnt;
    wire [6:0] ms_cnt;

    SwitchInterface w_SwitchInterface (
        .rst_n(rst_n),
        .mclk(mclk),
        .SW(SW),
        .run_stop_pulse(run_stop_pulse),
        .reset_pulse(reset_pulse),
        .lap_pulse(lap_pulse)
    );

    State_Machine w_State_Machine (
        .rst_n(rst_n),
        .mclk(mclk),
        .reset_pulse(reset_pulse),
        .lap_pulse(lap_pulse),
        .run_stop_pulse(run_stop_pulse),
        .timer_en(timer_en),
        .timer_rst(timer_rst),
        .lap_strobe(lap_strobe),
        .display_mode(display_mode),
        .error_sig(error_sig)
    );

    Timer w_Timer (
        .rst_n(rst_n),
        .mclk(mclk),
        .timer_en(timer_en),
        .timer_rst(timer_rst),
        .half_sec_tick(half_sec_tick),
        .min_cnt(min_cnt),
        .sec_cnt(sec_cnt),
        .ms_cnt(ms_cnt)
    );

    ledDriver w_ledDriver(
        .rst_n(rst_n),
        .mclk(mclk),
        .half_sec_tick(half_sec_tick),
        .timer_en(timer_en),
        .timer_rst(timer_rst),
        .LED(LED)
    );

    segDriver w_segDriver(
        .rst_n(rst_n),
        .mclk(mclk),
        .lap_strobe(lap_strobe),
        .display_mode(display_mode),
        .min_cnt(min_cnt),
        .sec_cnt(sec_cnt),
        .ms_cnt(ms_cnt),
        .timer_en(timer_en),
        .half_sec_tick(half_sec_tick),
        .error_sig(error_sig),
        .FND1(FND1),
        .FND2(FND2),
        .FND3(FND3),
        .FND4(FND4),
        .FND5(FND5),
        .FND6(FND6)
    );

endmodule