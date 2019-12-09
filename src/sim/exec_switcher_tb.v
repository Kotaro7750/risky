`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/25 13:41:39
// Design Name: 
// Module Name: exec_switcher_tb
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

`define test(name, ex_alu_op1, ex_alu_op2,ex_npc_op1,ex_npc_op2) \
        $display("%s:", name); \
        $display("    pc: 0x%x, rs1: 0x%x, rs2: 0x%x, imm: 0x%x, alu_code: 0x%x, alu_op1_type: 0x%x, alu_op2_type: 0x%x,", pc,rs1,rs2,imm,alu_code,alu_op1_type,alu_op2_type); \
        `assert("alu_op1", alu_op1, ex_alu_op1) \
        `assert("alu_op2", alu_op2, ex_alu_op2) \
        `assert("npc_op1", npc_op1, ex_npc_op1) \
        `assert("npc_op2", npc_op2, ex_npc_op2) \
        $display("%s test passed\n", name); \

`include "define.vh"


module exec_switcher_tb;
  reg [31:0] pc;
  reg [31:0] rs1;
  reg [31:0] rs2;
  reg [31:0] imm;
  reg [6:0] alu_code;
  reg [1:0] alu_op1_type;
  reg [1:0] alu_op2_type;

  wire [31:0] alu_op1;
  wire [31:0] alu_op2;

  wire [31:0] npc_op1;
  wire [31:0] npc_op2;

  exec_switcher exec_switcher(
    .pc(pc),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .alu_code(alu_code),
    .alu_op1_type(alu_op1_type),
    .alu_op2_type(alu_op2_type),
    .alu_op1(alu_op1),
    .alu_op2(alu_op2),
    .npc_op1(npc_op1),
    .npc_op2(npc_op2));

    initial begin
        
        pc = 32'd0;
        rs1 = 32'd1;
        rs2 = 32'd2;
        imm = 32'd5;
        alu_code = `ALU_JAL;
        alu_op1_type = `OP_TYPE_NONE;
        alu_op2_type = `OP_TYPE_PC;
        #10;
        `test("JAL", 32'd0,32'd0,32'd0,32'd5)
        
        pc = 32'd1;
        rs1 = 32'd2;
        rs2 = 32'd3;
        imm = 32'd6;
        alu_code = `ALU_JALR;
        alu_op1_type = `OP_TYPE_NONE;
        alu_op2_type = `OP_TYPE_PC;
        #10;
        `test("JALR", 32'd0,32'd1,32'd2,32'd6)
        
        pc = 32'd2;
        rs1 = 32'd3;
        rs2 = 32'd4;
        imm = 32'd7;
        alu_code = `ALU_BEQ;
        alu_op1_type = `OP_TYPE_REG;
        alu_op2_type = `OP_TYPE_REG;
        #10;
        `test("BEQ", 32'd3,32'd4,32'd2,32'd7)

        pc = 32'd3;
        rs1 = 32'd3;
        rs2 = 32'd4;
        imm = 32'd7;
        alu_code = `ALU_BNE;
        alu_op1_type = `OP_TYPE_REG;
        alu_op2_type = `OP_TYPE_REG;
        #10;
        `test("BNE", 32'd3,32'd4,32'd3,32'd7)

        pc = 32'd2;
        rs1 = 32'd3;
        rs2 = 32'd4;
        imm = 32'd7;
        alu_code = `ALU_BLT;
        alu_op1_type = `OP_TYPE_REG;
        alu_op2_type = `OP_TYPE_REG;
        #10;
        `test("BLT", 32'd3,32'd4,32'd2,32'd7)

        pc = 32'd2;
        rs1 = 32'd3;
        rs2 = 32'd4;
        imm = 32'd7;
        alu_code = `ALU_BEQ;
        alu_op1_type = `OP_TYPE_REG;
        alu_op2_type = `OP_TYPE_REG;
        #10;
        `test("BEQ", 32'd3,32'd4,32'd2,32'd7)

        pc = 32'd3;
        rs1 = 32'd3;
        rs2 = 32'd4;
        imm = 32'd7;
        alu_code = `ALU_BLTU;
        alu_op1_type = `OP_TYPE_REG;
        alu_op2_type = `OP_TYPE_REG;
        #10;
        `test("BLTU", 32'd3,32'd4,32'd3,32'd7)

        pc = 32'd10;
        rs1 = 32'd5;
        rs2 = 32'd9;
        imm = 32'd1;
        alu_code = `ALU_ADD;
        alu_op1_type = `OP_TYPE_REG;
        alu_op2_type = `OP_TYPE_REG;
        #10;
        `test("ADD", 32'd5,32'd9,32'd10,32'd4)

      $display("all exec_switcher-tests passed!");
    end

endmodule
