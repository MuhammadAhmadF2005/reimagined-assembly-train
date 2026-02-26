module mul8s_fast (
    input  signed [7:0] a,
    input  signed [7:0] b,
    output signed [15:0] y
);

    wire signed [15:0] pp [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : PARTIALS
            assign pp[i] = b[i] ? ({{8{a[7]}}, a} <<< i) : 16'sd0;
        end
    endgenerate

    assign y = pp[0] + pp[1] + pp[2] + pp[3]
             + pp[4] + pp[5] + pp[6] + pp[7];

endmodule