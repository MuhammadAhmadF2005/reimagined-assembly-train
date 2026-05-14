`timescale 1ns / 1ps

module RISC_V_Processor(input clk, input reset);

reg [31:0] PC;
wire [31:0] next_PC;

reg [7:0] instr_mem [0:1023]; // 1KB 
wire [31:0] instruction;

assign instruction = {instr_mem[PC],
                      instr_mem[PC+1],
                      instr_mem[PC+2],
                      instr_mem[PC+3]};

wire [6:0] opcode = instruction[6:0];
wire [4:0] rd     = instruction[11:7];
wire [2:0] funct3 = instruction[14:12];
wire [4:0] rs1    = instruction[19:15];
wire [4:0] rs2    = instruction[24:20];
wire [6:0] funct7 = instruction[31:25];

reg [31:0] registers [0:31];

wire [31:0] read_data1 = registers[rs1];
wire [31:0] read_data2 = registers[rs2];

reg [31:0] imm;

always @(*) begin
    case(opcode)
        7'b0000011: imm = {{20{instruction[31]}}, instruction[31:20]}; // lw
        7'b0100011: imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // sw
        7'b1100011: imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // beq
        default:    imm = 0;
    endcase
end

reg RegWrite, MemRead, MemWrite, MemtoReg, ALUSrc, Branch;
reg [1:0] ALUOp;

always @(*) begin
    case(opcode)
        7'b0110011: begin // R-type
            RegWrite = 1; ALUSrc = 0; MemRead = 0;
            MemWrite = 0; MemtoReg = 0; Branch = 0;
            ALUOp = 2'b10;
        end

        7'b0000011: begin // lw
            RegWrite = 1; ALUSrc = 1; MemRead = 1;
            MemWrite = 0; MemtoReg = 1; Branch = 0;
            ALUOp = 2'b00;
        end

        7'b0100011: begin // sw
            RegWrite = 0; ALUSrc = 1; MemRead = 0;
            MemWrite = 1; MemtoReg = 0; Branch = 0;
            ALUOp = 2'b00;
        end

        7'b1100011: begin // beq
            RegWrite = 0; ALUSrc = 0; MemRead = 0;
            MemWrite = 0; MemtoReg = 0; Branch = 1;
            ALUOp = 2'b01;
        end

        default: begin
            RegWrite = 0; ALUSrc = 0; MemRead = 0;
            MemWrite = 0; MemtoReg = 0; Branch = 0;
            ALUOp = 2'b00;
        end
    endcase
end

reg [3:0] ALU_Control;

always @(*) begin
    case(ALUOp)
        2'b00: ALU_Control = 4'b0010; // add
        2'b01: ALU_Control = 4'b0110; // sub (for beq)
        2'b10: begin
            case({funct7, funct3})
                10'b0000000000: ALU_Control = 4'b0010; // add
                10'b0100000000: ALU_Control = 4'b0110; // sub
                10'b0000000111: ALU_Control = 4'b0000; // and
                10'b0000000110: ALU_Control = 4'b0001; // or
                default:        ALU_Control = 4'b0010;
            endcase
        end
    endcase
end

wire [31:0] ALU_in2 = (ALUSrc) ? imm : read_data2;
reg [31:0] ALU_result;
wire zero;

always @(*) begin
    case(ALU_Control)
        4'b0000: ALU_result = read_data1 & ALU_in2;
        4'b0001: ALU_result = read_data1 | ALU_in2;
        4'b0010: ALU_result = read_data1 + ALU_in2;
        4'b0110: ALU_result = read_data1 - ALU_in2;
        default: ALU_result = 0;
    endcase
end

assign zero = (ALU_result == 0);

reg [7:0] data_mem [0:16383]; // 16KB

wire [31:0] mem_read_data;

assign mem_read_data = {data_mem[ALU_result],
                        data_mem[ALU_result+1],
                        data_mem[ALU_result+2],
                        data_mem[ALU_result+3]};

always @(posedge clk) begin
    if (MemWrite) begin
        data_mem[ALU_result]     <= read_data2[31:24];
        data_mem[ALU_result+1]   <= read_data2[23:16];
        data_mem[ALU_result+2]   <= read_data2[15:8];
        data_mem[ALU_result+3]   <= read_data2[7:0];
    end
end

wire [31:0] write_data = (MemtoReg) ? mem_read_data : ALU_result;

always @(posedge clk) begin
    if (RegWrite && rd != 0) begin
        registers[rd] <= write_data;
    end
end

wire [31:0] PC_plus4 = PC + 4;
wire [31:0] branch_target = PC + imm;

assign next_PC = (Branch && zero) ? branch_target : PC_plus4;

always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 0;
    else
        PC <= next_PC;
end

endmodule




/*
// [31:0] func1;
    input [31:0] in1;
    input [31:0] in2;
    begin
        func1 = in1 ^ in2;
    end
*/
