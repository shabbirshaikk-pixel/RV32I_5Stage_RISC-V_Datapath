`timescale 1ns / 1ps

module riscv_datapath_tb;

    reg clk;
    reg reset;

    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] alu_result;
    wire [31:0] write_back_data;

    // Instantiate the RISC-V datapath
    riscv_datapath uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction),
        .alu_result(alu_result),
        .write_back_data(write_back_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk = 0;
        reset = 1;

        // Apply reset
        #10;
        reset = 0;

        // Allow processor to execute all instructions
        #60;

        // End simulation
        $finish;

    end

endmodule
