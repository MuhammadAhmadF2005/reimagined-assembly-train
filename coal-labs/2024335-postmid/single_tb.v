`timescale 1ns / 1ps
`include "single.v"

module TB();

reg clk;
reg reset;

// Instantiate the Processor
RISC_V_Processor uut (clk, reset);

// Clock generation: 10ns period (100MHz)
always #5 clk = ~clk;

initial begin
    // Initialize signals
    clk = 0;
    reset = 1;

    // Dump for waveform
    $dumpfile("single_cycle.vcd");
    $dumpvars(0, TB);

    // Instruction 0: add x1, x0, x0
    uut.instr_mem[0] = 8'b00000000; uut.instr_mem[1] = 8'b00000000; uut.instr_mem[2] = 8'b00000000; uut.instr_mem[3] = 8'b10110011;
    // Instruction 4: lw x2, 4(x0)
    uut.instr_mem[4] = 8'b00000000; uut.instr_mem[5] = 8'b01000000; uut.instr_mem[6] = 8'b00100001; uut.instr_mem[7] = 8'b00000011;

    // Placing a value at address 4 to be loaded by instruction 2
    uut.data_mem[4] = 8'b00000000; uut.data_mem[5] = 8'b00000000; uut.data_mem[6] = 8'b00000000; uut.data_mem[7] = 8'b00001010;

    // Release reset
    #20 reset = 0;

    #100;

    $finish;
end

endmodule
