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
    wire load_code_1, load_code_2, load_code_3, load_code_4, 
    load_guess_1, load_guess_2, load_guess_3, load_guess_4;
    
    mastermind_control(
    	.clk(CLOCK_50),
    	.resetn(resetn),
    	.load(load),	
    	.data_in(SW[2:0])
    	
    	.load_code_1(load_code_1),
    	.load_code_2(load_code_2),
    	.load_code_3(load_code_3),
    	.load_code_4(load_code_4),
    	.load_guess_1(load_guess_1),
    	.load_guess_2(load_guess_2),
    	.load_guess_3(load_guess_3),
    	.load_guess_4(load_guess_4)
    );
endmodule


module mastermind_control(
	input clk,
	input resetn,
	input load,
	input [2:0] data_in,
	
	output compare, 
	output load_code_1, load_code_2, load_code_3, load_code_4,
	output load_guess_1, load_guess_2, load_guess_3, load_guess_4;
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
    	load_code_1 = 1'b0;
    	load_code_2 = 1'b0;
    	load_code_3 = 1'b0;
    	load_code_4 = 1'b0;
 		load_guess_1 = 1'b0;
 		load_guess_2 = 1'b0;
 		load_guess_3 = 1'b0;
 		load_guess_4 = 1'b0;
 		compare = 1'b0;
    	case (current_state)
    		LOAD_CODE_1: begin
    			load_code_1 = 1'b1;
    		end
    		LOAD_CODE_2: begin
    			load_code_2 = 1'b1;
    		end
    		LOAD_CODE_3: begin
    			load_code_3 = 1'b1;
    		end
    		LOAD_CODE_4: begin
    			load_code_4 = 1'b1;
    		end
    		LOAD_GUESS_1: begin
    			load_guess_1 = 1'b1;
    		end
    		LOAD_GUESS_2: begin
    			load_guess_2 = 1'b1;
    		end
    		LOAD_GUESS_3: begin
    			load_guess_3 = 1'b1;
    		end
    		LOAD_GUESS_4: begin
    			load_guess_4 = 1'b1;
    		end
    		
    		
    	endcase
    end


endmodule


module mastermind_datapath(
	input clk,
	input resetn,
	input [2:0] data_in,
	input load_code_1, load_code_2, load_code_3, load_code_4,
	input load_guess_1, load_guess_2, load_guess_3, load_guess_4;
);
endmodule

