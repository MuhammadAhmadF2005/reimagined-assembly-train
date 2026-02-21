module up_counter32(
    input clk,
    input reset,
    output reg [31:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 32'b0;
    else
        count <= count + 1;  // Increment
end

endmodule
