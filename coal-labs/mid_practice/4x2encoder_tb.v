module tb_encoder_4x2;
    reg [3:0] D;
    wire [1:0] Y;

    encoder_4x2 uut (.D(D), .Y(Y));

    initial begin
        $monitor("Time=%0t | D=%b | Y=%b", $time, D, Y);
        
        D = 4'b0001; #10; // Input 0 active -> Output 00
        D = 4'b0010; #10; // Input 1 active -> Output 01
        D = 4'b0100; #10; // Input 2 active -> Output 10
        D = 4'b1000; #10; // Input 3 active -> Output 11
        
        $finish;
    end
endmodule