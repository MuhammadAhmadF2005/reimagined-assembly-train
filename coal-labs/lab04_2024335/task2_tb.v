module tb_mul8u_seq;

    reg clk, rst;
    reg [7:0] a, b;
    wire [15:0] y;
    wire ready;

    mul8u_seq DUT (clk, rst, a, b, y, ready);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("task2_tb.vcd");
        $dumpvars(0, tb_mul8u_seq);
        clk = 0; rst = 1;
        a = 0; b = 0;
        #20 rst = 0;

        // Test 1: 15 * 3 = 45
        a = 15; b = 3;
        #100;
        $display("Test 1: %0d * %0d = %0d (expected 45)", a, b, y);

        // Reset between tests
        rst = 1; #20; rst = 0;

        // Test 2: 255 * 255 = 65025
        a = 255; b = 255;
        #100;
        $display("Test 2: %0d * %0d = %0d (expected 65025)", a, b, y);

        // Reset between tests
        rst = 1; #20; rst = 0;

        // Test 3: 128 * 2 = 256
        a = 128; b = 2;
        #100;
        $display("Test 3: %0d * %0d = %0d (expected 256)", a, b, y);

        $finish;
    end
endmodule