`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:49:38 01/12/2015 
// Design Name: 
// Module Name:    timer_1ms 
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
module timer_1ms(input wire clk, 
					output reg clk_1ms);
	reg [16:0] cnt;	
	initial begin
		cnt [16:0] <=0;
		clk_1ms <= 0;
	end
	always @ (posedge clk) begin
		if (cnt < 50_000) begin
			cnt <= cnt + 1;
		end else begin
			cnt <= 0;
			clk_1ms <= ~clk_1ms;
		end 
	end
endmodule
