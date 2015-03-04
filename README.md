# Game of Life in Verilog
======

Game of Life

Use the seven-segment digital tubes on the Spartan-6 platform to represent the postion x, y of present grid (in decimal form 0-15). 

<br>


Use BTN buttons on the Spartan-6 platform to input UP, DOWN, LEFT, RIGHT or CHANGE command. There are five bottons: 
* botton above means present position go up; 

* botton below means present position go down; 

* botton on the left means present position go left; 

* botton on the right means present position go right; 

* botton in the central means change status of present grid.


<br>


Use SWITCHes on the Spartan-6 platform to control game mode and frequency. There are eight switches, from left to right: 

* 1 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		game mode:	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;	1: stop / 0: run 

* 2   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		frequency control:	&nbsp;&nbsp;&nbsp; 	1: faster / 0: slower 

* 3-5 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;		speed: 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;			3 bits binary, from 0 to 8   &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;(whether faster or slower depends on switch 2) 

* 6 && !7 &nbsp;	if in “stop” mode: 	&nbsp;&nbsp;&nbsp;&nbsp;	initialize to "Glider" 

* !6 && 7 &nbsp;	if in “stop” mode: 	&nbsp;&nbsp;&nbsp;&nbsp;	initialize to "Lightweight Spaceship" 

* 6 && 7 	&nbsp;&nbsp;	if in “stop”mode: 	&nbsp;&nbsp;&nbsp;&nbsp;	initialize to "Pulsar" 

* 8		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	if in “stop” mode: 	&nbsp;&nbsp;&nbsp;&nbsp;	initialize randomly


