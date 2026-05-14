`timescale 1ns / 1ps
`include "pipeline.v"

module TB();
    reg clk;
    reg reset;

    Pipeline uut (
        .clk(clk),
        .reset(reset)
    );

    
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        $dumpfile("pipeline.vcd");
        $dumpvars(0, TB);

        // Instruction 0: add x1, x0, x0
        uut.instr_mem[0] = 8'b00000000; uut.instr_mem[1] = 8'b00000000; uut.instr_mem[2] = 8'b00000000; uut.instr_mem[3] = 8'b10110011;
        // Instruction 4: lw x2, 4(x0)
        uut.instr_mem[4] = 8'b00000000; uut.instr_mem[5] = 8'b01000000; uut.instr_mem[6] = 8'b00100001; uut.instr_mem[7] = 8'b00000011;

        // Data for lw at address 4
        uut.data_mem[4] = 8'b00000000; uut.data_mem[5] = 8'b00000000; uut.data_mem[6] = 8'b00000000; uut.data_mem[7] = 8'b00001010;

        #20 reset = 0;

        #200;
        $finish;
    end
endmodule
