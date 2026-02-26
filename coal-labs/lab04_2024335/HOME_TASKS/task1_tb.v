module tb_mul8s_behav;

    reg  signed [7:0] a, b;
    wire signed [15:0] y;

    mul8s_behav DUT (.a(a), .b(b), .y(y));

    initial begin
        $dumpfile("task1_tb.vcd");
        $dumpvars(0, tb_mul8s_behav);
        // Corner cases
        a = 0;    b = 0;    #10;
        a = -128; b = 1;    #10;
        a = -128; b = -1;   #10;
        a = 127;  b = 127;  #10;

        // Mixed signs
        a = -5;   b = 7;    #10;
        a = 10;   b = -3;   #10;

        $finish;
    end
endmodule