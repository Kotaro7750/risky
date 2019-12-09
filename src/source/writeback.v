`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/28 16:06:46
// Design Name: 
// Module Name: writeback
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

module writeback(clk,is_load,mem_r_data,alu_result,writeback_data);
  input clk;
  input wire is_load;
  input wire [31:0] mem_r_data;
  input wire [31:0] alu_result;

  reg is_load_reg;
  reg [31:0] mem_r_data_reg;
  reg [31:0] alu_result_reg;

  output wire [31:0] writeback_data;

  always@(negedge clk) begin
    is_load_reg <= is_load;
    mem_r_data_reg <= mem_r_data;
    alu_result_reg <= alu_result;
  end

  writeback_gen writeback_gen(is_load_reg,mem_r_data_reg,alu_result_reg,writeback_data);
endmodule
