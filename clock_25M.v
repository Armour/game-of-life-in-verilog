`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:24 02/04/2015 
// Design Name: 
// Module Name:    clock_25M 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock_25M(clk, clk_25M);
   input wire clk;
   output reg clk_25M;
	
   reg cnt;
	
   always @(posedge clk) begin
      if (cnt) begin
         cnt <= 0;
         clk_25M <= ~clk_25M;
      end else begin
			cnt <= 1;
		end
   end

endmodule
