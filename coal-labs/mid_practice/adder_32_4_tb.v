module tb_program_counter_custom;
    reg clk;
    reg reset;
    reg [3:0] step_val;
    wire [31:0] count_out;

    program_counter_custom uut (
        .clk(clk), 
        .reset(reset), 
        .step_val(step_val), 
        .count_out(count_out)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | reset=%b | step=%d | count_out=%d", $time, reset, step_val, count_out);
        
        clk = 0; reset = 1; step_val = 4'd4; // For RISC-V, PC usually increments by 4!
        #12;
        
        reset = 0; 
        #40; // Watch it jump: 0, 4, 8, 12, 16...
        
        step_val = 4'd2; // Change step to 2
        #30; // Watch it jump: 18, 20, 22...
        
        $finish;
    end
endmodule