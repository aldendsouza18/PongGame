module Divider

#(										//default values
	dividerTop = 10,				//divider position-y
	dividerLeft = 10,				//divider position-x
	dividerWidth = 10,			//divider width
	dividerHeight = 900,			//divider height
	screenWidth = 800,			//screen width
	screenHeight = 600  			//screen height
)
(
	input pixelClock,							//clock to input display pixels
	input Reset,								//resets the position of the divider
	input logic [9:0] yPosition,		//position-y - [10 bits]
	input logic [10:0] xPosition,		//position-x - [11 bits]
	input logic [10:0] topD,
	input logic [10:0] bottomD,
	input logic [10:0] leftD, 
	input logic [10:0] rightD,
	
	
	output logic DrawDivider				//output variable which draws the divider	
);	

	logic [10:0] top;
	logic [10:0] bottom;
   	logic [10:0] left;
	logic [10:0] right;
	
	assign left = dividerLeft;							//paddle position left(x)
	assign top = dividerTop;							//paddle position top(y)
	assign right = dividerLeft+ dividerWidth;		//paddle position right(x+width) 
	assign bottom = dividerTop + dividerHeight;	//paddle position bottom(y+height)

   assign DrawDivider = ((xPosition > leftD) & (xPosition < rightD) & (yPosition > topD) & (yPosition < bottomD)) ? 1 : 0;

endmodule
