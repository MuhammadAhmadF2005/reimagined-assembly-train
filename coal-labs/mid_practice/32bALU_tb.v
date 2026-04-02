module tb_alu_32bit;
    // Inputs as reg
    reg [31:0] A, B;
    reg [3:0] Control;
    // Outputs as wire
    wire [31:0] ALUOut;
    wire Zero;

    // Instantiate Unit Under Test
    alu_32bit uut (
        .A(A), 
        .B(B), 
        .Control(Control), 
        .ALUOut(ALUOut), 
        .Zero(Zero)
    );

    initial begin
        // Displaying in Hexadecimal (%h) because 32-bit binary is too long to read easily
        $monitor("Time=%0t | Ctrl=%d | A=%h B=%h | ALUOut=%h | Zero=%b", 
                 $time, Control, A, B, ALUOut, Zero);
        
        // Test Addition
        A = 32'h0000_0010; B = 32'h0000_0020;
        Control = 4'd2; #10;
        
        // Test Subtraction
        A = 32'h0000_0050; B = 32'h0000_0020;
        Control = 4'd6; #10;
        
        // Test Zero Flag (Subtraction where A == B)
        A = 32'h0000_00AA; B = 32'h0000_00AA;
        Control = 4'd6; #10; // 0xAA - 0xAA = 0. Zero flag should jump to 1 here!
        
        // Test Set Less Than (A < B)
        A = 32'd150; B = 32'd500;
        Control = 4'd7; #10; // Expect ALUOut = 1, Zero = 0
        
        $finish;
    end
endmodule