module up_counter_32bit(
    input clk,
    input reset,
    output reg [31:0] count
);

    always @(posedge clk, posedge reset) begin
        if (reset)
            count <= 32'd0;
        else
            count <= count + 1; // Increment by 1
    end

endmodule