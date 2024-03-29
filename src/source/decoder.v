`timescale 1ns / 1ps

`include "define.vh"

module decoder(inst_b,src1_reg,src2_reg,dst_reg,imm,alu_code,alu_op1_type,alu_op2_type,reg_w_enable,is_load,is_store,is_halt);
  input  wire [31:0]  inst_b;           // 機械語命令列

  output [4:0]	src1_reg;  // ソースレジスタ1番号
  output [4:0]	src2_reg;  // ソースレジスタ2番号
  output [4:0]	dst_reg;   // デスティネーションレジスタ番号
  //これ以下がそれぞれで違う
  output [31:0]	imm;          // 即値
  output reg   [5:0]	alu_code;      // ALUの演算種別
  output reg   [1:0]	alu_op1_type;  // ALUの入力タイプ
  output reg   [1:0]	alu_op2_type;  // ALUの入力タイプ
  output reg	     	reg_w_enable;       // レジスタ書き込みの有無
  output reg		is_load;      // ロード命令判定フラグ
  output reg		is_store;     // ストア命令判定フラグ
  output reg    is_halt;

  //alwaysの中でやる用のreg
  reg [31:0]	imm;
  reg [4:0] src1_reg;
  reg [4:0] src2_reg;
  reg [4:0] dst_reg;

  wire [6:0] opcode;
  wire [2:0] opcode_2;
  wire [6:0] opcode_3;

  assign opcode = inst_b[6:0];
  assign opcode_2 = inst_b[14:12];
  assign opcode_3 = inst_b[31:25];

  //これ以降はreg用
  always@(inst_b) begin
    is_halt <= `DISABLE;
    case (opcode)
      //ADDi ~ SRAi
      7'b0010011: begin
        alu_op1_type <= `OP_TYPE_REG;
        alu_op2_type <= `OP_TYPE_IMM;

        reg_w_enable <= `ENABLE;
        is_load <= `DISABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= inst_b[19:15];
        src2_reg <= 0;
        dst_reg <= inst_b[11:7];

        if (opcode_2 != 3'b001 && opcode_2 != 3'b101) begin
          //ADDi,SLTi,SLTiu,XORi,ORi,ANDi
          imm <= {{20{inst_b[31]}},inst_b[31:20]};

          case (opcode_2)
            //ADDi
            3'b000: begin
              alu_code <= `ALU_ADD;
            end
            //SLTi
            3'b010: begin
              alu_code <= `ALU_SLT;
            end
            //SLTiu
            3'b011: begin
              alu_code <= `ALU_SLTU;
            end
            //XORi
            3'b100: begin
              alu_code <= `ALU_XOR;
            end
            //ORi
            3'b110: begin
              alu_code <= `ALU_OR;
            end
            //ANDi
            3'b111: begin
              alu_code <= `ALU_AND;
            end
          endcase

        end
        else begin
          //SLLi,SRLi,SRAi
          imm <= {{27{inst_b[24]}},inst_b[24:20]};

          if (opcode_2 == 3'b001) begin
            //SLLi
            alu_code <= `ALU_SLL;
          end
          else if (opcode_2 == 3'b101) begin
            if (opcode_3 == 7'b0000000) begin
              //SRLi
              alu_code <= `ALU_SRL;
            end
            else begin
              //SRAi
              alu_code <= `ALU_SRA;
            end
          end
        end
      end

      //ADD ~ AND
      7'b0110011: begin
        //op1:reg op2:reg
        alu_op1_type <= `OP_TYPE_REG;
        alu_op2_type <= `OP_TYPE_REG;

        reg_w_enable <= `ENABLE;
        is_load <= `DISABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= inst_b[19:15];
        src2_reg <= inst_b[24:20];
        dst_reg <= inst_b[11:7];

        imm <= 32'b0;

        case (opcode_2)
          //ADD,SUB
          3'b000: begin
            if (opcode_3 == 7'b0000000) begin
              //ADD
              alu_code <= `ALU_ADD;
            end
            else if (opcode_3 == 7'b0100000) begin
              //SUB
              alu_code <= `ALU_SUB;
            end
          end
          //SLL
          3'b001: begin
              alu_code <= `ALU_SLL;
          end
          //SLT
          3'b010: begin
              alu_code <= `ALU_SLT;
          end
          //SLTu
          3'b011: begin
              alu_code <= `ALU_SLTU;
          end
          //XOR
          3'b100: begin
              alu_code <= `ALU_XOR;
          end
          //SRL,SRA
          3'b101: begin
            if (opcode_3 == 7'b0000000) begin
              //SRL
              alu_code <= `ALU_SRL;
            end
            else if (opcode_3 == 7'b0100000) begin
              //SRA
              alu_code <= `ALU_SRA;
            end
          end
          //OR
          3'b110: begin
              alu_code <= `ALU_OR;
          end
          //AND
          3'b111: begin
              alu_code <= `ALU_AND;
          end
        endcase
      end

    //LUi
    7'b0110111: begin
        //op1:none op2:imm
        alu_op1_type <= `OP_TYPE_NONE;
        alu_op2_type <= `OP_TYPE_IMM;

        reg_w_enable <= `ENABLE;
        is_load <= `DISABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= 0;
        src2_reg <= 0;
        dst_reg <= inst_b[11:7];
        imm <= {inst_b[31:12],{12{1'b0}}};
        alu_code <= `ALU_LUI;
    end

    //AUiPC
    7'b0010111: begin
        //op1:imm op2:pc
        alu_op1_type <= `OP_TYPE_IMM;
        alu_op2_type <= `OP_TYPE_PC;

        reg_w_enable <= `ENABLE;
        is_load <= `DISABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= 0;
        src2_reg <= 0;
        dst_reg <= inst_b[11:7];
        imm <= {inst_b[31:12],{12{1'b0}}};
        alu_code <= `ALU_ADD;
    end

    //JAL
    7'b1101111: begin
        //op1:none op2:pc
        alu_op1_type <= `OP_TYPE_NONE;
        alu_op2_type <= `OP_TYPE_PC;

        reg_w_enable <= `ENABLE;
        if (inst_b[11:7] == 5'b00000) begin
          reg_w_enable <= `DISABLE; 
        end
        is_load <= `DISABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= 0;
        src2_reg <= 0;
        dst_reg <= inst_b[11:7];

        imm <= {{11{inst_b[31]}},inst_b[31],inst_b[19:12],inst_b[20],inst_b[30:21],{1'b0}};
        alu_code <= `ALU_JAL;
    end

    //JALR
    7'b1100111: begin
        //op1:reg op2:pc
        alu_op1_type <= `OP_TYPE_REG;
        alu_op2_type <= `OP_TYPE_PC;

        reg_w_enable <= 1;
        if (inst_b[11:7] == 5'b00000) begin
          reg_w_enable <= `DISABLE; 
        end
        is_load <= `DISABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= inst_b[19:15];
        src2_reg <= 0;
        dst_reg <= inst_b[11:7];

        imm <= {{20{inst_b[31]}},inst_b[31:20]};
        alu_code <= `ALU_JALR;
    end

    //Beq ~ Bgeu
    7'b1100011:begin
        //op1:reg op2:reg
        alu_op1_type <= `OP_TYPE_REG;
        alu_op2_type <= `OP_TYPE_REG;

        reg_w_enable <= `DISABLE;
        is_load <= `DISABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= inst_b[19:15];
        src2_reg <= inst_b[24:20];
        dst_reg <= `REG_NONE;

        imm <= {{19{inst_b[31]}},inst_b[31],inst_b[7],inst_b[30:25],inst_b[11:8],{1'b0}};

        case (opcode_2)
          3'b000: begin
            //Beq
            alu_code <= `ALU_BEQ;
          end
          3'b001: begin
            //Bne
            alu_code <= `ALU_BNE;
          end
          3'b100: begin
            //Blt
            alu_code <= `ALU_BLT;
          end
          3'b101: begin
            //Bge
            alu_code <= `ALU_BGE;
          end
          3'b110: begin
            //Bltu
            alu_code <= `ALU_BLTU;
          end
          3'b111: begin
            //Bgeu
            alu_code <= `ALU_BGEU;
          end
        endcase
    end

    //Sb ~ Sw
    7'b0100011: begin
        //op1:reg op2:imm
        alu_op1_type <= `OP_TYPE_REG;
        alu_op2_type <= `OP_TYPE_IMM;

        reg_w_enable <= `DISABLE;
        is_load <= `DISABLE;
        is_store <= `ENABLE;
        is_halt <= `DISABLE;

        src1_reg <= inst_b[19:15];
        src2_reg <= inst_b[24:20];
        dst_reg <= `REG_NONE;

        imm <= {{20{inst_b[31]}},inst_b[31:25],inst_b[11:7]};
      case (opcode_2)
        3'b000: begin
          //Sb
          alu_code <= `ALU_SB;
        end
        3'b001: begin
          //Sh
          alu_code <= `ALU_SH;
        end
        3'b010: begin
          //Sw
          alu_code <= `ALU_SW;
        end
      endcase
    end

    //Lb ~ Lhu
    7'b0000011: begin
        //op1:reg op2:imm
        alu_op1_type <= `OP_TYPE_REG;
        alu_op2_type <= `OP_TYPE_IMM;

        reg_w_enable <= `ENABLE;
        is_load <= `ENABLE;
        is_store <= `DISABLE;
        is_halt <= `DISABLE;

        src1_reg <= inst_b[19:15];
        src2_reg <= 0;
        dst_reg <= inst_b[11:7];

        imm <= {{20{inst_b[31]}},inst_b[31:20]};
        case (opcode_2)
          3'b000: begin
            //Lb
            alu_code <= `ALU_LB;
          end
          3'b001: begin
            //Lh
            alu_code <= `ALU_LH;
          end
          3'b010: begin
            //Lw
            alu_code <= `ALU_LW;
          end
          3'b100: begin
            //Lbu
            alu_code <= `ALU_LBU;
          end
          3'b101: begin
            //Lhu
            alu_code <= `ALU_LHU;
          end
        endcase
    end

    default: begin
      src1_reg <= `REG_NONE;
      src2_reg <= `REG_NONE;
      dst_reg <= `REG_NONE;
      imm <= 32'd0;
      alu_code <= `ALU_NOP;
      alu_op1_type <= `OP_TYPE_NONE;
      alu_op2_type <= `OP_TYPE_NONE;
      reg_w_enable <= `DISABLE;
      is_load <= `DISABLE;
      is_store <= `DISABLE;
      is_halt <= `ENABLE;
    end
    endcase
  end
endmodule
