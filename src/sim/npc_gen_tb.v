`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/25 14:45:44
// Design Name: 
// Module Name: npc_gen_tb
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

`define test(name,ex_npc) \
        $display("%s:", name); \
        $display("    npc_op1: 0x%x, npc_op2: 0x%x, br_taken: 0x%x", npc_op1,npc_op2,br_taken); \
        `assert("npc", npc, ex_npc) \
        $display("%s test passed\n", name); \

`include "define.vh"


module npc_gen_tb;
  reg [31:0] npc_op1;
  reg [31:0] npc_op2;
  reg br_taken;

  wire [31:0] npc;

npc_gen npc_gen(.npc_op1(npc_op1),.npc_op2(npc_op2),.br_taken(br_taken),.npc(npc));

    initial begin
        npc_op1 = 32'd10;
        npc_op2 = 32'd14;
        br_taken = `ENABLE;
        
        #10;
        `test("JUMP", 32'd24)

        npc_op1 = 32'd10;
        npc_op2 = 32'd14;
        br_taken = `DISABLE;
        #10;
        `test("NOT JUMP", 32'd14)

      $display("all npc_gen-tests passed!");
    end

endmodule
