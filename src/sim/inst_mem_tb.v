`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/25 15:19:31
// Design Name: 
// Module Name: fetch_tb
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

`define test(name,ex_inst_b) \
        $display("%s:", name); \
        $display("    pc: 0x%x", pc); \
        `assert("inst_b", inst_b, ex_inst_b) \
        $display("%s test passed\n", name); \

`include "define.vh"

module inst_mem_tb;
  reg [31:0] pc;
  
  wire [31:0] inst_b;

  inst_mem inst_mem(.pc(pc),.inst_b(inst_b));

  initial begin
      
      pc = 32'd0;
      #10;
      `test("0", 32'd0)

      pc = 32'd8192 * 4;
      #10;
      `test("1", 32'h80006f)
      
      $display("all fetch-tests passed!");

    end
endmodule
