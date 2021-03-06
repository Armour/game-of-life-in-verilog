`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:36 01/12/2015 
// Design Name: 
// Module Name:    game_of_life 
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
module game_of_life( input wire clk, 
				input wire [7:0] switch, 
				input wire [4:0] btn_in,			
				output wire [3:0] anode, 	
	//output reg 	[3:0] position_x,			// those are used for test
	//output reg 	[3:0] position_y,
	//output reg	[15:0] position,	
	//output reg  [255:0] map,
	//output reg   [767:0] springs,
				output wire [7:0] segment,
				output wire led_frequency,
				output wire led_status,
				output Hsync,
				output Vsync,
				output [2:0] vgaRed,
				output [2:0] vgaGreen,
				output [1:0] vgaBlue);
				
	wire reset;
	wire inside_video;
	wire [9:0] x_position;
	wire [8:0] y_position;
	
	wire	clock;					// a clock with changeable frequency
	wire	[4:0] btn_out;			// the signal of botton after debounced
	reg	[31:0] freq;			// used for storing the frequency
	reg   [7:0] tempx;			// used for calculating where is (x,y) in  [255:0] position 
	reg 	[7:0] tempy;			// used for calculating where is (x,y) in  [255:0] position 
	reg 	[4:0] tempr;			// used for saving the random number
	reg 	[2:0] spring[0:255];	// used for calculating the adjacent spring number of present generation
	reg 	[3:0] position_x;		// position X
	reg 	[3:0] position_y;		// position Y
	reg	[15:0] position;		// position "x, y" in decimal formal
	reg	[15:0] display_num;	// used for display
	reg	[31:0] random_count;	// used for random switch counting
	reg	[31:0] generate_count;	// used for each generation counting
	reg 	[31:0] btn0;			// used for botton counting
	reg 	[31:0] btn1;
	reg 	[31:0] btn2;
	reg 	[31:0] btn3;
	reg 	[31:0] btn4;
	reg   [255:0] map;			// the map of "game of life"
	reg	[8:0] i;					// iterator
	reg 	flag = 0;				// the flag of botton[4]
		
	// The clock for vga
	clock_25M frac(clk, clk25M);
	
	// assign the view
	vga_display view(map, position_x, position_y, inside_video, x_position, y_position, vgaRed, vgaGreen, vgaBlue);
	
	// assign the vga controller
	vga_controller vga(clk25M, reset, Hsync, Vsync, inside_video, x_position, y_position);

	
	initial begin
		tempr = 5;
		random_count = 0;
		map <= 256'b0;											// initialize the map to empty
		freq <= 32'd25_000_000;								// initialize frequency to be 500000000 times (between change of status)
		position_x <= 4'b0000;								// position x 
		position_y <= 4'b0000;								// position y
		position <= 16'b0000_0000_0000_0000;			// position x, y (display use decimal)
	end
	
	always @(switch) begin									// control the frequency of clock through switch
		if (switch[0] == 0) begin							// 0 means slower
			case (switch[3:1])
				3'b000 : freq <= 32'd 25_000_000;
				3'b100 : freq <= 32'd 50_000_000;
				3'b010 : freq <= 32'd 75_000_000;
				3'b110 : freq <= 32'd100_000_000;
				3'b001 : freq <= 32'd125_000_000;
				3'b101 : freq <= 32'd150_000_000;
				3'b011 : freq <= 32'd175_000_000;
				3'b111 : freq <= 32'd200_000_000;
			endcase
		end else begin											// 1 means faster
			case (switch[3:1])
				3'b000 : freq <= 32'd 25_000_000;
				3'b100 : freq <= 32'd 12_500_000;
				3'b010 : freq <= 32'd  8_333_333;
				3'b110 : freq <= 32'd  6_250_000;
				3'b001 : freq <= 32'd  5_000_000;
				3'b101 : freq <= 32'd  4_166_666;
				3'b011 : freq <= 32'd  3_555_555;
				3'b111 : freq <= 32'd  3_125_000;
			endcase
		end
	end
	
	pbdebounce p0(clk, btn_in[0], btn_out[0]);		// button debounce
	pbdebounce p1(clk, btn_in[1], btn_out[1]);
	pbdebounce p2(clk, btn_in[2], btn_out[2]);
	pbdebounce p3(clk, btn_in[3], btn_out[3]);
	pbdebounce p4(clk, btn_in[4], btn_out[4]);
	
	display m0(clk, display_num, anode[3:0], segment[7:0]);			//display position x, y
	
	counter_1s ct(clk, freq[31:0], clock);							// clock with different frequency
	
	assign led_frequency = clock;										// led flash in the same frequency with clock
	assign led_status = map[tempy * 16 + tempx];					// led flash in the same frequency with clock
	
	always @* begin			
		display_num <= position;							// display the position
	end	
	
	always @(position_x) begin								// display x with decimal
		if (position_x < 4'b1010) begin
			position[11:8] <= position_x[3:0];
			position[15:12] <= 4'b0000;
		end else begin
			position[11:8] <= position_x[3:0] - 4'b1010;
			position[15:12] <= 4'b0001;
		end
	end
	
	always @(position_y) begin								// display y with decimal
		if (position_y < 4'b1010) begin
			position[3:0] <= position_y[3:0];
			position[7:4] <= 4'b0000;
		end else begin
			position[3:0] <= position_y[3:0] - 4'b1010;
			position[7:4] <= 4'b0001;
		end
	end
	
	always @(posedge clk) begin
		tempx <= position_x;
		tempy <= position_y;
		
		if (btn_out[0]) btn0 = btn0 + 1;
		if (btn_out[1]) btn1 = btn1 + 1;
		if (btn_out[2]) btn2 = btn2 + 1;
		if (btn_out[3]) btn3 = btn3 + 1;
		
		if (btn0 >= 12_000_000) begin						// btn[0]  => x + 1
			btn0 = 0;
			position_x = position_x + 4'b1; 
		end
		
		if (btn1 >= 12_000_000) begin						// btn[0]  => x - 1
			btn1 = 0;
			position_x = position_x - 4'b1;
		end
		
		if (btn2 >= 12_000_000) begin						// btn[2]  => y + 1
			btn2 = 0;
			position_y = position_y + 4'b1; 
		end
		
		if (btn3 >= 12_000_000) begin						// btn[2]  => y - 1
			btn3 = 0;
			position_y = position_y - 4'b1;
		end
	end
	
	always @(posedge clk) begin
		if (btn_out[4]) begin
			if (flag == 0) begin						// change the status of position (x,y)
				flag = 1;
				map[tempy * 16 + tempx] = ~map[tempy * 16 + tempx];			// change to opposite status
			end
		end else flag = 0;
	
		if (switch[5] == 1 && switch[4] == 1) 				// switch[4] is the random switch and it must in "stop" mode 
			random_count = random_count + 1;
		if (random_count >= 100_000_000) begin				// maintain for enough time
			random_count = 0;
			for (i = 0; i < 256; i = i + 1) begin: intial_randomly
					//tempr = {$random} % 10;					// only used when test
					tempr = (i + generate_count[3] +generate_count[8]) % 10;
					if (tempr < 4)									// 40% to be 1 (random)
						map[i] = 1;
					else 
						map[i] = 0;									// 60% to be 0 (random)
			end
		end
		
		if (switch[5] == 0) 								// if in "run" mode
			generate_count = generate_count + 1;
		if (generate_count >= freq * 2) begin		// maintain for enough time
			generate_count = 0;
			for (i = 0; i < 256; i = i + 1) begin: new_generation
				if ((spring[i] == 2 || spring[i] == 3) && map[i] == 1)
					map[i] = 1;								// live
				else if (spring[i] == 3 && map[i] == 0)
					map[i] = 1;								// new life
				else 
					map[i] = 0;		 						// die
			end
		end
			
		if (switch[5]) begin														// must in "stop" mode 
			if (switch[6] == 1 && switch[7] == 0) begin					// initialize to "Glider" status
				map = 256'b0;
				map[0] = 1'b1;
				map[17] = 1'b1;
				map[18] = 1'b1;
				map[32] = 1'b1;
				map[33] = 1'b1;
			end else if (switch[6] == 0 && switch[7] == 1) begin		// initialize to "Lightweight spaceship" status
				map = 256'b0;
				map[101] = 1'b1;
				map[104] = 1'b1;
				map[121] = 1'b1;
				map[133] = 1'b1;
				map[137] = 1'b1;
				map[150] = 1'b1;
				map[151] = 1'b1;
				map[152] = 1'b1;
				map[153] = 1'b1;
			end else if (switch[6] == 1 && switch[7] == 1) begin		// initialize to "Pulsar" status
				map = 256'b0;
				map[19] = 1'b1;
				map[20] = 1'b1;
				map[21] = 1'b1;
				map[49] = 1'b1;
				map[65] = 1'b1;
				map[81] = 1'b1;
				map[54] = 1'b1;
				map[70] = 1'b1;
				map[86] = 1'b1;
				map[99] = 1'b1;
				map[100] = 1'b1;
				map[101] = 1'b1;
				
				map[25] = 1'b1;
				map[26] = 1'b1;
				map[27] = 1'b1;
				map[56] = 1'b1;
				map[72] = 1'b1;
				map[88] = 1'b1;
				map[61] = 1'b1;
				map[77] = 1'b1;
				map[93] = 1'b1;
				map[105] = 1'b1;
				map[106] = 1'b1;
				map[107] = 1'b1;
				
				map[131] = 1'b1;
				map[132] = 1'b1;
				map[133] = 1'b1;
				map[145] = 1'b1;
				map[161] = 1'b1;
				map[177] = 1'b1;
				map[150] = 1'b1;
				map[166] = 1'b1;
				map[182] = 1'b1;
				map[211] = 1'b1;
				map[212] = 1'b1;
				map[213] = 1'b1;
								
				map[137] = 1'b1;
				map[138] = 1'b1;
				map[139] = 1'b1;
				map[152] = 1'b1;
				map[168] = 1'b1;
				map[184] = 1'b1;
				map[157] = 1'b1;
				map[173] = 1'b1;
				map[189] = 1'b1;
				map[217] = 1'b1;
				map[218] = 1'b1;
				map[219] = 1'b1;
			end
		end
	end
	
	generate															// use generate-for-loop to calculate next status (more elegent)
		genvar j;
		for (j = 0; j < 256; j = j + 1 ) begin: next_status
			always @(posedge clock) begin
				spring[j] <= 3'b000 + map[left(j)] 			// calculate the adjacent spring number
										+ map[right(j)] 
										+ map[up(j)] 
										+ map[down(j)] 
										+ map[up_left(j)] 
										+ map[up_right(j)] 
										+ map[down_left(j)] 
										+ map[down_right(j)];
			end
		end
	endgenerate
	
	function [15:0] up;						// find the up position of map[here]
		input [15:0] here;
		begin
			if (here < 16) 
				up = here + 240;				
			else 
				up = here - 16;
		end
	endfunction
	
	function [15:0] down;					// find the down position of map[here]
		input [15:0] here;
		begin
			if (here > 239) 
				down = here - 240;				
			else 
				down = here + 16;
		end
	endfunction
	
	function [15:0] left;					// find the left position of map[here]
		input [15:0] here;
		begin
			if (here % 16 == 0) 
				left = here + 15;				
			else 
				left = here - 1;
		end
	endfunction
	
	function [15:0] right;					// find the right position of map[here]
		input [15:0] here;
		begin
			if (here % 16 == 15) 
				right = here - 15;				
			else 
				right = here + 1;
		end
	endfunction
		
	function [15:0] up_left;				// find the up_left position of map[here]
		input [15:0] here;
		begin
			if (here == 0) 
				up_left = 255;				
			else if (here < 16 && here != 0)
				up_left = here + 239;
			else if (here % 16 == 0 && here != 0)
				up_left = here - 1;
			else
				up_left = here - 17;
		end
	endfunction
	
	function [15:0] up_right;				// find the up_right position of map[here]
		input [15:0] here;
		begin
			if (here == 15) 
				up_right = 240;				
			else if (here < 16 && here != 15)
				up_right = here + 241;
			else if (here % 16 == 15 && here != 15)
				up_right = here - 31;
			else
				up_right = here - 15;
		end
	endfunction
			
	function [15:0] down_left;				// find the down_left position of map[here]v
		input [15:0] here;
		begin
			if (here == 240) 
				down_left = 15;				
			else if (here > 239 && here != 240)
				down_left = here - 241;
			else if (here % 16 == 0 && here != 240)
				down_left = here + 31;
			else
				down_left = here + 15;
		end
	endfunction
	
	function [15:0] down_right;			// find the down_right position of map[here]
		input [15:0] here;
		begin
			if (here == 255) 
				down_right = 0;				
			else if (here > 239 && here != 255)
				down_right = here - 239;
			else if (here % 16 == 15 && here != 255)
				down_right = here + 1;
			else
				down_right = here + 17;
		end
	endfunction
	
endmodule
