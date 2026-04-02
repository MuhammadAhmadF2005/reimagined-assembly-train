module demux_1x4(
    input Din,
    input [1:0] S,
    output [3:0] Y
);
    wire S0n, S1n;

    // Invert selection lines
    not n0 (S0n, S[0]);
    not n1 (S1n, S[1]);

    // Route input to the selected output
    and a0 (Y[0], Din, S1n, S0n);
    and a1 (Y[1], Din, S1n, S[0]);
    and a2 (Y[2], Din, S[1], S0n);
    and a3 (Y[3], Din, S[1], S[0]);

endmodule