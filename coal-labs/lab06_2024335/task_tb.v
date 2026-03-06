//testbench for module floating point adder//

module fp8_adder_tb;

reg [7:0] a;
reg [7:0] b;

wire [7:0] sum;

fp8_adder uut(
    .a(a),
    .b(b),
    .sum(sum)
);

initial begin

$dumpfile("fp8.vcd");
$dumpvars(0, fp8_adder_tb);

$display(" A        B        SUM");

a = 8'b01000011; b = 8'b11001000; #10; // 2.75 + -4
$display("%b + %b = %b", a,b,sum);

a = 8'b01001011; b = 8'b01100011; #10; // 5.5 + 44
$display("%b + %b = %b", a,b,sum);

a = 8'b01000001; b = 8'b01000010; #10; // 2.25 + 2.5
$display("%b + %b = %b", a,b,sum);

a = 8'b01000100; b = 8'b01000100; #10;
$display("%b + %b = %b", a,b,sum);

a = 8'b11000100; b = 8'b01000100; #10;
$display("%b + %b = %b", a,b,sum);

$finish;

end

endmodule