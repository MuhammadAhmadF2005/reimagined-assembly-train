module memory32x32(
    input clk,
    input [4:0] address,
    output reg [31:0] data_out
);

reg [31:0] mem [31:0];
integer i;

// Initialize memory
initial begin
    for (i = 0; i < 32; i = i + 1)
        mem[i] = i;
end

always @(posedge clk) begin
    data_out <= mem[address];   // Read data
end

endmodule
