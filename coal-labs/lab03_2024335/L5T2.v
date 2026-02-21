module data_memory(
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] mem [31:0];

// Write operation
always @(posedge clk) begin
    if (MemWrite)
        mem[address] <= write_data;
end

// Read operation
always @(posedge clk) begin
    if (MemRead)
        read_data <= mem[address];
end

endmodule
