module control(
	input clk,
	input resetn,
	input load,
	
	output reg compare, 
	output reg load_code_1, load_code_2, load_code_3, load_code_4,
	output reg load_guess_1, load_guess_2, load_guess_3, load_guess_4,
	output reg [1:0] compare_i,
	output reg reach_result_4
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
        RESULT_0 = 8'd16,
        RESULT_1 = 8'd17,
        RESULT_2 = 8'd18,
        RESULT_3 = 8'd19,
        RESULT_4 = 8'd20;
        
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
        	GUESS_4_WAIT: next_state = load ? GUESS_4_WAIT : RESULT_0;
        	RESULT_0: next_state = RESULT_1;
			RESULT_1: next_state = RESULT_2;
			RESULT_2: next_state = RESULT_3;
			RESULT_3: next_state = RESULT_4;
			RESULT_4: next_state = GUESS_1;
        default: next_state = LOAD_CODE_1;
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
		compare_i = 2'd0;
		reach_result_4 = 1'b0;
		
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
    		GUESS_1: begin
    			load_guess_1 = 1'b1;
    		end
    		GUESS_2: begin
    			load_guess_2 = 1'b1;
    		end
    		GUESS_3: begin
    			load_guess_3 = 1'b1;
    		end
    		GUESS_4: begin
    			load_guess_4 = 1'b1;
    		end
    		RESULT_0: begin
    			compare = 1'b1;
				compare_i = 2'd0;
    		end
			RESULT_1: begin
    			compare = 1'b1;
				compare_i = 2'd1;
    		end
			RESULT_2: begin
    			compare = 1'b1;
				compare_i = 2'd2;
    		end
    		RESULT_3: begin
    			compare = 1'b1;
				compare_i = 2'd3;
    		end
			RESULT_4: begin
    			compare = 1'b0;
				compare_i = 2'd0;
				reach_result_4 = 1'b1;
    		end
    	endcase
    end
    
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= LOAD_CODE_1;
        else
            current_state <= next_state;
    end 

endmodule
