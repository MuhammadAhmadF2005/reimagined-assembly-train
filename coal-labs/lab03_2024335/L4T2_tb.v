`timescale 1ns / 1ps

module up_counter32_tb;

    // Testbench signals
    reg clk;
    reg reset;
    wire [31:0] count;

    // Instantiate the counter (Unit Under Test)
    up_counter32 uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Enable waveform dump
        $dumpfile("upcounter.vcd");
        $dumpvars(0, up_counter32_tb);

        // Apply reset
        #10 reset = 0;

        // Let counter run for some cycles
        #100;

        // Apply reset again
        reset = 1;
        #10 reset = 0;

        // Run again
        #50;

        #20 $finish;                 // End simulation
    end

endmodule
