module tb_demux_1x4;
    reg Din;
    reg [1:0] S;
    wire [3:0] Y;

    demux_1x4 uut (.Din(Din), .S(S), .Y(Y));

    integer i;

    initial begin
        $monitor("Time=%0t | Din=%b S=%b | Y=%b", $time, Din, S, Y);
        
        Din = 1'b1; // Hold data input high
        
        // Loop through all selection values
        for (i = 0; i < 4; i = i + 1) begin
            S = i; 
            #10;
        end
        
        // Test with Data input low to ensure it correctly routes 0
        Din = 1'b0;
        for (i = 0; i < 4; i = i + 1) begin
            S = i; 
            #10;
        end
        
        $finish;
    end
endmodule