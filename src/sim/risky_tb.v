`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 18:52:38
// Design Name: 
// Module Name: risky_tb
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


module risky_tb;
  reg clk;
  reg rstd;

  risky risky(clk,rstd);




  initial begin
    rstd <= 1;
    clk <= 0;
    #50;
    rstd <= 0;
    #5;
    rstd <= 1;

    #9000000000 $finish;
  end

	always #10 clk = ~clk;

endmodule
