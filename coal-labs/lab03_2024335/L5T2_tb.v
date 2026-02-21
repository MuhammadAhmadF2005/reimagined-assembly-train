module data_memory_tb;

reg clk, MemWrite, MemRead;
reg [31:0] address, write_data;
wire [31:0] read_data;

data_memory uut (
    .clk(clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);

always #5 clk = ~clk;

initial begin
    // Enable waveform dump
    $dumpfile("data_memory.vcd");
    $dumpvars(0, data_memory_tb);

    clk = 0;
    MemWrite = 0; MemRead = 0;

    // Write data
    #10 MemWrite = 1; address = 5; write_data = 100;
    #10 MemWrite = 1; address = 10; write_data = 200;

    // Read data
    #10 MemWrite = 0; MemRead = 1; address = 5;
    #10 address = 10;

    #20 $finish;
end

endmodule
