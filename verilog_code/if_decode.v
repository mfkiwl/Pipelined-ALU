`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2020 19:41:17
// Design Name: 
// Module Name: if_decode
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


module if_decode(clk, rst, PC, op_code, dest, op_reg1, imm_or_reg, op_reg2, sft_reg, imm, sft_imm);

parameter memory_size = 4;
parameter word_size = 32;

input clk,rst;
input [3:0]PC;

reg [word_size-1:0]memory[15:0];


output reg imm_or_reg;
output reg [3:0]op_code,op_reg1,op_reg2,dest;
output reg [7:0]sft_reg;
output reg [3:0]sft_imm;
output reg [7:0]imm;

always @(posedge clk)
begin
    if(rst==1)
     begin
        memory[0] = 32'b0000_00_0_0100_0_0010_0100_00000000_0011;//Reg 2 + Reg 3 -> Reg 4 (32 + 48 = 80)
        memory[1] = 32'b0000_00_0_0011_0_0101_0101_00000000_0100;//Reg 5 - Reg 4 -> Reg 5 (80 - 80 = 0)
        memory[2] = 32'b0000_00_0_0001_0_0011_0011_00000000_0110;//Reg 6 ^ Reg 3 -> Reg 3 (80)
        memory[3] = 32'b0000_00_0_0010_0_0100_0011_00000000_0011;//Reg 3 - Reg 4 -> Reg 3(0)
        memory[4] = 32'b0000_00_1_1010_0_0100_0101_0000_00010111;//Imm + Reg 4 -> Reg 5 (85) Do not write
        memory[5] = 32'b0000_00_1_0100_0_0100_0101_0001_00010111;//Imm + Reg 4 -> Reg 5 (85) Write
        memory[6] = 32'b0000_00_0_0100_0_0100_0101_00001_010_0100;
        memory[7] = 32'b0000_00_0_0100_0_0011_0001_00000000_0100;
        memory[8] = 32'b0000_00_0_0100_0_0011_0000_00000000_0100;
        memory[9] = 32'b0000_00_0_0100_0_0010_0100_00000000_0011;
        memory[10] = 32'b0000_00_0_0100_0_0101_0101_00000000_0100;
        memory[11] = 32'b0000_00_0_0100_0_0011_0011_00000000_0110;
        memory[12] = 32'b0000_00_0_0100_0_0100_0011_00000000_0011;
        memory[13] = 32'b0000_00_1_0100_0_0100_0101_0001_00010111;
        memory[14] = 32'b0000_00_1_0100_0_0100_0101_0001_00010111;
        memory[15] = 32'b0000_00_1_0100_0_0100_0101_0001_00010111;
     end
end

always @(negedge clk)
begin 
    imm_or_reg = memory[PC][25];
    op_code = memory[PC][24:21];
    op_reg1 = memory[PC][19:16];
    dest = memory[PC][15:12];
    sft_reg = memory[PC][11:4];
    op_reg2 = memory[PC][3:0];
    sft_imm = memory[PC][11:8];
    imm = memory[PC][7:0];
end
endmodule