`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:35:40 02/02/2015
// Design Name:   test
// Module Name:   D:/Xilinx_14.7_/Project/Test/test_position.v
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

module test_position;

	// Inputs
	reg clk;
	reg [3:0] switch;
	reg [3:0] btn_in;

	// Outputs
	wire [3:0] anode;
	wire [3:0] position_x;
	wire [3:0] position_y;
	wire [15:0] position;
	wire [7:0] segment;
	wire led;

	// Instantiate the Unit Under Test (UUT)
	test uut (
		.clk(clk), 
		.switch(switch), 
		.btn_in(btn_in), 
		.anode(anode), 
		.position_x(position_x), 
		.position_y(position_y), 
		.segment(segment), 
		.led(led),
		.position(position)
	);

	initial forever begin
		clk = 0;
		#1;
		clk = 1;
		#1;		
	end

	initial begin
		// Initialize Inputs
		switch = 0;
		btn_in = 0;

		// Wait 100 ns for global reset to finish
		#5000000;
		btn_in[0] = 1;
		#1600000;
		btn_in[0] = 0;
		#5000000;
		btn_in[0] = 1;
		#1600000;
		btn_in[0] = 0;
		#5000000;
		btn_in[1] = 1;
		#1600000;
		btn_in[1] = 0;
		#5000000;
		btn_in[1] = 1;
		#1600000;
		btn_in[1] = 0;
		#5000000;
		btn_in[1] = 1;
		#1600000;
		btn_in[1] = 0;
		#5000000;
		
		btn_in = 4'b0011;
		#1600000;
		btn_in = 4'b0000;
		#5000000;
		// Add stimulus here

	end
      
endmodule

