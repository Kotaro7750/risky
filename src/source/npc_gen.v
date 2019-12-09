`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/25 14:45:24
// Design Name: 
// Module Name: npc_gen
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

`include "define.vh"

module npc_gen(npc_op1,npc_op2,br_taken,npc);
  input wire [31:0] npc_op1;
  input wire [31:0] npc_op2;
  input wire br_taken;

  output wire [31:0] npc;

  assign npc = (br_taken == `ENABLE) ? npc_op1 + npc_op2 : npc_op1 + 4;
endmodule
