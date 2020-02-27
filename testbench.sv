module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic RST;
logic Train = 0;
logic [17:0] SW = 18'b000000010000000000;
//logic x_values = 1'b1;
logic [9:0] Draw_X, Draw_Y, H_Cont, V_Cont;	
logic [7:0] weights, del_w;
logic [31:0] Hw_out;
logic [15:0] Hex;
logic calc_Hw, xfull, resetH, Hw_p, upRule, classify, x_values;

always@(posedge Clk)
begin
	if(RST)
	begin
		H_Cont		<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < 800 )
		H_Cont	<=	H_Cont+1;
		else
		H_Cont	<=	0;
	end
end

always@(posedge Clk)
begin
	if(RST)
	begin
		V_Cont		<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < 525 )
			V_Cont	<=	V_Cont+1;
			else
			V_Cont	<=	0;
		end
	end
end

assign Draw_X = H_Cont - 144;
assign Draw_Y = V_Cont - 34;
	
Color_Mapper		map (.oVGA_R(10'd210),
							  .oVGA_B(10'd210),
							  .oVGA_G(10'd210),
							  .Draw_X,
							  .Draw_Y,
							  .VGA_Red(VGA_R),
							  .VGA_Blue(VGA_B),
							  .VGA_Green(VGA_G),
							  .x_values(x_values),
							  .Clk,
							  .RST,
							 .Get_done(xfull),
							 .RstH(resetH),
							 .Get(x_avail)
							 );

Hw						 hw(.x(x_values),
							 .w(weights),
							 .RST,
							 .Clk,
							 .Get(x_avail),
							 .ComputeH(calc_Hw),
							 .RstSum(resetH),
							 .Z(Hw_out));

Delta_W			  delw(.in(x_values),
							 .label(SW[17]),
							 .Hw(Hw_p),
							 .Clk,
							 .Record_X(calc_Hw),
							 .RST,
							 .Get(x_avail),
							 .Up_W(upRule),
							 .delta_w(del_w));							 

Weights				  w(.delta_w(del_w),
							 .Clk,
							 .ComputeH(calc_Hw),
							 .RST,
							 .Get(x_avail),
							 .Update(upRule),
							 .w_out(weights));

Classifier	   class0(.Z(Hw_out),
							 .Clk,
							 .RST,
							 .classify(classify),
							 .Hw(Hw_p),
							 .To_Hex(Hex)
							 );
							 
NeuralNetwork		 NN(.Clk,
							 .RST,
							 .Train,
							 .XFull(xfull),
							 .ComputeH(calc_Hw),
							 .New_frame(resetH),
							 //.RstH(resetH),
							 //.StoreX(storex),
							 .classify(classify),
							 .upRule(upRule));					 

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
	 RST = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
#2 RST = 1;

#2 RST = 0;

#2 Train = 1;

end
endmodule
