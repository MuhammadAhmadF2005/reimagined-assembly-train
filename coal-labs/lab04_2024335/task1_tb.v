module tb_mul8u_behav;

    reg  [7:0] a, b;
    wire [15:0] y;

    mul8u_behav DUT (.a(a), .b(b), .y(y));

    initial begin
        $dumpfile("task1_tb.vcd");
        $dumpvars(0, tb_mul8u_behav);
        // Corner cases
        a = 0;   b = 0;   #10;
        a = 0;   b = 255; #10;
        a = 255; b = 0;   #10;
        a = 255; b = 255; #10;

        // Random tests
        a = 13;  b = 7;   #10;
        a = 128; b = 2;   #10;
        a = 200; b = 100; #10;

        $finish;
    end
endmodule