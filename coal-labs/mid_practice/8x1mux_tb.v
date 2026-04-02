module tb_mux_8x1;
    reg [7:0] D;
    reg [2:0] S;
    wire Y;

    mux_8x1 uut (.D(D), .S(S), .Y(Y));

    integer i;

    initial begin
        $monitor("Time=%0t | S=%b | D=%b | Y=%b", $time, S, D, Y);
        
        // Give D a recognizable pattern
        D = 8'b10101100; 
        
        // Loop through all selection values
        for (i = 0; i < 8; i = i + 1) begin
            S = i; 
            #10;
        end
        
        $finish;
    end
endmodule