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
				input wire [5:0] switch, 
				input wire [4:0] btn_in,			
				output wire [3:0] anode, 	
	//output reg 	[3:0] position_x,
	//output reg 	[3:0] position_y,
	//output reg	[15:0] position,	
	//output reg  [255:0] map,
				output wire [7:0] segment,
				output wire led);
				
	wire	clock;					// a clock that frequency can change
	wire	[4:0] btn_out;			// the signal of botton after debounced
	reg	[31:0] freq;			// use to store the frequency
	reg   [7:0] tempx;			// use to calculate where is (x,y) in  [255:0] position 
	reg 	[7:0] tempy;			// use to calculate where is (x,y) in  [255:0] position 
	reg 	[4:0] tempr;			// use to save the random number
	//reg 	[2:0] spring[0:255];		// use to calculate the spring number of present generation
	reg 	[2:0] spring;		// use to calculate the spring number of present generation
	reg	[15:0] display_num;		
	reg 	[3:0] position_x;
	reg 	[3:0] position_y;
	reg	[15:0] position;	
	reg   [255:0] map;
									
	initial begin
		map = 256'b0;									// 地图一开始是空的 =w=
		freq = 32'd500_000;//_000;						// initialize frequency to be 500000000 times (between change of status)
		position_x = 4'b0000;						// position x 
		position_y = 4'b0000;						// position y
		position = 16'b0000_0000_0000_0000;		// position x, y (display use decimal)
	end
	
	always @(switch) begin							// control the frequency of clock through switch
		if (switch[0] == 0) begin					// 0 means slower
			case (switch[3:1])
				3'b000 : freq <= 32'd 500_000;//_000;
				3'b100 : freq <= 32'd1000_000;//_000;
				3'b010 : freq <= 32'd1500_000;//_000;
				3'b110 : freq <= 32'd2000_000;//_000;
				3'b001 : freq <= 32'd2500_000;//_000;
				3'b101 : freq <= 32'd3000_000;//_000;
				3'b011 : freq <= 32'd3500_000;//_000;
				3'b111 : freq <= 32'd4000_000;//_000;
			endcase
		end else begin									// 1 means faster
			case (switch[3:1])
				3'b000 : freq <= 32'd 500_000;//_000;
				3'b100 : freq <= 32'd 250_000;//_000;
				3'b010 : freq <= 32'd 133_333;//_333;
				3'b110 : freq <= 32'd 125_000;//_000;
				3'b001 : freq <= 32'd 100_000;//_000;
				3'b101 : freq <= 32'd  83_333;//_333;
				3'b011 : freq <= 32'd  71_428;//_571;
				3'b111 : freq <= 32'd  62_500;//_000;
			endcase
		end
	end
	
	pbdebounce p0(clk, btn_in[0], btn_out[0]);		// button debounce
	pbdebounce p1(clk, btn_in[1], btn_out[1]);
	pbdebounce p2(clk, btn_in[2], btn_out[2]);
	pbdebounce p3(clk, btn_in[3], btn_out[3]);
	pbdebounce p4(clk, btn_in[4], btn_out[4]);
	
	display m0(clk, display_num, anode[3:0], segment[7:0]);			//display position x, y
	
	counter_1s ct(clk, freq[31:0], clock);				// clock with different frequency
	
	assign led = clock;			
		
	always @* begin						
		display_num <= position;					
	end	
		
	always @(btn_out[0] or btn_out[1]) begin			// x + 1  or x - 1
		if (btn_out[0] & !btn_out[1])
			position_x <= position_x + 4'b1;				// btn[0]  => x + 1
		else if (!btn_out[0] & btn_out[1])
			position_x <= position_x - 4'b1;				// btn[1]  => x - 1
	end
	
	always @(btn_out[2] or btn_out[3]) begin			// y + 1  or y - 1
		if (btn_out[2] & !btn_out[3])
			position_y <= position_y + 4'b1;				// btn[2]  => y + 1
		else if (!btn_out[2] & btn_out[3])
			position_y <= position_y - 4'b1;				// btn[3]  => y - 1
	end

	always @(position_x) begin								// display x with decimal
		if (position_x < 4'b1010) begin
			position[7:4] <= position_x[3:0];
			position[3:0] <= 4'b0000;
		end else begin
			position[7:4] <= position_x[3:0] - 4'b1010;
			position[3:0] <= 4'b0001;
		end
	end
	
	always @(position_y) begin								// display y with decimal
		if (position_y < 4'b1010) begin
			position[15:12] <= position_y[3:0];
			position[11:8] <= 4'b0000;
		end else begin
			position[15:12] <= position_y[3:0] - 4'b1010;
			position[11:8] <= 4'b0001;
		end
	end
	
	always @(posedge btn_out[4]) begin					// change the status of position (x,y)
		tempx = position_x;
		tempy = position_y;
		map[tempy * 16 + tempx] = ~map[tempy * 16 + tempx];			// change to opposite status
	end
	
	generate														// use generate-for-loop to declare "random initialize" (more elegent)
		genvar i;
		for (i = 0; i < 255; i = i + 1 ) begin: random_map
			always @(posedge switch[4]) begin			// if turn up the switch[4]
				tempr = {$random} % 10;
				if (tempr < 4)									// 40% to be 1
					map[i] = 1;
				else 
					map[i] = 0;								// 60% to be 0 (random)
			end
		end
	endgenerate
	
	/*generate														// use generate-for-loop to calculate next status (more elegent)
		genvar k;
		for (k = 0; k < 255; k = k + 1 ) begin: spring_num
			always @(clock) begin
				if (clock == 0) begin
					spring[k] = 3'b000;
					spring[k] = spring[k] + map[k-1];
					spring[k] = spring[k] + map[k+1];
					spring[k] = spring[k] + map[k-15];
					spring[k] = spring[k] + map[k+15];
					spring[k] = spring[k] + map[k-16];
					spring[k] = spring[k] + map[k+16];
					spring[k] = spring[k] + map[k-17];
					spring[k] = spring[k] + map[k+17];
				end
			end
		end
	endgenerate*/
		
	generate															// use generate-for-loop to calculate next status (more elegent)
		genvar j;
		for (j = 0; j < 255; j = j + 1 ) begin: next_status
			always @(posedge clock) begin
				//spring = 3'b000 + map[j-1>=0?j-1:0] + map[j+1<255?j+1:0] 
				//			+ map[j-15>=0?j-15:j-15+256] + map[j+15<255?j+15:j+15-256] 
				//			+ map[j-16>=0?j-16:j-16+256] + map[j+16<255?j+16:j+16-256] 
				//			+ map[j-17>=0?j-17:j-17+256] + map[j+17<255?j+17:j+17-256];
				if (!switch[5]) begin							// switch[5] means stop/run
					if ((spring == 2 || spring == 3) && map[j] == 1)
						map[j] = 1;
					else if (spring == 3 && map[j] == 0)
						map[j] = 1;
					else 
						map[j] = 0;
				end
			end
		end
	endgenerate
	
endmodule
