// ========================================
// Top Module: Counter + Adder Connection
// ========================================

module counter_with_adder (
    input clk,
    input reset,
    input [3:0] add_value,
    output [31:0] count
);

    wire [31:0] adder_out;   // Connects adder to counter

    // Instantiate Adder
    adder_32_4 ADDER (
        .A(count),
        .B(add_value),
        .Sum(adder_out)
    );

    // Instantiate Counter
    counter32 COUNTER (
        .clk(clk),
        .reset(reset),
        .next_value(adder_out),
        .count(count)
    );

endmodule



module adder_32_4 (
    input  [31:0] A,       // Current counter value
    input  [3:0]  B,       // 4-bit number to add
    output [31:0] Sum      //sum
);

assign Sum = A + {{28{1'b0}}, B};

endmodule


module counter32 (
    input clk,
    input reset,
    input [31:0] next_value,  // Value to load
    output reg [31:0] count
);

    // Counter updates on positive clock edge
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 32'b0;     // Reset to zero
        else
            count <= next_value; // Load new value
    end

endmodule
