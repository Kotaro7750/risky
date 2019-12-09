`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/25 13:03:47
// Design Name: 
// Module Name: exec_switcher
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

//デコードで整理したレジスタ、即値を実際に渡す引数にしてやる。
module exec_switcher(pc,rs1,rs2,imm,alu_code,alu_op1_type,alu_op2_type,alu_op1,alu_op2,npc_op1,npc_op2);
  input wire [31:0] pc;
  input wire [31:0] rs1;
  input wire [31:0] rs2;
  input wire [31:0] imm;
  input wire [6:0] alu_code;
  input wire [1:0] alu_op1_type;
  input wire [1:0] alu_op2_type;

  output wire [31:0] alu_op1;
  output wire [31:0] alu_op2;

  output [31:0] npc_op1;
  output [31:0] npc_op2;

  reg [31:0] npc_op1;
  reg [31:0] npc_op2;


  assign alu_op1 = (alu_op1_type == `OP_TYPE_REG) ? rs1 : (alu_op1_type == `OP_TYPE_IMM) ? imm : (alu_op1_type == `OP_TYPE_PC) ? pc :  32'd0;
  assign alu_op2 = (alu_op2_type == `OP_TYPE_REG) ? rs2 : (alu_op2_type == `OP_TYPE_IMM) ? imm : (alu_op2_type == `OP_TYPE_PC) ? pc :  32'd0;

  always@(*) begin
    case (alu_code)
      `ALU_JAL: begin
        npc_op1 <= pc;
        npc_op2 <= imm;
      end

      `ALU_JALR: begin
        npc_op1 <= rs1;
        npc_op2 <= imm;
      end

      `ALU_BEQ: begin
        npc_op1 <= pc;
        npc_op2 <= imm;
      end

      `ALU_BNE: begin
        npc_op1 <= pc;
        npc_op2 <= imm;
      end

      `ALU_BLT: begin
        npc_op1 <= pc;
        npc_op2 <= imm;
      end

      `ALU_BGE: begin
        npc_op1 <= pc;
        npc_op2 <= imm;
      end

      `ALU_BLTU: begin
        npc_op1 <= pc;
        npc_op2 <= imm;
      end

      `ALU_BGEU: begin
        npc_op1 <= pc;
        npc_op2 <= imm;
      end
      
      default : begin
        npc_op1 <= pc;
        npc_op2 <= 32'd4;
      end
    endcase
  end

endmodule
