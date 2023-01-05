// Pong Game - ball module
//
// Alden D'Souza
// Univesity of Bath
// December 2022
//


module ball
#(								// default values
	oLeft = 10,				// x position of the ball
	oTop = 10,				// y position of the ball
	oHeight = 20,			// height of the ball
	oWidth = 20,			// width of the ball
	screenWidth = 800,			// width of the screen
	screenHeight = 600,			// height of the screen
	xDirMove = 1,			// ball movement in x direction
	yDirMove = 1			// ball movement in y direction
)
(
	input pixelClock,					// slow clock to display pixels
	input Reset,						// reset position/movement of the ball
	input  logic [10:0] xPosition,		// x position of hCounter
	input  logic [ 9:0] yPosition,     // y position of vCounter
	
	input logic [10:0] leftPlaneR,
	input logic [10:0] rightPlaneR,
	input logic [10:0] bottomPlaneR,
	input logic [10:0] topPlaneR,
	input logic [10:0] leftPlaneL,
	input logic [10:0] rightPlaneL,
	input logic [10:0] bottomPlaneL,
	input logic [10:0] topPlaneL,
	
			                       
	output logic drawBall			// activates/deactivates drawing
);

	logic [10:0] leftBall;						
	logic [10:0] rightBall;						
	logic [10:0] topBall;
	logic [10:0] bottomBall;
	

	logic [10:0] ballX = oLeft;
	logic [10:0] ballY = oTop;

	logic xdir = xDirMove;
	logic ydir = yDirMove;	

		
	assign leftBall = ballX;						// left(x) position of the ball
	assign rightBall = ballX + oWidth;		   // right(x+width) position of the ball
	assign topBall = ballY;						// top(y) position of the ball
	assign bottomBall = ballY + oHeight;		// bottom(y+height) position of the ball

		
	always_ff @(posedge pixelClock)
	begin
		if( Reset == 1 )						// all values are initialised
		begin									// whenever the reset(SW[9]) is 1
			ballX <= oLeft;			
			ballY <= oTop;
			xdir <= xDirMove;
			ydir <= yDirMove;
		end
                 
		else
		
		begin
		ballX <= (xdir == 1) ? ballX + 1 : ballX - 1;	// changes movement of the ball in x direction
		ballY <= (ydir == 1) ? ballY + 1 : ballY - 1;	// changes movement of the ball in y direction
				
                
		if( topBall  <= 1 )                                //Sets a ceiling for ball movements
				ydir <= 1;
					
		if ( bottomBall >= screenHeight )
				ydir <= '0;
					
					
		if( leftBall <= 1 )                                 //Provides the user the function to score
					
		begin 
			xdir <= 1;
			ydir<= 1;
			ballX <= oLeft;
			ballY <= oTop;
		end
					
      if( rightBall >= screenWidth )
		begin
		   xdir <= '0;
			ydir<= '0;
		   ballX <= oLeft;
			ballY <= oTop;
		end
					
		// determines how the ball collides with the top right paddle
		if ((rightBall >= leftPlaneR) & (rightBall <= rightPlaneR)  & (bottomPlaneR > topBall) & (topPlaneR < bottomBall))
			ydir <= '0;
				
		// determines how the ball collides with the top left paddle
		if ((leftBall <= rightPlaneL) & (leftBall >= leftPlaneL) & ( topBall<bottomPlaneL ) & ( bottomBall > topPlaneL))
			ydir <= '0;
				
		// determines how the ball collides with the bottom right paddle
		if ( (rightBall >= leftPlaneR) & (rightBall <= rightPlaneR) & (topPlaneR < topBall) & (bottomPlaneR > topBall))
			ydir <= 1;
					
		// determines how the ball collides with the bottom left paddle			
		if ((leftBall <= rightPlaneL) & (leftBall >= leftPlaneL) & (bottomBall >= bottomPlaneL) & (topBall<= bottomPlaneL))
			ydir <= 1;		
					
		// determines how the ball collides with the right side paddle
		if ((bottomBall <= bottomPlaneR) & (topBall >= topPlaneR) &  (rightBall == leftPlaneR))
			xdir <= '0;
				
		// determines how the ball collides with the left side paddle
		if ((topBall >= topPlaneL) &  (leftBall == rightPlaneL) & (bottomBall <= bottomPlaneL))
			xdir <= 1;		
				 
		end
	end


	// drawBall is 1 if the screen counters (hCount and vCount) are in the area of the ball
	// otherwise, drawBall is 0 and the ball is not drawn.
	// drawBall is used by the top module PongGame
	assign drawBall = ((xPosition > leftBall) & (yPosition > topBall) & (xPosition < rightBall) & (yPosition < bottomBall) ) ? 1 : '0;

endmodule
