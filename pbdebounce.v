`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:48:18 01/12/2015 
// Design Name: 
// Module Name:    pbdebounce 
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
module pbdebounce (input wire clk,
						input wire button,
						output reg pbreg);
	wire clk_1ms;
	reg [7:0] pbshift;
	
	timer_1ms m0(clk, clk_1ms);
	
	always@(posedge clk_1ms) begin
		pbshift = pbshift << 1;					//左移1位
		pbshift[0] = button;
		if (pbshift == 0)
			pbreg = 0;
		if (pbshift == 8'b1111_1111)					// pbshift八位全为1
			pbreg = 1;
	end
endmodule
