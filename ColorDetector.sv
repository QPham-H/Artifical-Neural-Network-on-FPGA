module ColorDetector( input  [7:0] oVGA_R, oVGA_B, oVGA_G,
										     Draw_X, Draw_Y,
							 input 		  Clk, RST,
							 output		  MoveSignal);
										  
	
    logic box_on, inside_box;
    logic [7:0] Red, Green, Blue;
	 
	 int vga_R_int, vga_B_int, vga_G_int, average_color;
	 assign vga_R_int = oVGA_R;
	 assign vga_B_int = oVGA_B;
	 assign vga_G_int = oVGA_G;
	 

    // Compute whether the pixel is within the box
    always_comb
    begin : can_draw_box
		  if ( (Draw_X >= 10'd266 && Draw_X <= 10'd270 && Draw_Y >= 10'd156 && Draw_Y <= 10'd324) || 
				 (Draw_X >= 10'd370 && Draw_X <= 10'd374 && Draw_Y >= 10'd156 && Draw_Y <= 10'd324) || 
				 (Draw_Y >= 10'd156 && Draw_Y <= 10'd160 && Draw_X <= 10'd374 && Draw_X >= 10'd266) || 
				 (Draw_Y >= 10'd320 && Draw_Y <= 10'd324 && Draw_X <= 10'd374 && Draw_X >= 10'd266) )
				box_on = 1'b1;
		  else 
            box_on = 1'b0;
    end
	 

	logic x_values_in;
	assign x_values = x_values_in;
	 
	 always_comb
    begin : inside_box
		inside_box = 1'b0;
		if ( Draw_X>= 10'd270 && Draw_X < 10'd370 && Draw_Y >= 10'd160 && Draw_Y < 10'd320 ) 
			inside_box = 1'b1;
    end


    // Draw the box and compute the black and white image processing
    always_comb
    begin : RGB_Display
	 x_values_in = 1'b1;
	 Red = oVGA_R; 
    Green = oVGA_G;
    Blue = oVGA_B;
        if ((box_on == 1'b1)) 
        begin
            // Green box
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
        end
	 end

int runningSum, current, counter, counter_in, average;

	 always_ff @ (posedge Clk)
    begin
		if(RST)
			runningSum <= 32'd0;
		else if (inside_box == 1'b1)
			runningSum <= current;
    end
	
	always_comb
	begin
		current = runningSum + Red;
		if Draw_X == // (New coordinate for 3Mp camera) && Draw_Y == ...
			average = runningSum / //Pixel number
			if (average < threshold?)
				MoveSignal = 1'b0;
			else 
				MoveSignal = 1'b1;
		
	 
endmodule
