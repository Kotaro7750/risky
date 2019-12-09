`timescale 1ns / 1ps

module execute(clk,pc,src1_data,src2_data,imm,alu_code,alu_op1_type,alu_op2_type,alu_result,w_data,mem_access_width,is_load_unsigned,npc);
  input clk;
  input wire [31:0] pc;
  input wire [31:0] src1_data;
  input wire [31:0] src2_data;
  input wire [31:0] imm;
  input wire [5:0] alu_code;
  input wire [1:0] alu_op1_type;
  input wire [1:0] alu_op2_type;

  reg [31:0] pc_reg_ex;
  reg [31:0] src1_data_reg;
  reg [31:0] src2_data_reg;
  reg [31:0] imm_reg;
  reg [5:0] alu_code_reg;
  reg [1:0] alu_op1_type_reg;
  reg [1:0] alu_op2_type_reg;

  wire [31:0] alu_op1;
  wire [31:0] alu_op2;
  wire [31:0] npc_op1;
  wire [31:0] npc_op2;

  wire br_taken;

  output wire [31:0] alu_result;
  output wire [31:0] w_data;
  output wire [1:0] mem_access_width;
  output wire is_load_unsigned;
  output wire [31:0] npc;

  assign w_data = src2_data;

  always@(posedge clk) begin
    pc_reg_ex <= pc;
    src1_data_reg <= src1_data;
    src2_data_reg = src2_data;
    imm_reg <= imm;
    alu_code_reg <= alu_code;
    alu_op1_type_reg <= alu_op1_type;
    alu_op2_type_reg <= alu_op2_type;
  end

  exec_switcher exec_switcher(pc_reg_ex,src1_data_reg,src2_data_reg,imm_reg,alu_code_reg,alu_op1_type_reg,alu_op2_type_reg,alu_op1,alu_op2,npc_op1,npc_op2);

  alu alu(alu_code_reg,alu_op1,alu_op2,alu_result,br_taken,mem_access_width,is_load_unsigned);

  npc_gen npc_gen(npc_op1,npc_op2,br_taken,npc);

endmodule
