module register32(
    input clk,
    input reset,
    input [31:0] d,
    output reg [31:0] q
);

// Register updates on rising clock edge
always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 32'b0;     // Clear register
    else
        q <= d;         // Store input data
end

endmodule
