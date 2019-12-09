`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/26 15:14:19
// Design Name: 
// Module Name: memory_tb
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

`define assert(name, signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %s : signal is '0x%x' but expected '0x%x'!", name, signal, value); \
            $finish; \
        end else begin \
            $display("    signal == value"); \
        end

`define test(name,ex_data) \
        $display("%s:", name); \
        $display("    is_store: 0x%x, addr: 0x%x, mem_access_width: 0x%x, is_load_unsigned: 0x%x,r_data: 0x%x, w_data: 0x%x", is_store,addr,mem_access_width,is_load_unsigned,r_data,w_data); \
        `assert("r_data", r_data, ex_data) \
        $display("%s test passed\n", name); \

`include "define.vh"

module memory_tb;

  reg clk;
  reg is_store;
  reg [31:0] addr;
  reg [1:0] mem_access_width;
  reg is_load_unsigned;
  reg [31:0] w_data;

  wire [31:0] r_data;

  mem_ctl mem_ctl(clk,is_store,addr,mem_access_width,is_load_unsigned,w_data,r_data);

    initial begin
      //store
      is_store <= `ENABLE;
      addr <= 32'd0;
      mem_access_width <= `MEM_WORD;
      is_load_unsigned <= `DISABLE;
      w_data <= 32'hffffffff;
      clk <= 0;
        #10;
      clk <= 1;
      #10;
      clk <= 0;
        #10;
        `test("line 0 WORD", 32'hffffffff)

      addr <= 32'd4;
      mem_access_width <= `MEM_BYTE;
      is_load_unsigned <= `DISABLE;
      w_data <= 32'hfe;
      clk <= 1;
      #10;
      clk <= 0;
        #10;
        `test("line 1 BYTE", 32'hfffffffe)

      addr <= 32'd6;
      mem_access_width <= `MEM_BYTE;
      is_load_unsigned <= `DISABLE;
      w_data <= 32'haa;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("line 1 BYTE", 32'hffffffaa)

      addr <= 32'd6;
      mem_access_width <= `MEM_BYTE;
      is_load_unsigned <= `ENABLE;
      w_data <= 32'haa;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("line 1 BYTE", 32'h000000aa)

      addr <= 32'd9;
      mem_access_width <= `MEM_HALF;
      is_load_unsigned <= `ENABLE;
      w_data <= 32'haa00;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("line 2 HALF", 32'h0000aa00)

      addr <= 32'd9;
      mem_access_width <= `MEM_HALF;
      is_load_unsigned <= `DISABLE;
      w_data <= 32'haa00;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("line 2 HALF", 32'hffffaa00)

      //load
      is_store <= `DISABLE;

      addr <= 32'd9;
      mem_access_width <= `MEM_HALF;
      is_load_unsigned <= `ENABLE;
      w_data <= 32'hffff;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("load line 2 HALF", 32'h0000aa00)
        
      addr <= 32'd0;
      mem_access_width <= `MEM_WORD;
      is_load_unsigned <= `DISABLE;
      w_data <= 32'hffffffff;
      clk <= 0;
        #10;
      clk <= 1;
      #10;
      clk <= 0;
        #10;
        `test("load line 0 WORD", 32'hffffffff)

      addr <= 32'd4;
      mem_access_width <= `MEM_BYTE;
      is_load_unsigned <= `DISABLE;
      w_data <= 32'hff;
      clk <= 1;
      #10;
      clk <= 0;
        #10;
        `test("line 1 BYTE", 32'hfffffffe)

      addr <= 32'd6;
      mem_access_width <= `MEM_BYTE;
      is_load_unsigned <= `DISABLE;
      w_data <= 32'hff;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("line 1 BYTE", 32'hffffffaa)

      addr <= 32'd6;
      mem_access_width <= `MEM_BYTE;
      is_load_unsigned <= `ENABLE;
      w_data <= 32'hff;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("line 1 BYTE", 32'h000000aa)

      addr <= 32'd9;
      mem_access_width <= `MEM_HALF;
      is_load_unsigned <= `ENABLE;
      w_data <= 32'hffff;
      clk <= 1;
      #10;
      clk <= 0;
      #10;
        `test("line 2 HALF", 32'h0000aa00)

      $display("all memory-tests passed!");
    end
endmodule
