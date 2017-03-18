module mastermind_top(
	SW, KEY, CLOCK_50
);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    
    wire load, resetn;
    assign resetn = KEY[1];
    assign load = KEY[0];
endmodule

module mastermind_control(
	input clk,
	input resetn,
	input load
);
	
	reg [7:0] current_state, next_state
	

endmodule

