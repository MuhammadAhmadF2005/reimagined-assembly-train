module memory32x32_tb;

reg clk;
reg [4:0] address;
wire [31:0] data_out;

memory32x32 uut (.clk(clk), .address(address), .data_out(data_out));

always #5 clk = ~clk;

initial begin
    clk = 0;
    address = 0;

    repeat (32) begin
        #10 address = address + 1;
    end

    #20 $finish;
end

endmodule
