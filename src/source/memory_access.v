`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/28 16:06:46
// Design Name: 
// Module Name: memory_access
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


module memory_access(clk,is_store,alu_result,mem_access_width,is_load_unsigned,w_data,r_data,result,uart,uart_we,hc_access);
  input wire clk;
  input wire is_store;
  input wire [31:0] alu_result;
  input wire [1:0] mem_access_width;
  input wire is_load_unsigned;
  input wire [31:0] w_data;

  reg is_store_reg;
  reg [31:0] alu_result_reg;
  reg [1:0] mem_access_width_reg;
  reg is_load_unsigned_reg;
  reg [31:0] w_data_reg;

  output wire [31:0] r_data;
  output wire [31:0] result;
  output wire [7:0] uart;
  output wire  uart_we;
  output wire hc_access;

  assign result = alu_result_reg;
  assign hc_access = alu_result_reg == `HARDWARE_COUNTER_ADDR ? `ENABLE:`DISABLE;

  always@(posedge clk) begin
    is_store_reg <= is_store;
    alu_result_reg <= alu_result;
    mem_access_width_reg <= mem_access_width;
    is_load_unsigned_reg <= is_load_unsigned;
    w_data_reg <= w_data;
  end

  mem_ctl mem_ctl(clk,is_store_reg,alu_result_reg,mem_access_width_reg,is_load_unsigned_reg,w_data_reg,r_data,uart,uart_we);

endmodule
