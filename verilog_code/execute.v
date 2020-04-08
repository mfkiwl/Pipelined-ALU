`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2020 22:39:31
// Design Name: 
// Module Name: execute
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

module execute(clk,nzcv_old,op_code,opr1,opr2,depi,dep,result,is_write,nzcv);

input clk,depi;
input [3:0]nzcv_old;
input [3:0]op_code;
input [31:0]opr1,opr2,dep;
output reg [31:0]result;
output reg [3:0]nzcv;
reg [31:0]operand2;
reg cin, cout;
output reg is_write;

initial 
    is_write = 1;
    
always @(negedge clk)
begin
    if(depi==1)
        operand2 = dep;
    else
        operand2 = opr2;
    case(op_code)
    4'b0000: 
    begin
        result = opr1 & operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 1;
    end 
    4'b0001:
    begin
        result = opr1 ^ operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 1;
    end 
    4'b0010:
    begin
        result = opr1 - operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 1;
    end
    4'b0011:
    begin
        result = operand2 - opr1;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 1;
    end
    4'b0100:
    begin 
        {cin, result[30:0]} = opr1[30:0]+operand2[30:0];
        {cout, result[31]} = opr1[31]+operand2[31]+cin;
        nzcv[1] <= cout; //carry output 
        nzcv[0] <= cout^cin;
        nzcv[3:2] <= nzcv_old[3:2];
        is_write = 1;
    end
    4'b0101:
    begin
        {cin, result[30:0]} = opr1[30:0]+operand2[30:0] + nzcv_old[1];
        {cout, result[31]} = opr1[31]+operand2[31]+cin;
        nzcv[1] <= cout; //carry output 
        nzcv[0] <= cout^cin;
        nzcv[3:2] <= nzcv_old[3:2];
        is_write = 1;
    end 
    4'b0110:
    begin
        {cin, result[30:0]} = opr1[30:0]+ ~operand2[30:0]+ nzcv_old[1] -1; 
        {cout, result[31]} = cin + opr1[31]+ ~operand2[31];
	    nzcv[1]  <= cout;	//carry flag
	    nzcv[0] <= cin^cout;
	    nzcv[3:2] <= nzcv_old[3:2];
	    is_write = 1;
    end
    4'b0111:
    begin
        {cin, result[30:0]} = operand2[30:0]+ ~opr1[30:0]+ nzcv_old[1] -1; 
	    {cout, result[31]} = cin + operand2[31] + ~opr1[31];
		nzcv[1] <= cout;	//carry flag
		nzcv[0] <= cin^cout;
        nzcv[3:2] <= nzcv_old[3:2];
        is_write = 1;
    end
    4'b1000:
    begin
        result = opr1 & operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 0;
    end
    4'b1001:
    begin
        result = opr1 ^ operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 0;
    end
    4'b1010:
    begin 
        {cin, result[30:0]} = opr1[30:0]+operand2[30:0];
        {cout, result[31]} = opr1[31]+operand2[31]+cin;
        nzcv[1] <= cout; //carry output 
        nzcv[0] <= cout^cin;
        nzcv[3:2] <= nzcv_old[3:2];
        is_write = 0;
    end
    4'b1011:
    begin
        {cin, result[30:0]} = opr1[30:0]+operand2[30:0];
        {cout, result[31]} = opr1[31]+operand2[31]+cin;
        nzcv[1] <= cout; //carry output 
        nzcv[0] <= cout^cin;
        nzcv[3:2] <= nzcv_old[3:2];
        is_write = 0;
    end
    4'b1100:
    begin
        result = opr1 | operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 0;
    end
    4'b1101:
    begin
        result = operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 0;
    end
    4'b1110:
    begin
        result = opr1 & (~operand2);
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 0;
    end
    4'b1111:
    begin
        result = ~operand2;
        if(result==0)
            nzcv[3] <= 1'b1;
        else
            nzcv[3] <= 1'b0;
        nzcv[2:0] <= nzcv_old[2:0];
        is_write = 0;
    end
    default:
        nzcv <= nzcv_old;
    endcase    
end
endmodule
