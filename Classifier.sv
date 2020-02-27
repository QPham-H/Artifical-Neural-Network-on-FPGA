module Classifier (input int Z,
						input  Clk, classify, RST,
						output Hw,
						output [15:0] To_Hex
						);

logic Hw_in, Hw_in_in;
logic [15:0] FACE, FACE_in;	
byte counter, counter_in, avg_sum, avg, avg_sum_in;

assign Hw = Hw_in;	
assign To_Hex = FACE;

always_ff @ (posedge Clk)
begin
	if (RST)
		begin
		counter <= 41;
		Hw_in <= 1'b0;
		FACE <= 16'd0;
		avg_sum <= 0;
		end
	else
		begin
		counter <= counter_in;
		Hw_in <= Hw_in_in;
		FACE <= FACE_in;
		avg_sum <= avg_sum_in;
		end
end

always_comb
begin
	Hw_in_in = Hw_in;
	FACE_in = FACE;
	counter_in = counter;
	avg_sum_in = avg_sum;
	if(classify)
	begin
		counter_in = counter - 1;
		avg_sum_in = avg_sum + Hw_in;
		if(counter == 0)
		begin
			counter_in = 41;
			avg_sum_in = 0;
			if(avg_sum <= 20)
				FACE_in = 16'd0;
			else
				FACE_in = 16'hFACE;
		end
		if(Z<=0)
			Hw_in_in = 0;
		else
			Hw_in_in = 1;
	end
end

endmodule
