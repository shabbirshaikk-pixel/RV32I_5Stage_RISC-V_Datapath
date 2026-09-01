`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 16:30:25
// Design Name: 
// Module Name: riscv_datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module riscv_datapath (

    input clk,
    input reset,

    // Outputs for observation/debugging
    output [31:0] pc,
    output [31:0] instruction,
    output [31:0] alu_result,
    output [31:0] write_back_data

);

    // =====================================================
    // 1. Program Counter
    // =====================================================

    wire [31:0] next_pc;

    assign next_pc = (Branch && Zero) ?
                 (pc + immediate) :
                 (pc + 32'd4);

    program_counter PC (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );


    // =====================================================
    // 2. Instruction Memory
    // =====================================================

    instruction_memory IMEM (
        .address(pc),
        .instruction(instruction)
    );


    // =====================================================
    // 3. Instruction Fields
    // =====================================================

    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire       funct7;

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[30];


    // =====================================================
    // 4. Control Unit
    // =====================================================

    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire MemToReg;
    wire ALUSrc;
    wire Branch;

    wire [3:0] ALU_Control;

    control_unit CU (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ALU_Control(ALU_Control)
    );


    // =====================================================
    // 5. Register File
    // =====================================================

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register_file RF (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    // =====================================================
    // 6. Immediate Generator
    // =====================================================

    wire [31:0] immediate;

    immediate_generator IMM (
        .instruction(instruction),
        .immediate(immediate)
    );


    // =====================================================
    // 7. ALU Input Selection
    // =====================================================

    wire [31:0] alu_input2;

    assign alu_input2 = (ALUSrc) ? immediate : read_data2;


    // =====================================================
    // 8. ALU
    // =====================================================

    wire Zero;

    alu ALU (
        .A(read_data1),
        .B(alu_input2),
        .ALU_Control(ALU_Control),
        .Result(alu_result),
        .Zero(Zero)
    );


    // =====================================================
    // 9. Data Memory
    // =====================================================

    wire [31:0] memory_data;

    data_memory DMEM (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(memory_data)
    );


    // =====================================================
    // 10. Write Back Multiplexer
    // =====================================================

    assign write_back_data =
                (MemToReg) ? memory_data : alu_result;

endmodule
