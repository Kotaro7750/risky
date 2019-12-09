`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 18:52:14
// Design Name: 
// Module Name: risky
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


module risky(sysclk,cpu_resetn,uart_tx);
  input wire sysclk;
  wire clk;

  assign clk = sysclk;

  wire rstd;

  assign rstd = cpu_resetn;
  input wire cpu_resetn;

  output wire uart_tx;

  //命令関係
  wire [31:0]  inst_b;

  //pc関係
  reg [31:0] pc;
  wire [31:0] npc;

  //レジスタ関係
  wire [4:0]	src1_reg;  
  wire [4:0]	src2_reg;  
  wire [4:0]	dst_reg;   
  wire [31:0] src1_data;
  wire [31:0] src2_data;
  wire [31:0] writeback_data;
  wire [31:0] w_data;

  //即値
  wire [31:0]	imm;          

  //alu関係
  wire [5:0]	alu_code;      
  wire [1:0]	alu_op1_type; 
  wire [1:0]	alu_op2_type; 
  wire [31:0] alu_result;
  wire [31:0] result;

  //メモリ関連
  wire [1:0] mem_access_width;
  wire [31:0] r_data;
  wire [31:0] r_data_hc;


  //各種フラグ
  wire w_enable; 
  wire is_load;      
  wire is_load_unsigned;
  wire is_store;    
  wire is_halt;


  

  //---パイプライン？用レジスタ---
  //ステージカウンタ
  reg [2:0] stage;

  reg is_store_reg;

  //---ステージ系---
  wire ex_clk;
  assign ex_clk = stage == `EX_STAGE ? clk : 1'b0;

  wire wb_w_enable; 
  assign wb_w_enable = stage == `IF_STAGE ? w_enable : `DISABLE;

  //uart
  wire [7:0] uart_IN_data;
  wire uart_we;
  wire uart_OUT_data;

  assign uart_tx = uart_OUT_data;

  uart uart0(
      .uart_tx(uart_OUT_data),
      .uart_wr_i(uart_we),
      .uart_dat_i(uart_IN_data),
      .sys_clk_i(clk),
      .sys_rstn_i(rstd)
  );


  //ハードウェアカウンタ
  wire [31:0] hc_OUT_data;

    hardware_counter hardware_counter(
        .CLK_IP(clk),
        .RSTN_IP(rstd),
        .COUNTER_OP(hc_OUT_data)
    );

    assign r_data_hc = hc_access == `ENABLE ? hc_OUT_data : r_data;




  reg_file reg_file(clk, rstd, writeback_data, src1_reg, src2_reg, dst_reg, wb_w_enable, src1_data, src2_data);

  fetch fetch(clk,pc,inst_b);

  decode decode(clk,inst_b,src1_reg,src2_reg,dst_reg,imm,alu_code,alu_op1_type,alu_op2_type,w_enable,is_load,is_store,is_halt);

  execute execute(ex_clk,pc,src1_data,src2_data,imm,alu_code,alu_op1_type,alu_op2_type,alu_result,w_data,mem_access_width,is_load_unsigned,npc);

  memory_access memory_access(clk,is_store_reg,alu_result,mem_access_width,is_load_unsigned,w_data,r_data,result,uart_IN_data,uart_we,hc_access);

  writeback writeback(clk,is_load,r_data_hc,result,writeback_data);


  always@(negedge clk or negedge rstd) begin
    if (rstd == 0) begin
      stage <= `IF_STAGE;
      //pc  <= 32'd32760;
      pc <= 32'd0;
      //npc  <= 32'd32760;
    end
    else begin
      
    case (stage)
      `IF_STAGE: begin
        stage <= `D_STAGE;
      end
      `D_STAGE: begin
        stage <= `EX_STAGE;
      end
      `EX_STAGE: begin
        stage <= `MA_STAGE;
        is_store_reg <= is_store;
      end
      `MA_STAGE: begin
        stage <= `RW_STAGE;
        is_store_reg <= 0;
      end
      `RW_STAGE: begin
        pc <= npc;
        stage <= `IF_STAGE;
      end
    endcase
      end
  end
endmodule
