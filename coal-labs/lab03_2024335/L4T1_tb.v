`timescale 1ns / 1ps

module register32_tb;

    // Testbench signals (inputs are reg, outputs are wire)
    reg clk;
    reg reset;
    reg [31:0] d;
    wire [31:0] q;

    // Instantiate the 32-bit register (Unit Under Test)
    register32 uut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        d = 32'd0;

        // Enable waveform dump
        $dumpfile("register32.vcd");
        $dumpvars(0, register32_tb);

        // Apply reset
        #10 reset = 0;               // Deassert reset

        // Apply first data
        #10 d = 32'd25;              // Load 25
        // q updates at next posedge clk

        // Apply second data
        #10 d = 32'd100;             // Load 100

        // Apply reset again
        #10 reset = 1;
        #10 reset = 0;

        // Apply new data
        #10 d = 32'd999;

        #20 $finish;                 // End simulation
    end

endmodule
