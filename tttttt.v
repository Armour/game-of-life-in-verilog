`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:28:14 02/02/2015
// Design Name:   counter_1s
// Module Name:   D:/Xilinx_14.7_/Project/Test/tttttt.v
// Project Name:  Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter_1s
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tttttt;

	// Inputs
	reg clk;
	reg [29:0] freq;

	// Outputs
	wire clk_1s;

	// Instantiate the Unit Under Test (UUT)
	counter_1s uut (
		.clk(clk), 
		.freq(freq), 
		.clk_1s(clk_1s)
	);

	initial forever begin 
		clk = 0;
		#250_00;
		clk = 1;
		#250_00;
	end
	
	initial begin
		// Initialize Inputs
		freq <= 30'd 50;
		#150000_000;
		freq <= 30'd100;
		#150000_000;
		freq <= 30'd150;
		#150000_000;
		freq <= 30'd200;
		#150000_000;
		freq <= 30'd250;
		#150000_000;
		freq <= 30'd300;
		#150000_000;
		freq <= 30'd350;
		#150000_000;
		freq <= 30'd400;
		#150000_000;
		freq <= 30'd 50;
		#150000_000;
		freq <= 30'd 25;
		#150000_000;
		freq <= 30'd 13;
		#150000_000;
		freq <= 30'd 12;
		#150000_000;
		freq <= 30'd 10;
		#150000_000;
		freq <= 30'd  8;
		#150000_000;
		freq <= 30'd  7;
		#150000_000;
		freq <= 30'd  6;
		#150000_000;
		// Add stimulus here

	end
      
endmodule

