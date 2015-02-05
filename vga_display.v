`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:30:40 02/04/2015 
// Design Name: 
// Module Name:    display 
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
module vga_display(
	input [255:0] map,
	input [3:0] x_cursor,
	input [3:0] y_cursor,
	input inside_video,
	input [9:0] x_position,
	input [8:0] y_position,
	output [2:0] vgaRed,
	output [2:0] vgaGreen,
	output [1:0] vgaBlue);
	
	parameter max_radius = 8;
	parameter min_radius = 2;
	reg [2:0] red;
	reg [2:0] green;
	reg [2:0] blue;
	reg [3:0] x_index;
	reg [3:0] y_index;
	reg [7:0] pos;
	reg [9:0] central_x;
	reg [8:0] central_y;
	reg [4:0] radius = max_radius;
	reg [9:0] cursor_x;
	reg [8:0] cursor_y;
	
	always @(*) begin
		if (inside_video) begin
			// if in the central area
			if ((x_position >= 104) && (x_position < 536) && (y_position >= 24) && (y_position < 456)) begin
				
				// find the position the pixel correspond to the map
				x_index = (x_position - 104) / 27;
				y_index = (y_position -  24) / 27;
				
				// convert the two dimensional index down to one
				pos = y_index * 16 + x_index;
				
				// find the center of the pixel's life
				central_x = x_index * 27 + 118;
				central_y = y_index * 27 + 38;
				
				// if the life if dead
				if (map[pos] == 0) begin
					// print a small grey circle using pythagoras theorem
					if	((central_x - x_position) * (central_x - x_position) +
						(central_y - y_position) * (central_y - y_position) <= min_radius * min_radius) begin
						red = 3'b100;
						green = 3'b100;
						blue = 2'b10;
					end else begin
						red = 3'b111;
						green = 3'b111;
						blue = 2'b11;
					end
				end else begin
					// print a colored circle using pythagoras theorem
					if	((central_x - x_position) * (central_x - x_position) +
						(central_y - y_position) * (central_y - y_position) < radius * radius) begin
						red = x_index * 3 / 8;
						green = y_index *3 / 8;
						blue = (radius - min_radius + 1) / 2;
					end else begin
						red = 3'b111;
						green = 3'b111;
						blue = 2'b11;
					end
				end
			end else begin
				if ((x_position >= 90) && (x_position < 550) && (y_position >= 10) && (y_position < 470)) begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end else begin
					red = 3'b110;
					green = 3'b110;
					blue = 2'b11;
				end
			end
			
			cursor_x = x_cursor * 27 + 118;
			cursor_y = y_cursor * 27 + 38;
			if	(((cursor_x - x_position) * (cursor_x - x_position) +
				(cursor_y - y_position) * (cursor_y - y_position) < 13 * 13) &&
				((cursor_x - x_position) * (cursor_x - x_position) +
				(cursor_y - y_position) * (cursor_y - y_position) >= 11 * 11)) begin
				red = 3'b010;
				green = 3'b010;
				blue = 3'b10;
			end
		end else begin
			red = 3'b0;
			green = 3'b0;
			blue = 3'b0;
		end
	end
	
	assign vgaRed = red;
	assign vgaGreen = green;
	assign vgaBlue = blue;

endmodule
