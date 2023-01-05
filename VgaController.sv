//Alden D'Souza
//University of Bath
//December 2022

module VgaController 

(
 input logic Clock,
 input logic Reset,
 output logic vSync_n,
 output logic hSync_n,
 output logic sync_n,
 output logic blank_n,
 output logic [9:0] nextY,
 output logic [10:0] nextX
 );
 
 logic [10:0] hCount;
 logic [9:0] vCount;
 
 always_ff@(posedge Clock, posedge Reset)
 begin
 
 if(Reset)
	begin
		hCount = 0;
		vCount = 0;
	end
 //counter for the whole screen
 else if (hCount > 1039)
	begin
		hCount = 0;
		vCount += 1;
	end
 
 else if (vCount > 665)
	vCount = 0;
 
 else
	hCount += 1;
 end
 
 //counter is displayed for the horizontal plane
 always_comb
	begin
		if (hCount < 800)
			nextX = hCount;
 
		else
 
			nextX = 0;
		
		//counterr is displayed for the vertical plane
		if (vCount < 600)
			nextY = vCount;
 
		else
			nextY = 0;
 
		if((hCount >= 800) || (vCount >= 600))
			blank_n = 0;
 
		else
			blank_n = 1;
		
		//synchronises the horizontal plane
		if((hCount >= 856) && (hCount < 976))
			hSync_n = 0;
 
		else
			hSync_n = 1;
 
		//synchronises the vertical plane
		if((vCount >= 637) && (hCount < 643))
			vSync_n = 0;
 
		else
			vSync_n = 1;
 
		if((hCount >= 856 && hCount < 976) || (vCount >= 637 && vCount < 643))
			sync_n = 0;
 
		else
			sync_n = 1;
 
	end 
 endmodule
 