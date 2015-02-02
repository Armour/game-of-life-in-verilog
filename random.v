`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:18 02/02/2015 
// Design Name: 
// Module Name:    random 
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
module random(inout wire map[0:15][0:15]);
	genvar i, j;
	for (i = 0; i <= 15; i = i + 1)
		for (j = 0; j <= 15; j = j + 1)
			assign map[i][j] = {$random} % 2;
endmodule
