// ==========================================
// Category 1: Combinational Logic
// ========================================== 

// 1. 32-bit Custom ALU
module ALU_32bit (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_Sel,
    output reg [31:0] Result,
    output Zero
);
    // Zero flag (1 if Result is entirely 0)
    assign Zero = (Result == 32'd0);

    always @(*) begin
        case (ALU_Sel)
            3'b000: Result = A + B;
            3'b001: Result = A - B;
            3'b010: Result = A & B;
            3'b011: Result = A | B;
            3'b100: Result = (A < B) ? 32'd1 : 32'd0;
            default: Result = 32'd0;
        endcase
    end
endmodule

// 2a. Dataflow vs. Behavioral: 4-to-1 Multiplexer (Continuous Assignment)
module Mux4_1_Dataflow (
    input [3:0] in,
    input [1:0] sel,
    output out
);
    // Using conditional ?: operators
    assign out = (sel == 2'b00) ? in[0] :
                 (sel == 2'b01) ? in[1] :
                 (sel == 2'b10) ? in[2] :
                                  in[3];
endmodule

// 2b. Dataflow vs. Behavioral: 4-to-1 Multiplexer (Behavioral)
module Mux4_1_Behavioral (
    input [3:0] in,
    input [1:0] sel,
    output reg out
);
    // Using an always block with a case statement
    always @(*) begin
        case (sel)
            2'b00: out = in[0];
            2'b01: out = in[1];
            2'b10: out = in[2];
            2'b11: out = in[3];
            default: out = 1'b0;
        endcase
    end
endmodule

// 3. The casez Trap: 4-bit priority encoder using casez
/* 
Explanation: casez is preferred for priority logic over 'case' or 'casex'.
1) Standard 'case' requires writing out every single exact combination, scaling poorly.
2) 'casex' treats both 'x' (unknown) and 'z' (high-Z) as don't cares. 
   This can mask actual 'x' logic errors and cause simulation mismatches vs hardware behavior!
3) 'casez' treats ONLY 'z' (or '?') as don't cares, which is safer and perfectly fits logic 
   where lower-priority bits don't matter as long as a higher-priority bit is set.
*/
module Priority_Encoder_4bit (
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);
    always @(*) begin
        valid = 1'b1;
        casez (in)
            4'b1???: out = 2'b11; // Highest priority
            4'b01??: out = 2'b10;
            4'b001?: out = 2'b01;
            4'b0001: out = 2'b00; // Lowest priority
            default: begin
                out = 2'b00;
                valid = 1'b0;      // No bit set
            end
        endcase
    end
endmodule

// ==========================================
// Category 2: Sequential Circuits (Flip-Flops & Counters)
// ==========================================

// 1. Flip-Flop Conversion/Design: T Flip-Flop with active-low asynchronous reset
module T_FF_AsyncReset (
    input clk,
    input rst_n, // active-low async reset
    input T,
    output reg Q
);
    // Note the negedge rst_n for asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 1'b0;
        else if (T)
            Q <= ~Q;
    end
endmodule

// 1b. D Latch (Level-Sensitive)
module D_Latch (
    input en,
    input D,
    output reg Q
);
    // Level-sensitive: triggers when 'en' or 'D' changes
    always @(en or D) begin
        if (en)
            Q <= D;
    end
endmodule

// 1c. SR Latch (Behavioral)
module SR_Latch (
    input en,
    input S,
    input R,
    output reg Q
);
    always @(en or S or R) begin
        if (en) begin
            case ({S, R})
                2'b10: Q <= 1'b1; // Set
                2'b01: Q <= 1'b0; // Reset
                2'b11: Q <= 1'bx; // Invalid state
                default: Q <= Q;  // 00 = Hold state
            endcase
        end
    end
endmodule

// 1d. D Flip-Flop (Edge-Triggered) with Synchronous Reset
module D_FF_SyncReset (
    input clk,
    input rst, // sync reset
    input D,
    output reg Q
);
    always @(posedge clk) begin
        if (rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule

// 1e. JK Flip-Flop (Edge-Triggered)
module JK_FF (
    input clk,
    input rst_n, // active-low async reset
    input J,
    input K,
    output reg Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 1'b0;
        else begin
            case ({J, K})
                2'b00: Q <= Q;       // Hold
                2'b01: Q <= 1'b0;    // Reset
                2'b10: Q <= 1'b1;    // Set
                2'b11: Q <= ~Q;      // Toggle
            endcase
        end
    end
endmodule

// 2. The Custom Counter: 5-bit Up/Down counter
module Counter_5bit_UpDown (
    input clk,
    input sync_rst, // synchronous reset
    input DIR,
    output reg [4:0] count
);
    // Only sensitive to clock edge, making reset synchronous
    always @(posedge clk) begin
        if (sync_rst)
            count <= 5'b00000;
        else if (DIR == 1'b1)
            count <= count + 5'd1;  // counts up
        else
            count <= count - 5'd1;  // counts down
    end
endmodule

// 3. The Modulo Constraint: BCD Counter (0 to 9)
module BCD_Counter (
    input clk,
    input rst,
    output reg [3:0] bcd
);
    always @(posedge clk) begin
        if (rst)
            bcd <= 4'b0000;
        else if (bcd == 4'd9) // Wraps back to 0 at 9
            bcd <= 4'b0000;
        else
            bcd <= bcd + 4'd1;
    end
endmodule

// 4. Coding Pitfalls: Blocking (=) vs Non-blocking (<=) Assignments
/*
Explanation: 
In sequential clocked blocks, blocking assignments (`=`) evaluate and assign variables sequentially. 
If 'q2 = q1' follows 'q1 = d', 'q2' receives the newly updated value of 'q1' immediately within the same clock edge!
Non-blocking assignments (`<=`), however, evaluate all right-hand sides at the start of the 
timestep and assign them all simultaneously at the end, correctly modeling parallel flip-flop stages.

// Failing Shift Register (using '=' inside a clocked block)
module ShiftRegister_Bad(input clk, input d, output reg q1, q2, q3);
    always @(posedge clk) begin
        // Everything shifts through in ONE cycle instantly! Race condition occurs.
        q1 = d;
        q2 = q1; // gets 'd' immediately
        q3 = q2; // gets 'd' immediately
    end
endmodule
*/

// ==========================================
// Category 3: Memories, Arrays, and Vectors
// ==========================================

/*
Question Answers inline:
1. Memory Instantiation (Declaration):
   reg [15:0] RAM [127:0]; // 128 words, each 16 bits wide

2. Addressing Math:
   Array declared as: reg [31:0] data_mem [255:0];
   Total locations = 256. Address width required = log2(256) = 8 bits.
*/

// Always block to read from this memory asynchronously:
module Memory_Read_Async (
    input [7:0] Address,
    output reg [31:0] ReadData
);
    reg [31:0] data_mem [255:0];
    
    // An always block triggering on ANY change in Address
    always @(*) begin
        ReadData = data_mem[Address];
    end
endmodule

// 3. The Instruction Fetcher (Concatenation)
module Instruction_Fetcher (
    input [31:0] Program_Counter,
    output wire [31:0] Instruction
);
    reg [7:0] ROM [127:0];

    // Using concatenation operator { } to fetch 4 bytes simultaneously
    // Assumes Big-Endian structure
    assign Instruction = { ROM[Program_Counter], 
                           ROM[Program_Counter+1], 
                           ROM[Program_Counter+2], 
                           ROM[Program_Counter+3] };
endmodule

// ==========================================
// Category 4: Register Files & Structural Instantiation
// ==========================================

// 1. The Hardwired Register File
module Register_File_32x32 (
    input clk,
    input RegWrite,
    input [4:0] ReadAddr1,
    input [4:0] ReadAddr2,
    input [4:0] WriteAddr,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);
    reg [31:0] registers [31:0];
    
    // Register 0 is hardwired to 0 (reads output 0 if address is 0)
    assign ReadData1 = (ReadAddr1 == 5'd0) ? 32'd0 : registers[ReadAddr1];
    assign ReadData2 = (ReadAddr2 == 5'd0) ? 32'd0 : registers[ReadAddr2];

    // Synchronous write
    always @(posedge clk) begin
        // Any attempt to write to addr 0 is ignored
        if (RegWrite && (WriteAddr != 5'd0)) begin
            registers[WriteAddr] <= WriteData;
        end
    end
endmodule

// 2. Datapath Wiring (Structural Instantiation Example)

// Provided modules defined first:
module PC_Reg (
    input clk, 
    input reset, 
    input [31:0] next_PC, 
    output reg [31:0] current_PC
);
    always @(posedge clk) begin
        if (reset) current_PC <= 32'd0;
        else current_PC <= next_PC;
    end
endmodule

module Adder_32 (
    input [31:0] A, 
    input [31:0] B, 
    output [31:0] Sum
);
    assign Sum = A + B;
endmodule

// Top-Level Module instantiating both PC_Reg and Adder_32
module Top_ProgramCounter (
    input clk,
    input reset,
    output [31:0] current_PC
);
    // Internal wire to connect Adder output to PC input
    wire [31:0] next_PC_wire;
    
    // EXAMPLE CONNECTION: Connecting multiple modules using instantiation
    
    // 1st instance: Program Counter Register
    PC_Reg program_counter_inst (
        .clk(clk),
        .reset(reset),
        .next_PC(next_PC_wire), // connects from the wire
        .current_PC(current_PC)
    );
    
    // 2nd instance: ALU/Adder to increment by 4
    Adder_32 pc_adder_inst (
        .A(current_PC),         // feeds back current PC
        .B(32'd4),              // hardcoded literal 4
        .Sum(next_PC_wire)      // outputs to the wire
    );
endmodule

// ==========================================
// Category 5: Testbenches and Verification
// ==========================================

module tb_ALU_32bit;
    
    // 1. Stimulus variables declared as reg
    reg [31:0] tb_A;
    reg [31:0] tb_B;
    reg [2:0] tb_ALU_Sel;
    reg clk;
    
    // 2. Output variables declared as wire
    wire [31:0] tb_Result;
    wire tb_Zero;
    
    // Instantiate the ALU module
    ALU_32bit uut (
        .A(tb_A),
        .B(tb_B),
        .ALU_Sel(tb_ALU_Sel),
        .Result(tb_Result),
        .Zero(tb_Zero)
    );
    
    // Clock Generation: 50 MHz (Period = 20ns) -> Toggle every 10ns
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk; 
    end
    
    // Comprehensive Stimulus Block
    initial begin
        // Setup outputs for GTKWave or EDA Playground Simulation
        $dumpfile("alu_simulation.vcd");
        $dumpvars(0, tb_ALU_32bit); // Dumps everything internally
        
        // Setup print monitoring
        $monitor("Time=%0t | A=%d, B=%d | ALU_Sel=%b | Result=%d | Zero=%b", 
                  $time, tb_A, tb_B, tb_ALU_Sel, tb_Result, tb_Zero);

        // Initialize values
        tb_A = 32'd0;
        tb_B = 32'd0;
        tb_ALU_Sel = 3'b000;
        
        // Delay before beginning
        #10;
        
        // Test Addition: 15 + 10
        tb_A = 32'd15;
        tb_B = 32'd10;
        tb_ALU_Sel = 3'b000;
        #10;
        
        // Test Subtraction: 30 - 20
        tb_A = 32'd30;
        tb_B = 32'd20;
        tb_ALU_Sel = 3'b001;
        #10;
        
        // Test AND: Bitwise
        tb_A = 32'h0000_00FF;
        tb_B = 32'h0000_0F0F;
        tb_ALU_Sel = 3'b010;
        #10;
        
        // Test OR: Bitwise
        tb_ALU_Sel = 3'b011;
        #10;
        
        // Test Set on Less Than (True)
        tb_A = 32'd5;
        tb_B = 32'd100;
        tb_ALU_Sel = 3'b100;
        #10;
        
        // Test Zero Flag (Subtraction where Result = 0)
        tb_A = 32'd42;
        tb_B = 32'd42;
        tb_ALU_Sel = 3'b001; 
        #10;

        // Give extra time for simulation to end nicely
        #20;
        $display("Simulation Stimulus Complete!");
        $finish;
    end
endmodule

// ==========================================
// Category 6: ROM, Processor Datapath, and Counters
// ==========================================

// 1. ROM (Read-Only Memory)
module ROM_Memory (
    input [7:0] Address,
    output reg [31:0] DataOut
);
    // Simple asynchronous ROM implemented with a case statement
    always @(*) begin
        case (Address)
            8'd0:  DataOut = 32'h0000_000A; // 10
            8'd1:  DataOut = 32'h0000_0014; // 20
            8'd2:  DataOut = 32'h0000_0028; // 40
            8'd3:  DataOut = 32'h0000_003C; // 60
            default: DataOut = 32'h0000_0000;
        endcase
    end
endmodule

// 2. Simple 2-to-1 Multiplexer for Datapath
module Mux2_1_32bit (
    input [31:0] in0,
    input [31:0] in1,
    input sel,
    output [31:0] out
);
    assign out = sel ? in1 : in0;
endmodule

// 3. Simple 32-bit Register
module Register_32bit (
    input clk,
    input reset,
    input load,
    input [31:0] D,
    output reg [31:0] Q
);
    // Register with asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 32'd0;
        else if (load)
            Q <= D;
    end
endmodule

// 4. Simple Counter for generating Addresses
module Address_Counter (
    input clk,
    input reset,
    input enable,
    output reg [7:0] count
);
    // Counter with asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 8'd0;
        else if (enable)
            count <= count + 8'd1;
    end
endmodule

// 5. Complete Datapath Circuit Example
// This connects the counter -> ROM -> Adder -> Mux -> Register -> Feedback to Adder
module Simple_Datapath (
    input clk,
    input reset,
    input start_counter,
    input [31:0] external_data,
    input mux_sel,       // 0 for external data, 1 for Adder feedback
    input reg_load,
    output [31:0] datapath_out
);
    
    wire [7:0] rom_addr;
    wire [31:0] rom_data;
    wire [31:0] mux_out;
    wire [31:0] reg_out;
    wire [31:0] adder_out;

    // 5a. A counter to step through ROM addresses
    Address_Counter addr_cntr (
        .clk(clk),
        .reset(reset),
        .enable(start_counter),
        .count(rom_addr)
    );

    // 5b. ROM containing data/constants to add
    ROM_Memory data_rom (
        .Address(rom_addr),
        .DataOut(rom_data)
    );

    // 5c. Adder combining Register output (accumulator) and ROM data
    // (Re-using the Adder_32 module defined earlier in Category 4)
    Adder_32 datapath_adder (
        .A(reg_out),
        .B(rom_data),
        .Sum(adder_out)
    );

    // 5d. Mux selecting between external data and Adder feedback
    Mux2_1_32bit data_mux (
        .in0(external_data),
        .in1(adder_out),
        .sel(mux_sel),
        .out(mux_out)
    );

    // 5e. Register storing the current accumulation
    Register_32bit accumulator_reg (
        .clk(clk),
        .reset(reset),
        .load(reg_load),
        .D(mux_out),
        .Q(reg_out)
    );

    // Assign final output
    assign datapath_out = reg_out;

endmodule

// ==========================================
// Testbench Suite: Category 1 (Combinational Logic)
// ==========================================

// ------------------------------------------
// tb_Mux
// ------------------------------------------
module tb_Mux4_1;
    reg [3:0] in;
    reg [1:0] sel;
    wire out_dataflow;
    wire out_behavioral;

    Mux4_1_Dataflow u1 (.in(in), .sel(sel), .out(out_dataflow));
    Mux4_1_Behavioral u2 (.in(in), .sel(sel), .out(out_behavioral));

    initial begin
        $display("\n--- Testing Mux4_1 ---");
        $monitor("Time=%0t | in=%b, sel=%b | dataflow out=%b | behavioral out=%b", 
                 $time, in, sel, out_dataflow, out_behavioral);
        in = 4'b1010;
        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;
    end
endmodule

// ------------------------------------------
// tb_PriorityEncoder
// ------------------------------------------
module tb_Priority_Encoder;
    reg [3:0] in;
    wire [1:0] out;
    wire valid;

    Priority_Encoder_4bit uut (.in(in), .out(out), .valid(valid));

    initial begin
        $display("\n--- Testing Priority Encoder ---");
        $monitor("Time=%0t | in=%b -> out=%b, valid=%b", $time, in, out, valid);
        in = 4'b0000; #10;
        in = 4'b0001; #10;
        in = 4'b0010; #10;
        in = 4'b0100; #10;
        in = 4'b1000; #10;
        in = 4'b1111; #10;
    end
endmodule

// ==========================================
// Testbench Suite: Category 2 (Sequential Circuits)
// ==========================================

// ------------------------------------------
// tb_Latches
// ------------------------------------------
module tb_Latches;
    reg en, D, S, R;
    wire Q_D, Q_SR;

    D_Latch dl (.en(en), .D(D), .Q(Q_D));
    SR_Latch srl (.en(en), .S(S), .R(R), .Q(Q_SR));

    initial begin
        $display("\n--- Testing Latches ---");
        $monitor("Time=%0t | en=%b | D=%b -> Q_D=%b | S=%b, R=%b -> Q_SR=%b", 
                 $time, en, D, Q_D, S, R, Q_SR);
                 
        en = 0; D = 0; S = 0; R = 0; #10;
        en = 1; D = 1; S = 1; R = 0; #10; // Set SR, D is 1
        D = 0; S = 0; R = 1; #10;         // Reset SR, D is 0
        en = 0; D = 1; S = 1; R = 0; #10; // Disabled, holds old value
    end
endmodule

// ------------------------------------------
// tb_FlipFlops
// ------------------------------------------
module tb_FlipFlops;
    reg clk, rst, rst_n, D, J, K, T;
    wire Q_D, Q_JK, Q_T;

    D_FF_SyncReset dff (.clk(clk), .rst(rst), .D(D), .Q(Q_D));
    JK_FF jkff (.clk(clk), .rst_n(rst_n), .J(J), .K(K), .Q(Q_JK));
    T_FF_AsyncReset tff (.clk(clk), .rst_n(rst_n), .T(T), .Q(Q_T));

    always #5 clk = ~clk;

    initial begin
        $display("\n--- Testing Flip-Flops ---");
        clk = 0; rst = 1; rst_n = 0; D = 0; J = 0; K = 0; T = 0; #10; // Global reset
        rst = 0; rst_n = 1; 
        
        // Test D-FF
        D = 1; #10;
        D = 0; #10;

        // Test JK-FF
        J = 1; K = 0; #10; // Set
        J = 0; K = 1; #10; // Reset
        J = 1; K = 1; #20; // Toggle twice

        // Test T-FF
        T = 1; #20; // Toggle twice
        T = 0; #10;
    end
endmodule

// ------------------------------------------
// tb_Counters
// ------------------------------------------
module tb_Counters;
    reg clk, sync_rst, DIR, bcd_rst;
    wire [4:0] count_updown;
    wire [3:0] bcd;

    Counter_5bit_UpDown actr (.clk(clk), .sync_rst(sync_rst), .DIR(DIR), .count(count_updown));
    BCD_Counter bctr (.clk(clk), .rst(bcd_rst), .bcd(bcd));

    always #5 clk = ~clk;

    initial begin
        $display("\n--- Testing Counters ---");
        clk = 0; sync_rst = 1; bcd_rst = 1; DIR = 1; #10;
        sync_rst = 0; bcd_rst = 0;
        
        #90; // Let BCD wrap around and Down counter go up
        DIR = 0;
        #50; // Count down
    end
endmodule

// ==========================================
// Testbench Suite: Datapath & Register File
// ==========================================

// ------------------------------------------
// tb_SimpleDatapath
// ------------------------------------------
module tb_Datapath_System;
    reg clk, reset, start_counter, mux_sel, reg_load;
    reg [31:0] external_data;
    wire [31:0] datapath_out;

    Simple_Datapath dp (
        .clk(clk), 
        .reset(reset), 
        .start_counter(start_counter),
        .external_data(external_data), 
        .mux_sel(mux_sel), 
        .reg_load(reg_load),
        .datapath_out(datapath_out)
    );

    always #5 clk = ~clk;

    initial begin
        $display("\n--- Testing Datapath Integration ---");
        $monitor("Time=%0t | mux_sel=%b, start_counter=%b, DP_Output=%d", 
                 $time, mux_sel, start_counter, datapath_out);
        clk = 0; reset = 1; start_counter = 0; mux_sel = 0; reg_load = 0; external_data = 32'd100; #10;
        reset = 0;
        
        // Load external data
        mux_sel = 0; reg_load = 1; #10;
        
        // Start adder sequence using ROM constants adding to external_data baseline
        mux_sel = 1; start_counter = 1;
        #50; // Accumulate over 5 cycles
        
        $display("Testbench Suite Execution Finished.");
        $finish;
    end
endmodule


module decoder (
	input a,
	input b,
	output y0,
	output y1,
	output y2,
	output y3
);

wire abar;
wire bbar;

not (abar, a);
not (bbar, b);
and (y0, abar, bbar);
and (y1, abar, b);
and (y2, a, bbar);
and (y3, a, b);

endmodule


module TB();

reg a, b;
wire y0, y1, y2, y3;

decoder uut(a, b, y0, y1, y2, y3);

initial begin

    $dumpfile("decoder.vcd");
    $dumpvars(0, TB);

    #10
    a = 0;
    b = 0; #10;

    a = 0;
    b = 1; #10;
    $finish;

end
endmodule


module priority_encoder(
    input [3:0] in,
    output reg [1:0] code,
    output reg valid

);

// if multiple bits are high code represents highest active bit

always @(*) begin
    casez (in)
        4'b0000: begin code = 2'b00; valid = 0; end
        4'b0001: begin code = 2'b00; valid = 1; end
        4'b001?: begin code = 2'b01; valid = 1; end
        4'b01??: begin code = 2'b10; valid = 1; end
        4'b1???: begin code = 2'b11; valid = 1; end
    endcase
end
endmodule 

module TB();

reg [3:0] in;
wire [1:0] code;
wire valid;

priority_encoder uut(in, code, valid);

initial begin

    $dumpfile("encoder.vcd");
    $dumpvars(0, TB);

    in = 4'b0000; #10;
    in = 4'b0001; #10;
    in = 4'b0010; #10;
    in = 4'b0011; #10;
    $finish ;

end
endmodule

module alu(A, B, Op, alu_out);
input [3:0] A, B;
input [2:0] Op;
output reg [3:0] alu_out;
always@(*) // always block for behavorial modelling
begin 
case(Op)
    3'b000: alu_out = 0;
    3'b001: alu_out = A + B;
    3'b010: alu_out = A - B;
    3'b011: alu_out = A & B;
    3'b100: alu_out = A | B;
    3'b101: alu_out = A ^ B;
    3'b110: alu_out = ~A;
    3'b111: alu_out = A << 1;

endcase 
end


// input -> reg 
// output -> wire

// testbench
module TB()
reg [3:0] A, B;
reg [2:0] Op;
wire [3:0] alu_out;

alu uut(A, B, Op, alu_out);

initial begin
  Op = 3'b000; A = 4'b0000; B = 4'b0000; #10;

end

module counter
(
    input clk, reset,
    output reg [5:0] count
);


always @ (posedge clk)
begin 
    if (reset)
        count <= 0;
    
    else if (count == 31)
        count <= 0;

    else
        count <= count + 1;
end 
endmodule

module adder 
(
    input clk,
    input [4:0] a,
    input [5:0] b,
    output reg [5:0] sum
);

always @ (posedge clk)
    begin
        sum <= a + b;
    end
endmodule


module mod_10(
    input clk, reset,
    output reg [3:0] count
);

always @ (posedge clk)
begin
    if (reset)
        count <= 0;
    else if (count == 9)
        count <= 0;
    else
        count <= count + 1;
end

endmodule 

module TB();

reg clk, reset;
wire [3:0] count;

mod_10 uut(clk, reset, count);

always #5 clk = ~clk;

initial begin

    $dumpfile ("mod10.vcd");
    $dumpvars (0, TB);

    clk = 0;
    reset = 1; #10;
    reset = 0; #10;
    $finish;
end
endmodule



module register_file
(
    input [31:0] data_in,
    output reg [31:0] data_out,
    input clk, reset, en

);

always @ (posedge clk, posedge reset)
begin
    if (reset)
        data_out <= 32'b0;
    else if (en)
        data_out <= data_in;
end
endmodule


module TB();

    reg [31:0] data_in;
    reg clk, reset, en;
    wire [31:0] data_out;

register_file uut(data_in, data_out, clk, reset, en);

always #5 clk = ~clk;

initial begin 
    $dumpfile("register_file.vcd");
    $dumpvars(0, TB);
    
    data_in = 0;
    clk = 0;
    reset = 1;
    en = 0;

    #10

    en =1;
    reset = 0;
    data_in = 10;
    #10
    data_in = 20;
    #10
    data_in = 30;
    #10
    $finish;

end
endmodule


module register (
    input clk, reset,
    input [4:0] R1,
    input [4:0] R2,
    input [4:0] Write,
    input [31:0] Write_Data,
    output reg [31:0] Read_Data1,
    output reg [31:0] Read_Data2,
    input RegWrite
);

always @ (posedge clk) begin
    if (reset) begin
        Read_Data1 <= 0;
        Read_Data2 <= 0;
    end
    else if (RegWrite) begin
        if (Write == R1)
            Read_Data1 <= Write_Data;
        if (Write == R2)
            Read_Data2 <= Write_Data;
    end
end
endmodule

module TB();

    reg clk, reset;
    reg [4:0] R1;
    reg [4:0] R2;
    reg [4:0] Write;
    reg [31:0] Write_Data;
    wire [31:0] Read_Data1;
    wire [31:0] Read_Data2;
    reg RegWrite;

    always #5 clk = ~clk;

    initial begin
        $dumpfile ("registerr.vcd");
        $dumpvars (0, TB);
        $monitor ("Time %t, Read_Data1 = %b, Read_Data2 = %b", $time, Read_Data1, Read_Data2);

        R1 = 5'b00001;
        R2 = 5'b00010;
        Write = 5'b00001;
        Write_Data = 32'hDEADBEEF;
        clk = 0;
        reset = 1; #10;
        reset = 0; RegWrite = 1; #10;
        Write = 5'b00010;
        Write_Data = 32'hCAFEBABE; #10;
        $finish;
        

    end
endmodule

// ==========================================
// Category 7: Shift Registers (PISO, SISO)
// ==========================================

// 1. Parallel-In Serial-Out (PISO) Shift Register (4-bit)
module PISO_4bit (
    input clk,
    input load,       // 1 = load parallel data, 0 = shift
    input [3:0] pin,  // Parallel input
    output reg sout   // Serial output
);
    reg [3:0] shift_reg;
    always @(posedge clk) begin
        if (load)
            shift_reg <= pin;
        else begin
            sout <= shift_reg[0];                // Shift out LSB
            shift_reg <= {1'b0, shift_reg[3:1]}; // Shift right
        end
    end
endmodule

// 2. Serial-In Serial-Out (SISO) Shift Register (4-bit)
module SISO_4bit (
    input clk,
    input sin,        // Serial input
    output reg sout   // Serial output
);
    reg [3:0] shift_reg;
    always @(posedge clk) begin
        shift_reg <= {sin, shift_reg[3:1]};  // Shift right, sin goes into MSB
        sout <= shift_reg[0];                // LSB shifted out
    end
endmodule

// ==========================================
// Category 8: PC, Instruction Count, Vectors & Arrays
// ==========================================

// 1. Program Counter
module Program_Counter_Simple (
    input clk,
    input reset,
    input enable,
    input [31:0] next_pc,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'd0;
        else if (enable)
            pc <= next_pc;
    end
endmodule

// 2. Instruction Counter (Counts retired instructions)
module Instruction_Counter (
    input clk,
    input reset,
    input instruction_commit, // Pulses high when an instruction finishes
    output reg [31:0] inst_count
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            inst_count <= 32'd0;
        else if (instruction_commit)
            inst_count <= inst_count + 32'd1;
    end
endmodule

// 3. Examples of Vectors and Arrays
// In Verilog, a 'vector' is a multiple-bit data type (like a bus or register).
// An 'array' is a collection of vectors (or scalars), typically used for memories.

module Vectors_and_Arrays_Examples (
    input clk,
    // Vector (Packed Array) declarations (single dimension chunk of bits):
    input [31:0] vector_in,    // 32-bit vector
    output reg [7:0] byte_out  // 8-bit vector
);
    // Array (Unpacked Array) declarations (multiple elements of a certain width):
    // Syntax: reg [width-1:0] name [depth-1:0];
    
    // Example: Array of 16 elements, each 8 bits wide (like a mini RAM)
    reg [7:0] memory_array [0:15];
    
    // Example: 2D Array (Matrix of 4 vectors, each 4 bits wide)
    reg [3:0] matrix [0:3];
    
    integer i;

    initial begin
        // Initializing the memories
        for (i = 0; i < 16; i = i + 1) begin
            memory_array[i] = i; 
        end
    end

    // Accessing elements
    always @(posedge clk) begin
        // Example: Assign an output vector from an array indexed by a slice of vector_in
        byte_out <= memory_array[vector_in[3:0]];
    end
endmodule

// ==========================================
// Testbench Suite: Category 3, 7, 8 & User Modules
// ==========================================

// ------------------------------------------
// tb_Memory_and_Fetcher
// ------------------------------------------
module tb_Memory_and_Fetcher;
    reg [7:0] Address;
    wire [31:0] ReadData;
    Memory_Read_Async u_mem (.Address(Address), .ReadData(ReadData));

    reg [31:0] PC;
    wire [31:0] Instruction;
    Instruction_Fetcher u_fetch (.Program_Counter(PC), .Instruction(Instruction));

    initial begin
        $dumpfile("mem_fetch.vcd");
        $dumpvars(0, tb_Memory_and_Fetcher);
        Address = 8'd0; PC = 32'd0; #10;
        Address = 8'd10; PC = 32'd4; #10;
        $display("tb_Memory_and_Fetcher Complete");
    end
endmodule

// ------------------------------------------
// tb_Shift_Registers (PISO, SISO)
// ------------------------------------------
module tb_Shift_Registers;
    reg clk, load, sin;
    reg [3:0] pin;
    wire sout_piso, sout_siso;

    PISO_4bit piso (.clk(clk), .load(load), .pin(pin), .sout(sout_piso));
    SISO_4bit siso (.clk(clk), .sin(sin), .sout(sout_siso));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("shift_regs.vcd");
        $dumpvars(0, tb_Shift_Registers);
        clk = 0; load = 0; pin = 4'b0000; sin = 0; #5;
        
        // Load PISO
        load = 1; pin = 4'b1011; #10;
        load = 0;
        
        // Shift PISO and SISO
        sin = 1; #10;
        sin = 0; #10;
        sin = 1; #10;
        sin = 1; #10;
        
        $display("tb_Shift_Registers Complete");
    end
endmodule

// ------------------------------------------
// tb_PC_and_Instruction_Count
// ------------------------------------------
module tb_PC_and_Instruction_Count;
    reg clk, reset, enable, inst_commit;
    reg [31:0] next_pc;
    wire [31:0] pc_out, inst_count_out;

    Program_Counter_Simple pc_inst (.clk(clk), .reset(reset), .enable(enable), .next_pc(next_pc), .pc(pc_out));
    Instruction_Counter ic_inst (.clk(clk), .reset(reset), .instruction_commit(inst_commit), .inst_count(inst_count_out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("pc_ic.vcd");
        $dumpvars(0, tb_PC_and_Instruction_Count);
        clk=0; reset=1; enable=0; inst_commit=0; next_pc=0; #10;
        reset=0;
        
        enable=1; next_pc=32'd4; inst_commit=1; #10;
        enable=1; next_pc=32'd8; inst_commit=0; #10;
        
        $display("tb_PC_and_Instruction_Count Complete");
    end
endmodule

// ------------------------------------------
// tb_Vectors_and_Arrays
// ------------------------------------------
module tb_Vectors_and_Arrays;
    reg clk;
    reg [31:0] vector_in;
    wire [7:0] byte_out;

    Vectors_and_Arrays_Examples arr_inst (.clk(clk), .vector_in(vector_in), .byte_out(byte_out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("vec_arr.vcd");
        $dumpvars(0, tb_Vectors_and_Arrays);
        clk=0; vector_in=32'd0; #10;
        
        vector_in=32'd2; #10;
        vector_in=32'd15; #10;
        
        $display("tb_Vectors_and_Arrays Complete");
    end
endmodule

// ------------------------------------------
// tb_User_Counter_and_Adder
// ------------------------------------------
module tb_User_Counter_and_Adder;
    reg clk, reset;
    wire [5:0] count_out;
    counter u_counter (.clk(clk), .reset(reset), .count(count_out));
    
    reg [4:0] a;
    reg [5:0] b;
    wire [5:0] sum_out;
    adder u_adder (.clk(clk), .a(a), .b(b), .sum(sum_out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("user_cnt_add.vcd");
        $dumpvars(0, tb_User_Counter_and_Adder);
        clk = 0; reset = 1; a = 0; b = 0; #10;
        reset = 0;
        
        a = 5'd10; b = 6'd20; #10;
        a = 5'd5;  b = 6'd1;  #10;
        
        #50;
        
        $display("tb_User_Counter_and_Adder Complete");
        $finish;
    end
endmodule







