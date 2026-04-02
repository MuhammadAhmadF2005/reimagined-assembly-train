// 1. The Combinational Adder Module
module adder_32_4(
    input [31:0] current_val,
    input [3:0] step,
    output [31:0] next_val
);
    assign next_val = current_val + step;
endmodule

// 2. The Sequential Register Module (Reused from Task 1!)
// We don't need to rewrite it, we just assume it exists in your project files.

// 3. The Top-Level Module integrating them
module program_counter_custom(
    input clk,
    input reset,
    input [3:0] step_val,
    output [31:0] count_out
);
    wire [31:0] next_count_wire;

    // Instantiate the Adder
    adder_32_4 my_adder (
        .current_val(count_out),   // Feedback the current count into the adder
        .step(step_val),           // The 4-bit number to add
        .next_val(next_count_wire) // Output of the adder
    );

    // Instantiate the 32-bit Register
    register_32bit my_register (
        .clk(clk),
        .reset(reset),
        .data_in(next_count_wire), // The adder output goes into the register input
        .data_out(count_out)       // The register output is the current count
    );

endmodule