module register_32bit(
    input clk,
    input reset,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    always @(posedge clk, posedge reset) begin
        if (reset)
            data_out <= 32'd0;       // Clear the output if reset is high
        else
            data_out <= data_in;     // Capture input on clock edge
    end

endmodule