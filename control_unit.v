`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 16:13:55
// Design Name: 
// Module Name: control_unit
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

module control_unit (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input        funct7,

    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemToReg,
    output reg       ALUSrc,
    output reg       Branch,
    output reg [3:0] ALU_Control
);

    always @(*) begin

        // Default values
        RegWrite   = 0;
        MemRead    = 0;
        MemWrite   = 0;
        MemToReg   = 0;
        ALUSrc     = 0;
        Branch     = 0;
        ALU_Control = 4'b0000;

        case (opcode)

            // =================================================
            // R-Type instructions
            // ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
            // Opcode = 0110011
            // =================================================
            7'b0110011: begin

                RegWrite = 1;
                ALUSrc   = 0;

                case (funct3)

                    3'b000: begin
                        if (funct7 == 1'b0)
                            ALU_Control = 4'b0000; // ADD
                        else
                            ALU_Control = 4'b0001; // SUB
                    end

                    3'b111: ALU_Control = 4'b0010; // AND
                    3'b110: ALU_Control = 4'b0011; // OR
                    3'b100: ALU_Control = 4'b0100; // XOR
                    3'b001: ALU_Control = 4'b0101; // SLL
                    3'b101: begin
                        if (funct7 == 1'b0)
                            ALU_Control = 4'b0110; // SRL
                        else
                            ALU_Control = 4'b0111; // SRA
                    end

                    3'b010: ALU_Control = 4'b1000; // SLT
                    3'b011: ALU_Control = 4'b1001; // SLTU

                    default: ALU_Control = 4'b0000;

                endcase
            end


            // =================================================
            // I-Type ALU instructions
            // ADDI, ANDI, ORI, XORI, SLTI
            // Opcode = 0010011
            // =================================================
            7'b0010011: begin

                RegWrite = 1;
                ALUSrc   = 1;

                case (funct3)

                    3'b000: ALU_Control = 4'b0000; // ADDI
                    3'b111: ALU_Control = 4'b0010; // ANDI
                    3'b110: ALU_Control = 4'b0011; // ORI
                    3'b100: ALU_Control = 4'b0100; // XORI
                    3'b010: ALU_Control = 4'b1000; // SLTI

                    default: ALU_Control = 4'b0000;

                endcase
            end


            // =================================================
            // Load Word (LW)
            // Opcode = 0000011
            // =================================================
            7'b0000011: begin

                RegWrite = 1;
                MemRead  = 1;
                MemToReg = 1;
                ALUSrc   = 1;

                ALU_Control = 4'b0000; // ADD address

            end


            // =================================================
            // Store Word (SW)
            // Opcode = 0100011
            // =================================================
            7'b0100011: begin

                MemWrite = 1;
                ALUSrc   = 1;

                ALU_Control = 4'b0000; // ADD address

            end


            // =================================================
            // Branch Equal (BEQ)
            // Opcode = 1100011
            // =================================================
            7'b1100011: begin

                Branch = 1;
                ALUSrc = 0;

                ALU_Control = 4'b0001; // SUB for comparison

            end


            default: begin

                RegWrite   = 0;
                MemRead    = 0;
                MemWrite   = 0;
                MemToReg   = 0;
                ALUSrc     = 0;
                Branch     = 0;
                ALU_Control = 4'b0000;

            end

        endcase

    end

endmodule