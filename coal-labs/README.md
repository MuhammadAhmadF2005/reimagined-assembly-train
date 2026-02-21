# COAL Lab 03 - Verilog Modules and Testbenches

This folder contains Verilog source files and testbenches for various digital design modules, including counters, adders, register files, and data memory. Each module is accompanied by a testbench for simulation and waveform analysis.

## File Structure
- `L4T1.v`, `L4T1_tb.v`: Up Counter (32-bit) and its testbench
- `L4T2.v`, `L4T2_tb.v`: Up Counter (32-bit) with testbench (alternate)
- `L4T3.v`, `L4T3_tb.v`: Counter with Adder and its testbench
- `L5T1.v`, `L5T1_tb.v`: Register File and its testbench
- `L5T2.v`, `L5T2_tb.v`: Data Memory and its testbench
- `L6T1.v`, `L6T1_tb.v`: Additional module and testbench (if present)

## How to Simulate
1. **Compile the design and testbench:**
   ```bash
   iverilog -g2012 -Wall -o <testbench_name>.vvp <module_file>.v <testbench_file>.v
   ```
   Example:
   ```bash
   iverilog -g2012 -Wall -o L4T2_tb.vvp L4T2.v L4T2_tb.v
   ```
2. **Run the simulation:**
   ```bash
   vvp <testbench_name>.vvp
   ```
   This will generate a `.vcd` file for waveform analysis.

3. **View waveforms in GTKWave:**
   ```bash
   gtkwave <waveform_file>.vcd
   ```

## Notes
- All testbenches are set up to generate VCD files for waveform viewing.
- Make sure you have `iverilog` and `gtkwave` installed:
  ```bash
  sudo apt install iverilog gtkwave
  ```
- Edit or extend the testbenches as needed for your experiments.

---

*Lab 03, COAL, 2024-2025*
