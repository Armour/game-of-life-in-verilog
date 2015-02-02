`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:36 01/12/2015 
// Design Name: 
// Module Name:    test 
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
module test( input wire clk, 
				input wire [3:0] switch, 
				input wire [3:0] btn_in,			
				output wire [3:0] anode, 	
				output wire [7:0] segment,
				output wire led);
				
	wire	clock;					// 可控速的clock	
	wire	[3:0] btn_out;		
	reg	[31:0] freq;			// frequency
	reg	[15:0] position;	
	reg	[15:0] display_num;		
									
	initial begin
		freq = 32'd500_000_000;						// clock频率:50000000次改变
		position = 16'b0000_0000_0000_0000;		// 当前坐标 X Y 暂定[0-23, 0-31]
	end
	
	always @(switch) begin							// 通过开关控制clock频率
		if (switch[0] == 0) begin					// 0表示减速
			case (switch[3:1])
				3'b000 : freq <= 32'd 500_000_000;
				3'b100 : freq <= 32'd1000_000_000;
				3'b010 : freq <= 32'd1500_000_000;
				3'b110 : freq <= 32'd2000_000_000;
				3'b001 : freq <= 32'd2500_000_000;
				3'b101 : freq <= 32'd3000_000_000;
				3'b011 : freq <= 32'd3500_000_000;
				3'b111 : freq <= 32'd4000_000_000;
			endcase
		end else begin									// 1表示加速
			case (switch[3:1])
				3'b000 : freq <= 32'd 500_000_000;
				3'b100 : freq <= 32'd 250_000_000;
				3'b010 : freq <= 32'd 133_333_333;
				3'b110 : freq <= 32'd 125_000_000;
				3'b001 : freq <= 32'd 100_000_000;
				3'b101 : freq <= 32'd  83_333_333;
				3'b011 : freq <= 32'd  71_428_571;
				3'b111 : freq <= 32'd  62_500_000;
			endcase
		end
	end
	
	pbdebounce p0(clk, btn_in[0], btn_out[0]);			//去抖程序
	pbdebounce p1(clk, btn_in[1], btn_out[1]);
	pbdebounce p2(clk, btn_in[2], btn_out[2]);
	pbdebounce p3(clk, btn_in[3], btn_out[3]);
	display m0(clk, display_num, anode[3:0], segment[7:0]);					//16位显示坐标
	counter_1s ct(clk, freq[31:0], clock);											//计时器

	always @(posedge btn_out[0]) position[ 3: 0]  <= position[ 3: 0]  + 4'd1;			//op1的第1个数字+1
	always @(posedge btn_out[1]) position[ 7: 4]  <= position[ 7: 4]  + 4'd1;			//op1的第2个数字+1
	always @(posedge btn_out[2]) position[ 11: 8] <= position[11: 8]  + 4'd1;			//op1的第3个数字+1
	always @(posedge btn_out[3]) position[ 15: 12]<= position[15: 12] + 4'd1;			//op1的第4个数字+1
	
	assign led = clock;
	
	always @* begin
		display_num <= position;
	end
		
	/*
	always @(posedge btn_out[0]) begin			// x + 1
		position[7:4] <= position[7:4] + 4'b1;
		if (position[7:4] == 4'b1010) begin
			position[7:4] <= 4'b0;
			position[3:0] <= position[3:0] + 4'b1;
		end else
		if (position[7:4] == 4'b0100 && position[3:0] == 4'b0010) begin
			position[7:4] <= 4'b0;
			position[3:0] <= 4'b0;
		end
	end
	
	always @(posedge btn_out[1]) begin			 // x - 1
		position[7:4] <= position[7:4] - 4'b1;
		if (position[7:4] == 4'b1111 && position[3:0] != 4'b0) begin
			position[7:4] <= 4'b1001;
			position[3:0] <= position[3:0] - 4'b1;
		end else
		if (position[7:4] == 4'b1111 && position[3:0] == 4'b0) begin
			position[7:4] <= 4'b0011;
			position[3:0] <= 4'b0010;
		end
	end 
	
	always @(posedge btn_out[2]) begin			// y + 1
		position[15:12] <= position[15:12] + 4'b1;
		if (position[15:12] == 4'b1010) begin
			position[15:12] <= 4'b0;
			position[11:8] <= position[11:8] + 4'b1;
		end else
		if (position[15:12] == 4'b0010 && position[11:8] == 4'b0011) begin
			position[15:12] <= 4'b0;
			position[11:8] <= 4'b0;
		end
	end
	
	always @(posedge btn_out[3]) begin			// y - 1
		position[15:12] <= position[15:12] - 4'b1;
		if (position[15:12] == 4'b1111 && position[11:8] != 4'b0) begin
			position[15:12] <= 4'b0;
			position[11:8] <= position[11:8] - 4'b1;
		end else
		if (position[15:12] == 4'b1111 && position[11:8] == 4'b0) begin
			position[15:12] <= 4'b1;
			position[11:8] <= 4'b0011;
		end
	end
	*/
	
endmodule
