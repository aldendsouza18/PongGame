// 
// Pong Game - top module
//
// Alden D'Souza
// Univesity of Bath
// December 2022
//


module PongGame
(
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	
	output logic VGA_CLK,
	output logic VGA_BLANK_N,
	output logic VGA_SYNC_N,
	output logic VGA_HS,
	output logic VGA_VS,
	output logic [ 7:0] VGA_R,
	output logic [ 7:0] VGA_G,
	output logic [ 7:0] VGA_B
);

	assign VGA_CLK = ~CLOCK_50;


	logic [10:0] xPosition;			// current x position of hCount from the VGA controller
	logic [ 9:0] yPosition;			// current y position of vCount from tge VGA controller
	
	logic [10:0] leftPaddle;
	logic [10:0] rightPaddle;
	logic [10:0] topPaddle;
	logic [10:0] bottomPaddle;
	
	logic [10:0] leftPlaneL;
	logic [10:0] rightPlaneL;
	logic [10:0] topPlaneL;
	logic [10:0] bottomPlaneL;
	
	logic [10:0] leftPlaneR;
	logic [10:0] rightPlaneR;
	logic [10:0] topPlaneR;
	logic [10:0] bottomPlaneR;
	
	logic drawBall;
	
	
	// instantiation of the VGA controller
	VgaController vgaDisplay
	(
		.Clock(CLOCK_50),
		.Reset(SW[9]),
		.blank_n(VGA_BLANK_N),
		.sync_n(VGA_SYNC_N),
		.hSync_n(VGA_HS),
		.vSync_n(VGA_VS),
		.nextX(xPosition),
		.nextY(yPosition)
	);
	

	// instatiation of the slowClock module
	slowClock #(17) tick(CLOCK_50, SW[9], pix_stb);
	
	
	// instantiation of the ball module
	// oLeft and oTop define the x,y initial position of the object
	ball #(.oLeft(390), .oTop(290)) BallObj
	(
		.pixelClock(pix_stb),
		.Reset(SW[9]),
		.xPosition(xPosition),
		.yPosition(yPosition),
		.drawBall(drawBall),
		.topPlaneL(topPlaneL),
		.topPlaneR(topPlaneR),
		.bottomPlaneL(bottomPlaneL),
		.bottomPlaneR(bottomPlaneR),
		.leftPlaneL(leftPlaneL),
		.leftPlaneR(leftPlaneR),
		.rightPlaneL(rightPlaneL),
		.rightPlaneR(rightPlaneR)
	);
	
logic drawPaddle_L;
	
	
	// instantiation of the paddle module
	// paddleLeft and paddleTop define the x,y initial position of the object
	
	Paddle #(.paddleLeft(30), .paddleTop(225)) paddle_LObj
	(
		.pixelClock(pix_stb),
		.Reset(SW[9]),
		.downPaddle(~KEY[3]),
      .upPaddle(~KEY[2]),
		.yPosition(yPosition),
		.xPosition(xPosition),
		.drawPaddle(drawPaddle_L),
		.bottomPaddle(bottomPlaneL),
		.topPaddle(topPlaneL),
		.rightPaddle(rightPlaneL),
		.leftPaddle(leftPlaneL)
		
	);
	
	logic drawPaddle_R;
	
	
	
	// instantiation of the paddle module
	// paddleLeft and paddleTop define the x,y initial position of the object
	
	Paddle #(.paddleLeft(720), .paddleTop(225)) paddle_RObj
	(
		.pixelClock(pix_stb),
		.Reset(SW[9]),
		.downPaddle(~KEY[1]),
      .upPaddle(~KEY[0]),
		.yPosition(yPosition),
		.xPosition(xPosition),
		.drawPaddle(drawPaddle_R),
		.bottomPaddle(bottomPlaneR),
		.topPaddle(topPlaneR),
		.rightPaddle(rightPlaneR),
		.leftPaddle(leftPlaneR)
	);
	
	
	// instantiation of the divider module
	// dividerLeft and dividerTop define the x,y initial position of the object
	
	Divider #(.dividerLeft(300), .dividerTop(300)) DividerObj
	(
		.pixelClock(pix_stb),
		.Reset(SW[9]),
		.yPosition(yPosition),
		.xPosition(xPosition),
		.DrawDivider(DrawDivider),
		.bottomD(bottomD),
		.topD(topD),
		.rightD(rightD),
		.leftD(leftD)
	);
	
logic Divider;
	// this block is used to draw all the objects on the screen
	// you can add more objects and their corresponding colour
	
	
	always_comb
	begin
	if( drawBall )													//If ball module is true
	{VGA_R, VGA_G, VGA_B} = {8'hFF, 8'hFF, 8'hFF};
	
	else if( drawPaddle_R )														
		{VGA_R, VGA_G, VGA_B} = {8'hEF, 8'h2F, 8'h2F};	//red paddle defined
			
	else if ( drawPaddle_L ) 
		{VGA_R, VGA_G, VGA_B} = {8'h07, 8'h37, 8'hF7};  //blue paddle defined
			
	else if( DrawDivider )										//If ball module is still true
		{VGA_R, VGA_G, VGA_B} = {8'hFF, 8'hFF, 8'hFF};
			
	else
		{VGA_R, VGA_G, VGA_B} = {8'h00, 8'h00, 8'h00};	//draws a black background
	end
endmodule
