module tb_up_counter_32bit;
    reg clk;
    reg reset;
    wire [31:0] count;

    up_counter_32bit uut (.clk(clk), .reset(reset), .count(count));

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | reset=%b | count=%d", $time, reset, count);
        
        clk = 0; reset = 1; // Start in reset state
        #12; 
        
        reset = 0; // Let it count
        #50;       // Wait a few clock cycles to watch it go 1, 2, 3...
        
        reset = 1; // Reset it back to 0
        #10;
        
        $finish;
    end
endmodule