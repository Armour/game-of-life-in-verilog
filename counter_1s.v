`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:43:28 01/12/2015 
// Design Name: 
// Module Name:    counter_1s 
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
module counter_1s( input wire clk, 		
						input wire [31:0] freq, 
						output reg clk_1s);
	reg [31:0] cnt;
	initial begin
		cnt [31:0] <=0;
		clk_1s <= 0;
	end
	always @ (posedge clk) begin
		if (cnt < freq) begin
			cnt <= cnt + 1;
		end else begin
			cnt <= 0;
			clk_1s <= ~clk_1s;
		end 
	end
endmodule
