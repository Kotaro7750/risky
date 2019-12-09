`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 17:32:47
// Design Name: 
// Module Name: register
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

module reg_file(clk, rstd, w_data, r_addr1, r_addr2, w_addr, w_enable, r_data1, r_data2);
	input	clk, rstd, w_enable;
	input	[31:0]	w_data;
	input	[4:0]	r_addr1, r_addr2, w_addr;
	output	[31:0]	r_data1, r_data2;
	reg		[31:0]	register_file[0:31];

  wire [31:0] sum;

  assign sum = register_file[3];

	assign r_data1 = register_file[r_addr1];
	assign r_data2 = register_file[r_addr2];

	always @(negedge rstd or posedge clk) begin
    //r0 レジスタは常に0
    //register_file[0] <= 32'h00000000;
    if (rstd == 0)	begin
      //r0 レジスタは常に0
      for (integer i = 0; i < 32; i = i+1) begin
        register_file[i] <= 32'h00000000;
      end
    end
    else if (w_enable == 1)	begin
      register_file[w_addr] <= w_data;
    end
  end
endmodule
