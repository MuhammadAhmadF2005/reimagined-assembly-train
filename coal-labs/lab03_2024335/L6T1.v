module register_file(
    input clk,
    input reset,
    input RegWrite,
    input [4:0] ReadRegister1,
    input [4:0] ReadRegister2,
    input [4:0] WriteRegister,
    input [31:0] WriteData,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);

reg [31:0] registers [31:0];
integer i;

// Reset registers
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'b0;
    end
    else if (RegWrite && WriteRegister != 0) begin
        registers[WriteRegister] <= WriteData; // Write
    end
end

// Read registers
always @(posedge clk) begin
    ReadData1 <= registers[ReadRegister1];
    ReadData2 <= registers[ReadRegister2];
end

endmodule
