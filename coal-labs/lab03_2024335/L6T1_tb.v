module register_file_tb;

reg clk, reset, RegWrite;
reg [4:0] RR1, RR2, WR;
reg [31:0] WD;
wire [31:0] RD1, RD2;

register_file uut (
    .clk(clk),
    .reset(reset),
    .RegWrite(RegWrite),
    .ReadRegister1(RR1),
    .ReadRegister2(RR2),
    .WriteRegister(WR),
    .WriteData(WD),
    .ReadData1(RD1),
    .ReadData2(RD2)
);

always #5 clk = ~clk;

initial begin
    // Enable waveform dump
    $dumpfile("register_file.vcd");
    $dumpvars(0, register_file_tb);

    clk = 0; reset = 1; RegWrite = 0;
    #10 reset = 0;

    // Write registers
    #10 RegWrite = 1; WR = 5; WD = 100;
    #10 WR = 10; WD = 200;

    // Read registers
    #10 RegWrite = 0; RR1 = 5; RR2 = 10;

    #20 $finish;
end

endmodule
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
