module alu_4bit(
    input [3:0] A, B,
    input [3:0] Control,
    output reg [3:0] ALUOut
);

    always @(*) begin
        case (Control)
            4'd0:  ALUOut = A & B;                 // AND
            4'd1:  ALUOut = A | B;                 // OR
            4'd2:  ALUOut = A + B;                 // Addition
            4'd6:  ALUOut = A - B;                 // Subtraction
            // Check if A < B (Set Less Than)
            // If true, output 0001. If false, output 0000.
            4'd7:  ALUOut = (A < B) ? 4'd1 : 4'd0; 
            4'd12: ALUOut = ~(A | B);              // NOR
            default: ALUOut = 4'd0;                // Default case
        endcase
    end

endmodule