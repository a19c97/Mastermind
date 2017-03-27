module slow_clock(reset_n, clock, slow_clock); 

	input clock;
	input reset_n;
	output reg slow_clock;
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
			if (q == (20'b11110100001001000000 - 1))
			//if (q == 3'd4)
				begin
				q <= 0;
				slow_clock <= 1'b1;
				end
			else
				begin
				q <= q + 1'b1;
				slow_clock <= 1'b0;
				end
		end
	end
endmodule



