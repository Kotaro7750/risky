`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/26 13:37:34
// Design Name: 
// Module Name: ram
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

module ram(clk, w_enable, r_addr, r_data, w_addr, w_data);
  input clk;
  input  [3:0] w_enable; // 書き込むバイトは1, 書き込まないでそのままにするバイトは0を指定
  //input  [4:0] r_addr, w_addr;
  input  [31:0] r_addr, w_addr;
  input  [31:0] w_data;
  output [31:0] r_data;
  //reg [4:0] r_addr_reg;
  reg [31:0] r_addr_reg;

  //TODO もっと大きく
  reg [31:0] mem [0:32767];

  always @(posedge clk) begin
      if(w_enable[0]) mem[w_addr][ 7: 0] <= w_data[ 7: 0];
      if(w_enable[1]) mem[w_addr][15: 8] <= w_data[15: 8];
      if(w_enable[2]) mem[w_addr][23:16] <= w_data[23:16];
      if(w_enable[3]) mem[w_addr][31:24] <= w_data[31:24];
      r_addr_reg <= r_addr;
  end

  assign r_data = mem[r_addr_reg];

  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/Coremark_for_Synthesis/data.hex",mem);
  initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/Coremark_for_Synthesis/data.hex",mem);
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/risky/risky/risky.srcs/sources_1/new/test.hex",mem);
endmodule

