`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 13:26:04
// Design Name: 
// Module Name: program_counter
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

module program_counter (
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] pc
);

always @(posedge clk) begin
    if (reset)
        pc <= 32'd0;
    else
        pc <= next_pc;
end

endmodule
