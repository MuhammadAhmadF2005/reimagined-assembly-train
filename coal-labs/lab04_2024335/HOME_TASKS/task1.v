module mul8s_behav (
    input  signed [7:0] a,
    input  signed [7:0] b,
    output signed [15:0] y
);
    assign y = a * b;
endmodule