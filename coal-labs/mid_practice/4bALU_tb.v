module tb_alu_4bit;
    // Inputs as reg
    reg [3:0] A, B;
    reg [3:0] Control;
    // Outputs as wire
    wire [3:0] ALUOut;

    // Instantiate Unit Under Test (UUT)
    alu_4bit uut (
        .A(A), 
        .B(B), 
        .Control(Control), 
        .ALUOut(ALUOut)
    );

    initial begin
        $monitor("Time=%0t | Ctrl=%d | A=%d B=%d | ALUOut=%d", $time, Control, A, B, ALUOut);
        
        // Test values
        A = 4'd10; B = 4'd5;
        
        Control = 4'd0;  #10; // AND (1010 & 0101 = 0000 = 0)
        Control = 4'd1;  #10; // OR  (1010 | 0101 = 1111 = 15)
        Control = 4'd2;  #10; // Add (10 + 5 = 15)
        Control = 4'd6;  #10; // Sub (10 - 5 = 5)
        
        // Test "Set Less Than" (A < B)
        Control = 4'd7;  #10; // Expect 0 because 10 is NOT less than 5
        A = 4'd3; B = 4'd8; 
        Control = 4'd7;  #10; // Expect 1 because 3 IS less than 8
        
        // Test NOR
        A = 4'd10; B = 4'd5;
        Control = 4'd12; #10; // NOR ~(1010 | 0101) = ~(1111) = 0000 = 0
        
        $finish;
    end
endmodule