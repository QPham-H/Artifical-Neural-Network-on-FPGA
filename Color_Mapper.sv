module Color_Mapper ( input  [9:0] oVGA_R, oVGA_B, oVGA_G,
										     Draw_X, Draw_Y,
							 input 		  Clk, RST,
							 output [7:0] VGA_Red, VGA_Blue, VGA_Green,
							 output 		  Get_done, RstH, Get,
							 output		  x_values);
										  
	
    logic box_on, inside_box;
    logic [7:0] Red, Green, Blue, bw_R, bw_G, bw_B;
	 logic Get_done_in, RstH_in, Get_in, Xs_out_in;
	 
	 int vga_R_int, vga_B_int, vga_G_int, average_color;
	 assign vga_R_int = oVGA_R;
	 assign vga_B_int = oVGA_B;
	 assign vga_G_int = oVGA_G;
	 
	 assign average_color = (vga_R_int + vga_B_int + vga_G_int)/3;
    
    assign VGA_Red = Red;
    assign VGA_Green = Green;
    assign VGA_Blue = Blue;
    
	assign Get = Get_in;
	assign Get_done = Get_done_in;
	assign RstH = RstH_in;

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
    begin : black_and_white_inside
		Get_in = 1'b0;
		Get_done_in = 1'b0;
		RstH_in = 1'b0;
		inside_box = 1'b0;
		if(Draw_X == 10'd268 && Draw_Y == 10'd160)
			RstH_in = 1'b1;
		if(Draw_X == 10'd269 && Draw_Y == 10'd160)
			begin
			Get_in = 1'b1;
			end	
		else if ( Draw_X>= 10'd270 && Draw_X < 10'd370 && Draw_Y >= 10'd160 && Draw_Y < 10'd320 ) 
			begin
			inside_box = 1'b1;
			if( (Draw_X + Draw_Y)%2 == 0 )
				Get_in = 1'b1;
			end
		else if( Draw_X == 10'd370 && Draw_Y == 10'd319)
			begin
			Get_done_in = 1'b1;
			end
    end


    // Draw the box and compute the black and white image processing
    always_comb
    begin : RGB_Display
	 x_values_in = 1'b1;
	 Red = oVGA_R[9:2]; 
    Green = oVGA_G[9:2];
    Blue = oVGA_B[9:2];
        if ((box_on == 1'b1)) 
        begin
            // Green box
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
        end
        else if (inside_box == 1'b1)
		  begin
				if(average_color <= 128) //Threshold
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
					x_values_in = 1'b0;
				end
				else
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
					x_values_in = 1'b1;
				end
		  end
	 end

endmodule
