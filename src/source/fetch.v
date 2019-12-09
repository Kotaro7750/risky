`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/28 16:06:46
// Design Name: 
// Module Name: fetch
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


module fetch(clk,pc,inst_b);
  input wire clk;
  input wire [31:0] pc;
  reg [31:0] pc_reg_IF;

  output wire [31:0] inst_b;

  always@(posedge clk) begin
    pc_reg_IF <= pc;
    end

  inst_mem inst_mem(pc_reg_IF,inst_b);
endmodule
