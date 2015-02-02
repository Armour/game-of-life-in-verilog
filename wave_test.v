`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:59:55 02/02/2015
// Design Name:   test
// Module Name:   D:/Xilinx_14.7_/Project/Test/wave_test.v
// Project Name:  Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module wave_test;

	// Inputs
	reg clk;
	reg [3:0] switch;
	reg [3:0] btn_in;

	// Outputs
	wire [3:0] anode;
	wire [7:0] segment;
	wire [29:0] freq;
	wire clock;
	wire led;

	// Instantiate the Unit Under Test (UUT)
	test uut (
		.clk(clk), 
		.switch(switch), 
		.btn_in(btn_in), 
		.anode(anode), 
		.segment(segment), 
		.freq(freq), 
		.clock(clock), 
		.led(led)
	);
	
	initial forever begin 
		clk = 0;
		#50;
		clk = 1;
		#50;
	end
	
	initial begin
		// Initialize Inputs
		switch = 0;
		btn_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
      switch[3] = 1;
		#100;
		switch[2] = 1;
		#100;
		switch[1] = 1;
		#100;
		switch[0] = 1;
		#100;
		// Add stimulus here

	end
      
endmodule

