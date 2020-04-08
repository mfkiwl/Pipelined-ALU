`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2020 19:26:07
// Design Name: 
// Module Name: write_back
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


module write_back(clk,rst,pos_show,show);
//clk, rst and pos are entered
//The value in show is the 16 LSBs of the register with index pos

input clk, rst;
input [3:0]pos_show;
output reg [15:0]show;

parameter reg_size = 32;
parameter r_file_size = 16;
reg [reg_size-1:0]register[r_file_size-1:0];
reg [3:0]PC;
integer k;

reg d;
reg [3:0]nzcv_old;
wire [3:0]nzcv;
wire [3:0]op_code,dest,op_reg1,op_reg2;
wire i_or_reg,is_write;
wire [7:0]imm,sft_reg;
wire [3:0]sft_imm;

reg [reg_size-1:0]opr1,opr2;
reg [3:0]dest_old;
reg [31:0]result_old;
wire [31:0]result;

initial 
begin
for(k=0; k<r_file_size; k=k+1)
begin
    register[k] = k*16;
end
//pos = 4'b0000;
register[r_file_size-1] = PC;
dest_old = 4'b0000;
result_old = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
nzcv_old = 4'b0000;
end

if_decode first_stage(.clk(clk),
                      .rst(rst),
                      .PC(PC),
                      .op_code(op_code),
                      .dest(dest),
                      .op_reg1(op_reg1),
                      .imm_or_reg(i_or_reg), 
                      .op_reg2(op_reg2),
                      .sft_reg(sft_reg),
                      .imm(imm),
                      .sft_imm(sft_imm));
                      
execute second_stage(.clk(clk),
                     .nzcv_old(nzcv_old),
                     .op_code(op_code),
                     .opr1(opr1),
                     .opr2(opr2),
                     .depi(d),
                     .dep(result_old),
                     .result(result),
                     .is_write(is_write),
                     .nzcv(nzcv));
     
always @(posedge clk)
begin 
    show = register[pos_show][15:0];
    if(rst==1'b1)
        PC = 4'b0000;
    else
    begin
        if(PC==4'b1111)
            PC = 4'b0000;
        else
            PC = PC+4'b0001;
        if(is_write==1)
            register[dest_old] = result;
        register[0] = 0;
        if(dest_old==op_reg2)
            d = 1;
        else
            d = 0;
        dest_old = dest;
        result_old = result;
        nzcv_old = nzcv;
        opr1 = register[op_reg1];
        if(i_or_reg==1)
            opr2 = imm>>(2*sft_imm);
        else
            if(sft_reg[0]==0)
                case(sft_reg[2:1])
                2'b00:  opr2 <= register[op_reg2]>>sft_reg[7:3];  
                2'b01:  opr2 <= register[op_reg2]<<sft_reg[7:3];
                2'b10:  opr2 <= register[op_reg2]>>>sft_reg[7:3];//For unsigned numbers, works as logical shift
                2'b11:  opr2 <= register[op_reg2]<<<sft_reg[7:3];//Arithmetic shift works only for signed numbers, in case of unsigned numbers, it fills the whole space with 0s
                endcase
           else
                case(sft_reg[2:1])
                2'b00:  opr2 = register[op_reg2]>>register[sft_reg[7:4]][4:0];  
                2'b01:  opr2 = register[op_reg2]<<register[sft_reg[7:4]][4:0];
                2'b10:  opr2 = register[op_reg2]>>>register[sft_reg[7:4]][4:0];
                2'b11:  opr2 = register[op_reg2]<<<register[sft_reg[7:4]][4:0];
                endcase 
    end
end  
endmodule
