`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/25 15:19:13
// Design Name: 
// Module Name: fetch
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


module inst_mem(pc,inst_b);
  input wire [31:0] pc;

  output wire [31:0] inst_b;

  reg [31:0] inst [0:32767];             //32bitレジスタ*32

  assign inst_b = inst[pc >> 2];
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/tests/IntRegReg/code.hex",inst);
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/tests/IntRegImm/code.hex",inst);
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/tests/ZeroRegister/code.hex",inst);
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/tests/ControlTransfer/code.hex",inst);
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/tests/LoadAndStore/code.hex",inst);
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/tests/Uart/code.hex",inst);
  //initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/tests/HardwareCounter/code.hex",inst);
  initial $readmemh("/home/denjo/lecture/3A/experiment/processor/b3exp/benchmarks/Coremark_for_Synthesis/prog.hex",inst);
endmodule
