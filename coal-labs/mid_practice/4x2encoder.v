module encoder_4x2(
    input [3:0] D,
    output [1:0] Y
);
    // Y[1] is high if D[2] or D[3] is high
    or o1 (Y[1], D[2], D[3]);
    
    // Y[0] is high if D[1] or D[3] is high
    or o0 (Y[0], D[1], D[3]);

endmodule