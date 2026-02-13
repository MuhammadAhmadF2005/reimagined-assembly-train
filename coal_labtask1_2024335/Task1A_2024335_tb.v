`timescale 1ns/1ps

module FullAdder_tb;

    reg a;
    reg b;
    reg cin;
    wire sum;
    wire cout;

    // Unit Under Test
    FullAdder UUT (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        
        $dumpfile("fulladderA.vcd");
        $dumpvars(0, FullAdder_tb);

        // Test vectors
        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 0; cin = 1; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 0; b = 1; cin = 1; #10;
        a = 1; b = 0; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;

        $finish;
    end

endmodule

