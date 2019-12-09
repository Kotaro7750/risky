`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 18:56:27
// Design Name: 
// Module Name: decode
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


module decode(clk,inst_b,src1_reg,src2_reg,dst_reg,imm,alu_code,alu_op1_type,alu_op2_type,reg_w_enable_0,is_load,is_store,is_halt);
  input clk;
  input wire [31:0] inst_b;   //機械語命令列
  reg [31:0] inst_b_reg;

  //トップモジュールでレジスタファイルから持ってくる用
  output  wire [4:0]	src1_reg;  // ソースレジスタ1番号
  output  wire [4:0]	src2_reg;  // ソースレジスタ2番号
  output wire [4:0] dst_reg;

  output wire [31:0]	imm;          // 即値

  output wire   [5:0]	alu_code;      // ALUの演算種別
  output wire   [1:0]	alu_op1_type;  // ALUの入力タイプ
  output wire   [1:0]	alu_op2_type;  // ALUの入力タイプ
  output wire	     	reg_w_enable_0;       // レジスタ書き込みの有無
  output wire		is_load;      // ロード命令判定フラグ
  output wire		is_store;     // ストア命令判定フラグ
  output wire    is_halt;

  wire	     	reg_w_enable;       // レジスタ書き込みの有無

  assign reg_w_enable_0 = dst_reg == 0 ? 0 : reg_w_enable;

  always@(posedge clk)begin
    inst_b_reg <= inst_b;
    end

  decoder decoder(inst_b_reg,src1_reg,src2_reg,dst_reg,imm,alu_code,alu_op1_type,alu_op2_type,reg_w_enable,is_load,is_store,is_halt);

endmodule
