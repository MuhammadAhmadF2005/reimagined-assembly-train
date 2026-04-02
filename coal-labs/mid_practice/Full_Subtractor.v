module full_subtractor(
    input A, B, Bin,
    output Diff, Bout
);
    wire w1, w2, w3, w4, A_not;

    // Diff = A XOR B XOR Bin
    xor x1 (w1, A, B);
    xor x2 (Diff, w1, Bin);

    // Bout = A'B + A'Bin + BBin
    not n1 (A_not, A);
    and a1 (w2, A_not, B);
    and a2 (w3, A_not, Bin);
    and a3 (w4, B, Bin);
    or  o1 (Bout, w2, w3, w4);

endmodule