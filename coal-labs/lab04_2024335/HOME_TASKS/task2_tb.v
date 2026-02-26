module tb_mul8s_seq;

    reg clk, rst;
    reg signed [7:0] a, b;
    wire signed [15:0] y;
    wire ready;

    mul8s_seq DUT (clk, rst, a, b, y, ready);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("task2_tb.vcd");
        $dumpvars(0, tb_mul8s_seq);
        clk = 0; rst = 1;
        #20 rst = 0;

        // Test 1: -5 * 7 = -35
        a = -5;  b = 7;
        #100;
        $display("Test 1: %0d * %0d = %0d (expected -35)", a, b, y);

        // Reset between tests
        rst = 1; #20; rst = 0;

        // Test 2: -10 * -10 = 100
        a = -10; b = -10;
        #100;
        $display("Test 2: %0d * %0d = %0d (expected 100)", a, b, y);

        // Reset between tests
        rst = 1; #20; rst = 0;

        // Test 3: 127 * -1 = -127
        a = 127; b = -1;
        #100;
        $display("Test 3: %0d * %0d = %0d (expected -127)", a, b, y);

        $finish;
    end
endmodule