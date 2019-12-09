`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 14:43:02
// Design Name: 
// Module Name: alu
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

module alu(alucode,op1,op2,alu_result,br_taken,mem_access_width,is_load_unsigned);
  input wire [5:0] alucode;     //演算種別
  input wire [31:0] op1;        //オペランド1
  input wire [31:0] op2;        //オペランド2

  output reg [31:0] alu_result; //演算結果
  output reg br_taken;   //分岐の有無

  output reg [1:0] mem_access_width;
  output reg is_load_unsigned;

  wire signed [31:0] op1_signed;
  wire signed [31:0] op2_signed;

  assign op1_signed = $signed(op1);
  assign op2_signed = $signed(op2);

  always@(alucode,op1,op2) begin
    case (alucode)
      `ALU_LUI: begin
        alu_result <= op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_JAL: begin
        alu_result <= op2 + 4;
        br_taken <= `ENABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_JALR: begin
        alu_result <= op2 + 4;
        br_taken <= `ENABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_BEQ: begin
        alu_result <= 0;
        br_taken <= (op1 == op2) ? `ENABLE : `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_BNE: begin
        alu_result <= 0;
        br_taken <= op1 != op2 ? `ENABLE : `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_BLT: begin
        alu_result <= 0;
        if ((op1 - op2) & (32'b1 << 31)) begin
          br_taken <= `ENABLE;
        end
        else begin
          br_taken <= `DISABLE;
        end
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_BGE: begin
        alu_result <= 0;
        if ( ((op2 - op1) & (32'b1 << 31)) || (op1 == op2)) begin
          br_taken <= `ENABLE;
        end
        else begin
          br_taken <= `DISABLE;
        end
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_BLTU: begin
        alu_result <= 0;
        br_taken <= op1 < op2 ? `ENABLE : `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_BGEU: begin
        alu_result <= 0;
        br_taken <= op1 >= op2 ? `ENABLE : `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_LB: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_BYTE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_LH: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_HALF;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_LW: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_WORD;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_LBU: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_BYTE;
        is_load_unsigned <= `ENABLE;
      end

      `ALU_LHU: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_HALF;
        is_load_unsigned <= `ENABLE;
      end

      `ALU_SB: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_BYTE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SH: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_HALF;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SW: begin
        alu_result <= op1 + op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_WORD;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_ADD: begin
        alu_result <= (op1 + op2) & 32'hffffffff;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SUB: begin
        alu_result <= op1 - op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SLT: begin
        if ((op1 - op2) & (32'b1 << 31)) begin
          alu_result <= 1;
        end
        else begin
          alu_result <= 0;
        end
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SLTU: begin
        alu_result <= op1 < op2 ? 1 : 0;;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_XOR: begin
        alu_result <= op1 ^ op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_OR: begin
        alu_result <= op1 | op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_AND: begin
        alu_result <= op1 & op2;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SLL: begin
        alu_result <= op1 << (op2 & 5'b11111);
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SRL: begin
        alu_result <= op1 >> (op2 & 5'b11111);
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_SRA: begin
        alu_result <= $signed(op1) >>> ($signed(op2) & 5'b11111);
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end

      `ALU_NOP: begin
        alu_result <= 32'd0;
        br_taken <= `DISABLE;
        mem_access_width <= `MEM_NONE;
        is_load_unsigned <= `DISABLE;
      end
    endcase
    
  end

endmodule
