module Paddle

#(
	paddleTop = 10,			//paddle position-x
   paddleLeft = 10,			//paddle position-y
	paddleWidth = 50,			//paddle width
	paddleHeight = 150,		//paddle height
	screenWidth = 800,		//screen width
	screenHeight = 600	   //screen height
	)
	
	(
	input pixelClock,						//clock to input display pixels
	input Reset,
	input logic upPaddle,
	input logic downPaddle,			//resets the position of the paddle
	input logic [9:0] yPosition,	//y position - [10 bits]
	input logic [10:0] xPosition,	//x position - [11 bits]
	
	output logic [10:0] topPaddle,
	output logic [10:0] bottomPaddle,
	output logic [10:0] leftPaddle,						
	output logic [10:0] rightPaddle,		

	output logic drawPaddle			//outputs the paddle	
	
);
	
	logic [10:0] top;
	logic [10:0] bottom;
	logic [10:0] left;
	logic [10:0] right;
	
	logic [10:0] yPaddle = paddleTop;
	logic [10:0] xPaddle = paddleLeft;
	

	assign top = yPaddle;							//paddle position top(y)
	assign left = xPaddle;							//paddle position top(x)
	assign right= xPaddle + paddleWidth;		//paddle position right(x+width)
	assign bottom = yPaddle + paddleHeight;	//paddle position bottom(y+height)

	always_ff @(posedge pixelClock)
	begin
	if( Reset == 1 )	
   begin                           		//values are initialised						         
		xPaddle <= paddleLeft;				
		yPaddle <= paddleTop;
	end			
	else
   begin				  							//changes the movement along the y-axis
	
	if ((yPaddle > '0) && (upPaddle == 1))
		yPaddle <= yPaddle - 1 ;
				
	else if ((yPaddle <= 449) && (downPaddle == 1))	
		yPaddle <= yPaddle + 1;
		    
	else 
		yPaddle <= yPaddle;

	end
	
	topPaddle <= top;
	bottomPaddle <= bottom;
	leftPaddle <= left;
	rightPaddle <= right;
	
	end

	// drawpaddle_L/R	is 1 if the screen counters (hCount and vCount) are in the area of the paddles
	// otherwise, drawpaddle_L/R is 0 or Ball is drawn.
	// drawpaddle_L/R is used by the top module PongGame
	assign drawPaddle = ((xPosition > leftPaddle) & (xPosition < rightPaddle) & (yPosition > topPaddle) & (yPosition < bottomPaddle)) ? 1 : '0;


endmodule
	
	