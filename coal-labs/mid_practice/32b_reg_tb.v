module tb_register_32bit;
    reg clk;
    reg reset;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Instantiate the register
    register_32bit uut (.clk(clk), .reset(reset), .data_in(data_in), .data_out(data_out));

    // Clock generation (Toggles every 5 time units)
    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | clk=%b | reset=%b | data_in=%h | data_out=%h", $time, clk, reset, data_in, data_out);
        
        clk = 0; reset = 1; data_in = 32'hAAAA_BBBB; 
        #15; // Wait for a bit
        
        reset = 0; // Release reset, data should be captured on next posedge
        #10;
        
        data_in = 32'h1234_5678; // Change input
        #10;
        
        reset = 1; // Assert reset again to see it clear instantly
        #10;
        
        $finish;
    end
endmodule