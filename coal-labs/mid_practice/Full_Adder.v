module full_adder(
    input A, B, Cin,
    output Sum, Cout
);
    wire w1, w2, w3;

    // Sum = A XOR B XOR Cin so we need two xor gates
    xor x1 (w1, A, B);
    xor x2 (Sum, w1, Cin);

    // Cout = (A AND B) OR (Cin AND (A XOR B))
    and a1 (w2, A, B); // A and B
    and a2 (w3, w1, Cin);// w3 = A and B xor with cin
    or  o1 (Cout, w2, w3); //or both em

endmodule