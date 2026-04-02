module alu_32bit(
    input [31:0] A, B,
    input [3:0] Control,
    output reg [31:0] ALUOut,
    output wire Zero   // Declared as wire because we use 'assign' for it
);

    // Continuous assignment for the Zero flag. 
    // This evaluates to 1 if ALUOut is 0, and 0 otherwise.
    assign Zero = (ALUOut == 32'd0);

    always @(*) begin
        case (Control)
            4'd0:  ALUOut = A & B;                  // AND
            4'd1:  ALUOut = A | B;                  // OR
            4'd2:  ALUOut = A + B;                  // Addition
            4'd6:  ALUOut = A - B;                  // Subtraction
            // Set Less Than: Output 1 if A < B, padded to 32 bits
            4'd7:  ALUOut = (A < B) ? 32'd1 : 32'd0; 
            4'd12: ALUOut = ~(A | B);               // NOR
            default: ALUOut = 32'd0;
        endcase
    end

endmodule