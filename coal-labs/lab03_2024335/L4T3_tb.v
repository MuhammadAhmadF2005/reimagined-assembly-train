`timescale 1ns / 1ps

module counter_with_adder_tb;

    reg clk;
    reg reset;
    reg [3:0] add_value;
    wire [31:0] count;

    // Instantiate top module
    counter_with_adder uut (
        .clk(clk),
        .reset(reset),
        .add_value(add_value),
        .count(count)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Generate VCD file for GTKWave
        $dumpfile("counter_with_adder.vcd");
        $dumpvars(0, counter_with_adder_tb);

        // Initialize
        clk = 0;
        reset = 1;
        add_value = 4'd0;

        // Apply reset
        #10 reset = 0;

        // Add 3 each clock
        add_value = 4'd3;
        #40;

        // Change increment to 5
        add_value = 4'd5;
        #40;

        // Reset again
        reset = 1;
        #10 reset = 0;

        // Add 2
        add_value = 4'd2;
        #40;

        $finish;
    end

endmodule
