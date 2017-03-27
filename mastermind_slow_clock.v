module rate_divider(reset_n, clock, slow_clock); 

	input clock;
	input reset_n;
	output reg slowclock;
	reg [27:0] q;
	
	always @(posedge clock)
	begin 
		if (!reset_n)
		begin
			q <= 0;
			slow_clock <= 1'b0;
		end
		else
		begin
			//if (q == (20'b11110100001001000000 - 1))
			if (q == 3'b4)
				begin
				q <= 0;
				slow_clock <= 1'b1;
				end
			else
				q <= q + 1'b1;
		end
	end
endmodule



