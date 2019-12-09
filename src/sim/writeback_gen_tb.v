`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/28 13:07:53
// Design Name: 
// Module Name: writeback_gen_tb
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
        $display("    is_load: 0x%x, mem_r_data: 0x%x, alu_result: 0x%x", is_load,mem_r_data,alu_result); \
        `assert("writeback_data", writeback_data, ex_data) \
        $display("%s test passed\n", name); \

`include "define.vh"

module writeback_gen_tb;
  reg is_load;
  reg [31:0] mem_r_data;
  reg [31:0] alu_result;

  wire [31:0] writeback_data;

  writeback_gen writeback_gen(is_load,mem_r_data,alu_result,writeback_data);

  initial begin
    is_load <= `DISABLE;
    mem_r_data <= 32'hffff;
    alu_result <= 32'h0a0a;
    #10;
    `test("not load",32'h0a0a)
    
    is_load <= `ENABLE;
    mem_r_data <= 32'heeee;
    alu_result <= 32'ha0a0;
    #10;
    `test("load",32'heeee)

    $display("all memory-tests passed!");
  end
endmodule
