`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 16:22:50
// Design Name: 
// Module Name: data_memory
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

module data_memory (
    input        clk,
    input        MemRead,
    input        MemWrite,
    input  [31:0] address,
    input  [31:0] write_data,
    output reg [31:0] read_data
);

    reg [31:0] memory [0:255];

    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'd0;
    end

    always @(posedge clk) begin

        if (MemWrite)
            memory[address[9:2]] <= write_data;

    end

    always @(*) begin

        if (MemRead)
            read_data = memory[address[9:2]];
        else
            read_data = 32'd0;

    end

endmodule
