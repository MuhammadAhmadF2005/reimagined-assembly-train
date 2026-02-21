//gate level model

module HalfAdder (
    input a,
    input b,
    output sum,
    output carry
);    
endmodule

xor(sum, a, b);
and(carry, a, b);

module FullAdder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

wire sum1;
wire c1;
wire c2;

HalfAdder HA1(
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(c1)
    );

HalfAdder HA2(
        .a(sum1),
        .b(cin),
        .sum(sum),
        .carry(c2)
    );

    or(cout, c1, c2);
    
endmodule