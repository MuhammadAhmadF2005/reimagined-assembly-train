//Muhammad Ahmad 
//2024335 



`timescale 1ns / 1ps

module Pipeline(input clk, input reset);


// 1. IF: Instruction Fetch Stage

reg [31:0] PC;
wire [31:0] next_PC;
wire [31:0] PC_plus4 = PC + 4;

reg [7:0] instr_mem [0:1023]; 
wire [31:0] instruction_IF = {instr_mem[PC], instr_mem[PC+1], 
                              instr_mem[PC+2], instr_mem[PC+3]};

// --- IF/ID Pipeline Register ---
reg [31:0] IF_ID_PC, IF_ID_Instruction;
always @(posedge clk) begin
    if (reset) begin
        IF_ID_PC <= 0;
        IF_ID_Instruction <= 0;
    end else begin
        IF_ID_PC <= PC;
        IF_ID_Instruction <= instruction_IF;
    end
end


// 2. ID: Instruction Decode and Register File Read Stage

wire [6:0] opcode = IF_ID_Instruction[6:0];
wire [4:0] rd     = IF_ID_Instruction[11:7];
wire [2:0] funct3 = IF_ID_Instruction[14:12];
wire [4:0] rs1    = IF_ID_Instruction[19:15];
wire [4:0] rs2    = IF_ID_Instruction[24:20];
wire [6:0] funct7 = IF_ID_Instruction[31:25];

reg [31:0] registers [0:31];
wire [31:0] read_data1 = registers[rs1];
wire [31:0] read_data2 = registers[rs2];

// Immediate Generator
reg [31:0] imm_ID;
always @(*) begin
    case(opcode)
        7'b0000011: imm_ID = {{20{IF_ID_Instruction[31]}}, IF_ID_Instruction[31:20]}; // lw
        7'b0100011: imm_ID = {{20{IF_ID_Instruction[31]}}, IF_ID_Instruction[31:25], IF_ID_Instruction[11:7]}; // sw
        7'b1100011: imm_ID = {{19{IF_ID_Instruction[31]}}, IF_ID_Instruction[31], IF_ID_Instruction[7], IF_ID_Instruction[30:25], IF_ID_Instruction[11:8], 1'b0}; // beq
        default:    imm_ID = 0;
    endcase
end

// Control Unit
reg RegWrite_ID, MemRead_ID, MemWrite_ID, MemtoReg_ID, ALUSrc_ID, Branch_ID;
reg [1:0] ALUOp_ID;

always @(*) begin
    case(opcode)
        7'b0110011: begin // R-type
            RegWrite_ID = 1; ALUSrc_ID = 0; MemRead_ID = 0; MemWrite_ID = 0; MemtoReg_ID = 0; Branch_ID = 0; ALUOp_ID = 2'b10;
        end
        7'b0000011: begin // lw
            RegWrite_ID = 1; ALUSrc_ID = 1; MemRead_ID = 1; MemWrite_ID = 0; MemtoReg_ID = 1; Branch_ID = 0; ALUOp_ID = 2'b00;
        end
        7'b0100011: begin // sw
            RegWrite_ID = 0; ALUSrc_ID = 1; MemRead_ID = 0; MemWrite_ID = 1; MemtoReg_ID = 0; Branch_ID = 0; ALUOp_ID = 2'b00;
        end
        7'b1100011: begin // beq
            RegWrite_ID = 0; ALUSrc_ID = 0; MemRead_ID = 0; MemWrite_ID = 0; MemtoReg_ID = 0; Branch_ID = 1; ALUOp_ID = 2'b01;
        end
        default: begin
            RegWrite_ID = 0; ALUSrc_ID = 0; MemRead_ID = 0; MemWrite_ID = 0; MemtoReg_ID = 0; Branch_ID = 0; ALUOp_ID = 2'b00;
        end
    endcase
end

// --- ID/EX Pipeline Register ---
reg ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_ALUSrc;
reg [1:0]  ID_EX_ALUOp;
reg [31:0] ID_EX_PC, ID_EX_RegRead1, ID_EX_RegRead2, ID_EX_Imm;
reg [4:0]  ID_EX_Rd;
reg [2:0]  ID_EX_Func3;
reg [6:0]  ID_EX_Func7;

always @(posedge clk) begin
    if (reset) begin
        {ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_ALUOp} <= 0;
        {ID_EX_PC, ID_EX_RegRead1, ID_EX_RegRead2, ID_EX_Imm} <= 0;
        {ID_EX_Rd, ID_EX_Func3, ID_EX_Func7} <= 0;
    end else begin
        // Pass control signals
        ID_EX_RegWrite <= RegWrite_ID; ID_EX_MemtoReg <= MemtoReg_ID;
        ID_EX_Branch   <= Branch_ID;   ID_EX_MemRead  <= MemRead_ID; ID_EX_MemWrite <= MemWrite_ID;
        ID_EX_ALUSrc   <= ALUSrc_ID;   ID_EX_ALUOp    <= ALUOp_ID;
        // Pass data
        ID_EX_PC       <= IF_ID_PC;
        ID_EX_RegRead1 <= read_data1;
        ID_EX_RegRead2 <= read_data2;
        ID_EX_Imm      <= imm_ID;
        ID_EX_Rd       <= rd;
        ID_EX_Func3    <= funct3;
        ID_EX_Func7    <= funct7;
    end
end


// 3. EX: Execution or Address Calculation Stage

wire [31:0] branch_target_EX = ID_EX_PC + ID_EX_Imm;
wire [31:0] ALU_in2 = (ID_EX_ALUSrc) ? ID_EX_Imm : ID_EX_RegRead2;
reg  [3:0]  ALU_Control;
reg  [31:0] ALU_result_EX;

always @(*) begin
    case(ID_EX_ALUOp)
        2'b00: ALU_Control = 4'b0010; // add
        2'b01: ALU_Control = 4'b0110; // sub
        2'b10: begin // R-type
            case({ID_EX_Func7, ID_EX_Func3})
                10'b0000000_000: ALU_Control = 4'b0010; // add
                10'b0100000_000: ALU_Control = 4'b0110; // sub
                10'b0000000_111: ALU_Control = 4'b0000; // and
                10'b0000000_110: ALU_Control = 4'b0001; // or
                default:         ALU_Control = 4'b0010;
            endcase
        end
        default: ALU_Control = 4'b0010;
    endcase
end

always @(*) begin
    case(ALU_Control)
        4'b0000: ALU_result_EX = ID_EX_RegRead1 & ALU_in2;
        4'b0001: ALU_result_EX = ID_EX_RegRead1 | ALU_in2;
        4'b0010: ALU_result_EX = ID_EX_RegRead1 + ALU_in2;
        4'b0110: ALU_result_EX = ID_EX_RegRead1 - ALU_in2;
        default: ALU_result_EX = 0;
    endcase
end

wire zero_EX = (ALU_result_EX == 0);

// --- EX/MEM Pipeline Register ---
reg EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_Zero;
reg [31:0] EX_MEM_BranchTarget, EX_MEM_ALUResult, EX_MEM_WriteData;
reg [4:0]  EX_MEM_Rd;

always @(posedge clk) begin
    if (reset) begin
        {EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_Zero} <= 0;
        {EX_MEM_BranchTarget, EX_MEM_ALUResult, EX_MEM_WriteData} <= 0;
        EX_MEM_Rd <= 0;
    end else begin
        // Pass Control
        EX_MEM_RegWrite <= ID_EX_RegWrite; EX_MEM_MemtoReg <= ID_EX_MemtoReg;
        EX_MEM_Branch   <= ID_EX_Branch;   EX_MEM_MemRead  <= ID_EX_MemRead; EX_MEM_MemWrite <= ID_EX_MemWrite;
        EX_MEM_Zero     <= zero_EX;
        // Pass Data
        EX_MEM_BranchTarget <= branch_target_EX;
        EX_MEM_ALUResult    <= ALU_result_EX;
        EX_MEM_WriteData    <= ID_EX_RegRead2;
        EX_MEM_Rd           <= ID_EX_Rd;
    end
end


// 4. MEM: Data Memory Access Stage


reg [7:0] data_mem [0:16383];
wire [31:0] mem_read_data_MEM;

assign mem_read_data_MEM = {data_mem[EX_MEM_ALUResult], data_mem[EX_MEM_ALUResult+1],
                            data_mem[EX_MEM_ALUResult+2], data_mem[EX_MEM_ALUResult+3]};

always @(posedge clk) begin
    if (EX_MEM_MemWrite) begin
        data_mem[EX_MEM_ALUResult]   <= EX_MEM_WriteData[31:24];
        data_mem[EX_MEM_ALUResult+1] <= EX_MEM_WriteData[23:16];
        data_mem[EX_MEM_ALUResult+2] <= EX_MEM_WriteData[15:8];
        data_mem[EX_MEM_ALUResult+3] <= EX_MEM_WriteData[7:0];
    end
end

// --- MEM/WB Pipeline Register ---
reg MEM_WB_RegWrite, MEM_WB_MemtoReg;
reg [31:0] MEM_WB_MemData, MEM_WB_ALUResult;
reg [4:0]  MEM_WB_Rd;

always @(posedge clk) begin
    if (reset) begin
        {MEM_WB_RegWrite, MEM_WB_MemtoReg} <= 0;
        {MEM_WB_MemData, MEM_WB_ALUResult} <= 0;
        MEM_WB_Rd <= 0;
    end else begin
        // Pass Control
        MEM_WB_RegWrite <= EX_MEM_RegWrite; 
        MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
        // Pass Data
        MEM_WB_MemData   <= mem_read_data_MEM;
        MEM_WB_ALUResult <= EX_MEM_ALUResult;
        MEM_WB_Rd        <= EX_MEM_Rd;
    end
end


// 5. WB: Write Back Stage

wire [31:0] write_data_WB = (MEM_WB_MemtoReg) ? MEM_WB_MemData : MEM_WB_ALUResult;

always @(posedge clk) begin
    if (MEM_WB_RegWrite && MEM_WB_Rd != 0) begin
        registers[MEM_WB_Rd] <= write_data_WB;
    end
end


// PC Update Logic (Control Hazard Resolution)

// If a branch is taken, update the PC. Otherwise, standard PC + 4 flow.
assign next_PC = (EX_MEM_Branch && EX_MEM_Zero) ? EX_MEM_BranchTarget : PC_plus4;

always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 0;
    else
        PC <= next_PC;
end

endmodule