# game-of-life-in-verilog

Game of Life!

There are eight switches, from left to right:
1 			game mode:	1:stop / 0:run
2 			frequency control:	1:faster / 0:slower
3-5 		speed:   3 bits binary, from 0 to 8, whether faster or slower depends on switch 2 
6  && !7	if in stop mode:  initialize to "Glider"
!6 &&  7	if in stop mode:  initialize to "Lightweight Spaceship"
6  &&  7 	if in stop mode:  initialize to "Pulsar"
8			if in stop mode:  initialize randomly

There are five bottons:
botton above means present position go up;
botton below means present position go down;
botton on the left means present position go left;
botton on the right means present position go right;
botton in the central means change status of present position 

There are a display, which display the position of x, y both in decimal. (from 0 - 15)