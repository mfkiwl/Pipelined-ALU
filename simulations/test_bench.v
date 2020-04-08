`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2020 11:40:36
// Design Name: 
// Module Name: test_bench2
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


module test_bench2();

reg clk, rst;
reg [3:0]pos;
wire [15:0]show;

always #5 clk = ~clk;
initial 
begin
    clk <= 0; rst <= 1; pos <= 4'b0100; #8;
    rst = 0;  
end 

write_back wb(.clk(clk), .rst(rst), .pos_show(pos), .show(show));

endmodule
