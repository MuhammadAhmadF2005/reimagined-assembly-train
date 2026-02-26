module tb_mul8s_fast;

    reg  signed [7:0] a, b;
    wire signed [15:0] y;

    mul8s_fast DUT (.a(a), .b(b), .y(y));

    initial begin
        $dumpfile("task3_tb.vcd");
        $dumpvars(0, tb_mul8s_fast);

        // Corner cases
        a = -128; b = 1;    #10;
        a = -128; b = -1;   #10;
        a = 127;  b = 127;  #10;

        // Mixed sign
        a = -7;   b = 9;    #10;
        a = 12;   b = -4;   #10;

        // Self-check
        repeat (10) begin
            a = $random;
            b = $random;
            #5;
            if (y !== a * b)
                $display("ERROR: a=%d b=%d y=%d exp=%d", a, b, y, a*b);
            #5;
        end

        $finish;
    end
endmodule