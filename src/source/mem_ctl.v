`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/26 17:25:08
// Design Name: 
// Module Name: mem_ctl
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

module mem_ctl(clk,is_store,addr,mem_access_width,is_load_unsigned,w_data,r_data,uart,uart_we);
  input wire clk;
  input wire is_store;
  input wire [31:0] addr;
  input wire [1:0] mem_access_width;
  input wire is_load_unsigned;
  input wire [31:0] w_data;

  //lineはmemの何個目なのか
  wire [31:0] line;
  //offsetは4バイトのうちの何個目か
  wire [1:0] offset;

  assign line = addr >> 2;
  assign offset = addr - ((addr >> 2)<<2);

  reg [31:0] shifted_w_data;
  reg [3:0] w_enable;

  output wire [31:0] r_data;
  output wire [7:0] uart;
  output wire  uart_we;

  wire [31:0] row_r_data;

  wire [31:0] shifted_w_data_b;
  wire [31:0] shifted_w_data_h;
  wire [31:0] shifted_w_data_w;
  wire [31:0] shifted_w_data_none;

  assign shifted_w_data_b = (w_data & 8'hff) << (offset*8);
  assign shifted_w_data_h = (w_data & 16'hffff) << (offset*8);
  assign shifted_w_data_w = w_data;
  assign shifted_w_data_none = 32'd0;

  assign uart = shifted_w_data_b & 8'hff;
  assign uart_we = ((addr == `UART_ADDR) && (is_store == `ENABLE)) ? 1'b1 : 1'b0;
  //assign uart_we = addr == `UART_ADDR ? 1'b1 : 1'b0;


  ram ram(clk, w_enable, line, row_r_data, line, shifted_w_data);

  function [31:0] r_data_gen;
    input [31:0] row_r_data;
    input [1:0] mem_access_width;
    input is_load_unsigned;
    input [1:0] offset;

    begin
      case (mem_access_width)
        `MEM_BYTE: begin
          r_data_gen = is_load_unsigned 
            ? ({32{1'b0}}) | ((row_r_data >> (offset * 8)) & 8'hff)
            : ({32{row_r_data[(offset+1) * 8 - 1]}} << 8) | ((row_r_data >> (offset * 8)) & 8'hff)
            ;
        end
        `MEM_HALF: begin
          r_data_gen = is_load_unsigned 
            ? ({32{1'b0}}) | ((row_r_data >> (offset * 8)) & 16'hffff)
            : ({32{row_r_data[(offset + 2) * 8  -1]}} << 16) | ((row_r_data >> (offset * 8)) & 16'hffff)
            ;
        end
        `MEM_WORD: begin
          r_data_gen = row_r_data;
        end
        default: begin
          r_data_gen = row_r_data;
        end
      endcase
    end
  endfunction

  always @(posedge clk) begin
      if(is_store) begin
        case (mem_access_width)
          `MEM_BYTE: begin
            shifted_w_data <= shifted_w_data_b;
            w_enable <= 4'b0001 << offset;
          end
          `MEM_HALF: begin
            shifted_w_data <= shifted_w_data_h;
            w_enable <= 4'b0011 << offset;
          end
          `MEM_WORD: begin
            shifted_w_data <= shifted_w_data_w;
            w_enable <= 4'b1111;
          end
          default: begin
            shifted_w_data <= shifted_w_data_none;
            w_enable <= 4'b0000;
          end
        endcase
      end
      else begin
        shifted_w_data <= shifted_w_data_none;
        w_enable <= 4'b0000;
      end
  end

  assign r_data = r_data_gen(row_r_data,mem_access_width,is_load_unsigned,offset);
endmodule
