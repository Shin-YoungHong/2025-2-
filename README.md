# FPGA Digital Stopwatch (Verilog)

Modular digital stopwatch designed and verified in **Verilog HDL** for **Basic Electrical & Electronic Engineering Lab (2)**.  
Features millisecond-precision timing, lap-time display, invalid-input error handling, and visual stop-state feedback on 6-digit 7-segment displays (FND) and LEDs.

## Module Architecture
```text
Stopwatch (TOP)
├── SwitchInterface   # Debouncing & pulse generation (run/stop, reset, lap)
├── State_Machine     # Core FSM controlling run, stop, lap, and error states
├── Timer             # Counter logic generating min_cnt, sec_cnt, ms_cnt, half_sec_tick
├── ledDriver         # Status LED control synchronized with timer_en / half_sec_tick
└── segDriver         # 6-digit 7-segment display driver with lap & error rendering
```

## My Role
- **System Architecture & TOP Module (`Stopwatch.v`):** Defined inter-module wire interfaces and integrated all five hardware blocks into the top-level design.
- **Switch Interface (`SwitchInterface.v`):** Designed user input conditioning to generate clean single-cycle control pulses (`run_stop_pulse`, `reset_pulse`, `lap_pulse`).

## Key Hardware Features
- **Invalid Input Error Handling:** Detects illegal button transitions inside `State_Machine` and asserts `error_sig` to display an error indicator on the FND.
- **Stop-State Blinking Feedback:** Uses `half_sec_tick` in `segDriver` to blink the display while paused so operating state is immediately distinguishable.
- **Testbench Verification:** Verified timing and state transitions using `Stopwatch_tb.v`.
