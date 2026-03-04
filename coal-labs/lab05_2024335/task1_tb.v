`timescale 1ns / 1ps

module DivisionT1_tb;

    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;

    wire [7:0] quotient;
    wire [7:0] remainder;
    wire ready;

    DivisionT1 Uut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .ready(ready)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("Lab5.vcd");
        $dumpvars(0, DivisionT1_tb);

        clk = 0;
        dividend = 0;
        divisor = 0;

        #20;
        
        // Test Case 1: 7 / 2
        @(negedge clk);
        dividend = 8'd7;
        divisor = 8'd2;
        
        wait(ready == 1);
        @(posedge clk);
        $display("Test Case: 7 / 2 | Expected: Q=3, R=1 | Actual: Q=%d, R=%d", quotient, remainder);

        // Test Case 2: 100 / 3
        #20;
        @(negedge clk);
        dividend = 8'd100;
        divisor = 8'd3;
        
        wait(ready == 1);
        @(posedge clk);
        $display("Test Case: 100 / 3 | Expected: Q=33, R=1 | Actual: Q=%d, R=%d", quotient, remainder);
        
        // Test Case 3: 45 / 8
        #20;
        @(negedge clk);
        dividend = 8'd45;
        divisor = 8'd8;
        
        wait(ready == 1);
        @(posedge clk);
        $display("Test Case: 45 / 8 | Expected: Q=5, R=5 | Actual: Q=%d, R=%d", quotient, remainder);

        // Test Case 4: 75 / 4
        #20;
        @(negedge clk);
        dividend = 8'd75;
        divisor = 8'd4;
        
        wait(ready == 1);
        @(posedge clk);
        $display("Test Case: 75 / 4 | Expected: Q=18, R=3 | Actual: Q=%d, R=%d", quotient, remainder);

        #50;
        $display("Simulation Complete.");
        $finish;
    end

endmodule