`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2026 23:02:05
// Design Name: 
// Module Name: register_file
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


module register_file(
    input clk,
    input reset,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,

    input [31:0] write_data,
    input RegWrite,

    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] registers [0:31];
    integer i;

    // Reset all registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (RegWrite && (rd != 5'b00000)) begin
            registers[rd] <= write_data;
        end
    end

    // Register x0 is always zero
    assign read_data1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

endmodule
