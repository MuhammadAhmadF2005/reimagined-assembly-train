module mux_8x1(
    input [7:0] D,
    input [2:0] S,
    output Y
);
    wire S0n, S1n, S2n;
    wire w0, w1, w2, w3, w4, w5, w6, w7;

    // Invert selection lines
    not n0(S0n, S[0]), n1(S1n, S[1]), n2(S2n, S[2]);

    // Decode and AND with data inputs (Verilog allows multi-input primitives)
    and a0 (w0, D[0], S2n, S1n, S0n);
    and a1 (w1, D[1], S2n, S1n, S[0]);
    and a2 (w2, D[2], S2n, S[1], S0n);
    and a3 (w3, D[3], S2n, S[1], S[0]);
    and a4 (w4, D[4], S[2], S1n, S0n);
    and a5 (w5, D[5], S[2], S1n, S[0]);
    and a6 (w6, D[6], S[2], S[1], S0n);
    and a7 (w7, D[7], S[2], S[1], S[0]);

    // OR all outputs together
    or o1 (Y, w0, w1, w2, w3, w4, w5, w6, w7);

endmodule

//BEHAVORIAL MODEL a lil easier imo

module mux_8x1_beh(
    input [7:0] D,      // 8-bit Data input
    input [2:0] S,      // 3-bit Selection input
    output reg Y        // Output MUST be 'reg' because it's assigned in an always block
);

    // The @(*) sensitivity list means this block executes anytime D or S changes
    always @(*) begin
        case (S)
            3'b000: Y = D[0];
            3'b001: Y = D[1];
            3'b010: Y = D[2];
            3'b011: Y = D[3];
            3'b100: Y = D[4];
            3'b101: Y = D[5];
            3'b110: Y = D[6];
            3'b111: Y = D[7];
            default: Y = 1'b0; // Good practice to avoid latches
        endcase
    end

endmodule