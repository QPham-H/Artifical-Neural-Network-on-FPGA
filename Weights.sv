module Weights(input [7:0] delta_w,
					input Clk, 
					input ComputeH, Get,
					input RST, 
					input Update,
					output [7:0] w_out);
						
logic [64007:0] Xout;
byte sum, w_out_int, delw_int, cap_sum;

assign w_out_int = w_out;
assign delw_int = delta_w;
assign w_out = Xout[7:0];

	always_comb
	begin
	if(w_out == 8'b01111111 && delta_w == 8'h01) // Max positive (127) + 1
		sum = 8'b01111111;
	else if(w_out == 8'b10000000 && delta_w == 8'hFF) // Max negative (-128) - 1
		sum = 8'b10000000;
	else
		sum = delw_int + w_out_int;
	end

	 always_ff @ (posedge Clk)
    begin
	 	 if (RST)
			Xout <= {8'd10, 63992'h0, 8'd5} ; // Initialized for debugging
		 else if (ComputeH && Get)
			Xout <= { w_out, Xout[64007:8]};
		 else if (Update)
			Xout <= {sum, Xout[64007:8] };
    end
	 
//byte leftmost_w; // debugging
//assign leftmost_w = Xout[64007:64000];	//debugging


endmodule