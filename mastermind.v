module mastermind_top(
	SW, KEY, CLOCK_50, HEX3, HEX2, HEX1, HEX0
);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output HEX3, HEX2, HEX1, HEX0;
    
    wire load, resetn;
    assign resetn = KEY[1];
    assign load = KEY[0];
    
    wire [11:0] code, guess;
    
    mastermind_control(
    	.clk(CLOCK_50),
    	.resetn(resetn),
    	.load(load)	
    );
endmodule

module mastermind_control(
	input clk,
	input resetn,
	input load,
	
	output compare, load_code, load_guess;
);
	
	reg [7:0] current_state, next_state;
	
	localparam
	LOAD_CODE_1 = 8'd0,
	LOAD_CODE_1_WAIT = 8'd1,
	LOAD_CODE_2 = 8'd2,
	LOAD_CODE_2_WAIT = 8'd3,
	LOAD_CODE_3 = 8'd4,
	LOAD_CODE_3_WAIT = 8'd5,
	LOAD_CODE_4 = 8'd6,
	LOAD_CODE_4_WAIT = 8'd7,
	GUESS_1 = 8'd8,
	GUESS_1_WAIT = 8'd9,
	GUESS_2 = 8'd10,
	GUESS_2_WAIT = 8'd11,
	GUESS_3 = 8'd12,
	GUESS_3_WAIT = 8'd13,
	GUESS_4 = 8'd14,
	GUESS_4_WAIT = 8'd15,
	RESULT = 8'd16;
	
	always@(*)
    begin: state_table 
        case (current_state)
        	LOAD_CODE_1: next_state = load ? LOAD_CODE_1_WAIT : LOAD_CODE_1;
        	LOAD_CODE_1_WAIT: next_state = load ? LOAD_CODE_1_WAIT : LOAD_CODE_2;
        	LOAD_CODE_2: next_state = load ? LOAD_CODE_2_WAIT : LOAD_CODE_2;
        	LOAD_CODE_2_WAIT: next_state = load ? LOAD_CODE_2_WAIT : LOAD_CODE_3;
        	LOAD_CODE_3: next_state = load ? LOAD_CODE_3_WAIT : LOAD_CODE_3;
        	LOAD_CODE_3_WAIT: next_state = load ? LOAD_CODE_3_WAIT : LOAD_CODE_4;
        	LOAD_CODE_4: next_state = load ? LOAD_CODE_4_WAIT : LOAD_CODE_4;
        	LOAD_CODE_4_WAIT: next_state = load ? LOAD_CODE_4_WAIT : GUESS_1;
        	GUESS_1: next_state = load ? GUESS_1_WAIT : GUESS_1;
        	GUESS_1_WAIT: next_state = load ? GUESS_1_WAIT : GUESS_2;
        	GUESS_2: next_state = load ? GUESS_2_WAIT : GUESS_2;
        	GUESS_2_WAIT: next_state = load ? GUESS_2_WAIT : GUESS_3;
        	GUESS_3: next_state = load ? GUESS_3_WAIT : GUESS_3;
        	GUESS_3_WAIT: next_state = load ? GUESS_3_WAIT : GUESS_4;
        	GUESS_4: next_state = load ? GUESS_4_WAIT : GUESS_3;
        	GUESS_4_WAIT: next_state = load ? GUESS_4_WAIT : RESULT;
        	RESULT: next_state = resetn ? LOAD_CODE_1 : RESULT;
    	endcase
    end
    
    always @(*)
    begin: enable_signals
    	// initialize everything to zero
    	case (current_state)
    		LOAD_CODE_1: begin
    		end
    	endcase
    end

endmodule

