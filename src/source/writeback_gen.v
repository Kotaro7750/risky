`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/28 13:07:31
// Design Name: 
// Module Name: writeback_gen
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


module writeback_gen(is_load,mem_r_data,alu_result,writeback_data);
  input wire is_load;
  input wire [31:0] mem_r_data;
  input wire [31:0] alu_result;

  output wire [31:0] writeback_data;

  assign writeback_data = is_load ? mem_r_data : alu_result;
endmodule
