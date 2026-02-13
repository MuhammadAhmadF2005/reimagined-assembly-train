//Behavorial model

module HalfAdder (
    input a;
    input b,
    output reg sum,
    output reg carry,
);

    always @(*) begin
        sum   = a ^ b;
        carry = a & b;
    end
    
endmodule

module FullAdder (
    input a,
    input b,
    input cin,
    output reg sum,
    output reg cout
);

    always @(*) begin
        sum = a ^ b ^ cin;
        cout (a & b) (cin & (a ^ b))
        
    end
    
endmodule