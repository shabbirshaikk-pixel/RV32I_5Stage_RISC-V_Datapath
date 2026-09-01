`timescale 1ns / 1ps

module instruction_memory (
    input  [31:0] address,
    output reg [31:0] instruction
);

always @(*) begin

    case (address)

        // ADDI x1, x0, 10
        32'd0:  instruction = 32'h00A00093;

        // ADDI x2, x0, 20
        32'd4:  instruction = 32'h01400113;

        // ADD x3, x1, x2
        32'd8:  instruction = 32'h002081B3;

        // SW x3, 0(x0)
        32'd12: instruction = 32'h00302023;

        // LW x4, 0(x0)
        32'd16: instruction = 32'h00002203;

        // BEQ x3, x4, +8
        32'd20: instruction = 32'h00418463;

        // ADDI x5, x0, 99
        // This instruction should be skipped by BEQ
        32'd24: instruction = 32'h06300293;

        // ADDI x6, x0, 50
        32'd28: instruction = 32'h03200313;

        default: instruction = 32'h00000000;

    endcase

end

endmodule