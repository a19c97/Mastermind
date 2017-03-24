module mastermind(
	SW, KEY, CLOCK_50, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    
    wire load, resetn;
    assign resetn = KEY[1];
    assign load = ~KEY[0];
    
    wire [11:0] code, guess;
    wire [2:0] red_out, white_out;
    wire load_code_1, load_code_2, load_code_3, load_code_4, 
         load_guess_1, load_guess_2, load_guess_3, load_guess_4;
    wire compare;
    wire [1:0] compare_i;
    wire reach_result_4, reset_red_white;
    //wire [2:0] guess_counter;
	wire [2:0] curr_code;
    
    mastermind_control ctrl(
    	.clk(CLOCK_50),
    	.resetn(resetn),
    	.load(load),	
    	.compare(compare),
		.compare_i(compare_i),
		.reach_result_4(reach_result_4),
		.reset_red_white(reset_red_white),
    	.load_code_1(load_code_1),
    	.load_code_2(load_code_2),
    	.load_code_3(load_code_3),
    	.load_code_4(load_code_4),
    	.load_guess_1(load_guess_1),
    	.load_guess_2(load_guess_2),
    	.load_guess_3(load_guess_3),
    	.load_guess_4(load_guess_4)
    );
    
    mastermind_datapath data(
    	.clk(CLOCK_50),
    	.resetn(resetn),
    	.data_in(SW[2:0]),
    	.load_code_1(load_code_1),
    	.load_code_2(load_code_2),
    	.load_code_3(load_code_3),
    	.load_code_4(load_code_4),
    	.load_guess_1(load_guess_1),
    	.load_guess_2(load_guess_2),
    	.load_guess_3(load_guess_3),
    	.load_guess_4(load_guess_4),
		.compare_i(compare_i),
		.compare(compare),
		.reach_result_4(reach_result_4),
		.reset_red_white(reset_red_white),
    	.code(code),
    	.guess(guess),
    	.red_out(red_out),
    	.white_out(white_out),
		//.guess_counter(guess_counter),
		.curr_code(curr_code)
    );
    
    hex_decoder H0(
        .hex_digit({1'b0, code[2:0]}), 
        .segments(HEX0)
    );
    
    hex_decoder H1(
        .hex_digit({1'b0, code[5:3]}), 
        .segments(HEX1)
    );
    
    hex_decoder H2(
        .hex_digit({1'b0, code[8:6]}), 
        .segments(HEX2)
    );
    
    hex_decoder H3(
        .hex_digit({1'b0, code[11:9]}), 
        .segments(HEX3)
    );
    
    hex_decoder H4(
        .hex_digit({1'b0, red_out}), 
        .segments(HEX4)
    );
    
    hex_decoder H5(
        .hex_digit({1'b0, white_out}), 
        .segments(HEX5)
    );
    
endmodule


module mastermind_control(
	input clk,
	input resetn,
	input load,
	
	output reg compare, 
	output reg load_code_1, load_code_2, load_code_3, load_code_4,
	output reg load_guess_1, load_guess_2, load_guess_3, load_guess_4,
	output reg [1:0] compare_i,
	output reg reach_result_4, reset_red_white
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
        RESULT_0_again = 8'd17,
        RESULT_1 = 8'd18,
        RESULT_1_again = 8'd19,
        RESULT_2 = 8'd20,
		RESULT_2_again = 8'd21,
		RESULT_3 = 8'd22,
		RESULT_3_again = 8'd23,
		RESULT_4 = 8'd24,
		RESULT_4_again = 8'd25;
        
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
		reset_red_white = 1'b0;
		
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
				reset_red_white = 1'b1;
    		end
    		GUESS_3: begin
    			load_guess_3 = 1'b1;
    		end
    		GUESS_4: begin
    			load_guess_4 = 1'b1;
				compare_i = 2'd0;
    		end
    		RESULT_0: begin
				compare = 1'b1;
				compare_i = 2'd0;
    		end
			RESULT_0_again: begin
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
        if (!resetn)
            current_state <= LOAD_CODE_1;
        else
            current_state <= next_state;
    end 

endmodule


module mastermind_datapath(
	input clk,
	input resetn,
	input [2:0] data_in,
	input load_code_1, load_code_2, load_code_3, load_code_4,
	input load_guess_1, load_guess_2, load_guess_3, load_guess_4,
	input [1:0] compare_i,
	input compare, reach_result_4, reset_red_white,
	
	output reg [11:0] code, guess,
	output reg [2:0] red_out, white_out,
	//output reg [2:0] guess_counter,
	output reg [2:0] curr_code
);
	
	wire [2:0] red, white; // number of red and white pegs in feedback
	//reg [2:0] guess_counter; // counter to count up to 8 guesses
	
	// loading inputs
	always @ (posedge clk) begin
        if (!resetn) begin
			code <= 12'd0;
			guess <= 12'd0;
        end
        else begin
		    if (load_code_1) begin
		        code[2:0] <= data_in;
			end   
			if (load_code_2) begin
		        code[5:3] <= data_in;
			end  
			if (load_code_3) begin
		        code[8:6] <= data_in;
			end  
			if (load_code_4) begin
		        code[11:9] <= data_in;
			end   
			if (load_guess_1) begin
				guess[2:0] <= data_in;
				//red_out <= 3'd0;
				//white_out <= 3'd0;
			end
			if (load_guess_2) begin
				guess[5:3] <= data_in;
			end
			if (load_guess_3) begin
				guess[8:6] <= data_in;
			end
			if (load_guess_4) begin
				guess[11:9] <= data_in;
			end
			//if (reach_result_4) begin
			//end
        end
		  
	  // determine win or loss
	  //if (guess_counter == 3) begin
			//if (red != 3'b100) begin
			// Game over! 
			//red_out <= 3'b000;
			//white_out <= 3'b000;
			//end
		//end

		//if (red == 3'b100) begin
			// Win! 
		//	red_out <= 3'd8;
		//	white_out <= 3'd8;
		//end
    end
	
	always @(*) begin
		if (!resetn) begin
			red_out <= 3'd0;
			white_out <= 3'd0;
		end
		else begin 
			red_out <= red;
			white_out <= white;
		end
	end
	
	always @(*) begin
		if (!resetn) begin
			curr_code <= 3'd0;
		end
		// assign curr code			
		else begin
			case (compare_i)
				2'd0: begin
					curr_code <= code[2:0];
				end
				2'd1: begin
					curr_code <= code[5:3];
				end
				2'd2: begin
					curr_code <= code[8:6];
				end
				2'd3: begin
					curr_code <= code[11:9];
				end
			endcase
		end
	end

	// increment guess_counter
	//always @(posedge reach_result_4) begin
	//	if (resetn) begin
	//		guess_counter <= 3'd0;
	//	end
	//	guess_counter <= guess_counter + 1;
	//end
	

	compare c(
		.clock(clk),
		.resetn(resetn),
		.compareEn(compare),
		.compare_i(compare_i),
		.curr_code(curr_code),
		.guess(guess),
		
		.red(red),
		.white(white),
		.reset_red_white(reset_red_white)
	);

endmodule


module compare(clock, resetn, compareEn, compare_i, curr_code, guess, red, white, reset_red_white);
    input resetn, clock, compareEn, reset_red_white;
    input [1:0] compare_i; // Two bit signal that indicates current code index
    input [2:0] curr_code;
    input [11:0] guess;
    output reg [2:0] red, white;

    wire [2:0] guess_1, guess_2, guess_3, guess_4;

    assign guess_1 = guess[2:0];
    assign guess_2 = guess[5:3];
    assign guess_3 = guess[8:6];
    assign guess_4 = guess[11:9];

    // Wires that indicate if code_x matches guess_x
    wire match_1;
    wire match_2;
    wire match_3;
    wire match_4;

    assign match_1 = (curr_code == guess_1) ? 1'b1 : 1'b0;
    assign match_2 = (curr_code == guess_2) ? 1'b1 : 1'b0;
    assign match_3 = (curr_code == guess_3) ? 1'b1 : 1'b0;
    assign match_4 = (curr_code == guess_4) ? 1'b1: 1'b0;

    // Red matchs (only one red_match can be 1 per clock cycle)
    wire red_match_1;
    wire red_match_2;
    wire red_match_3;
    wire red_match_4;

    assign red_match_1 = ((compare_i == 2'b00) && (match_1)) ? 1'b1 : 1'b0;
    assign red_match_2 = ((compare_i == 2'b01) && (match_2)) ? 1'b1 : 1'b0;
    assign red_match_3 = ((compare_i == 2'b10) && (match_3)) ? 1'b1 : 1'b0;
    assign red_match_4 = ((compare_i == 2'b11) && (match_4)) ? 1'b1 : 1'b0;

    wire any_red_match;

    assign any_red_match = (red_match_1 || red_match_2) || (red_match_3 || red_match_4);

    // White matches
    wire white_match_1;
    wire white_match_2;
    wire white_match_3;
    wire white_match_4;

    assign white_match_1 = ((!any_red_match) && match_1);
    assign white_match_2 = ((!any_red_match) && match_2);
    assign white_match_3 = ((!any_red_match) && match_3);
    assign white_match_4 = ((!any_red_match) && match_4);

    // Reg that tracks which code registers are already matched up
    reg matched_1;
    reg matched_2;
    reg matched_3;
    reg matched_4;
    

    always @(posedge clock) begin
	 
        if (!resetn || reset_red_white) begin
            matched_1 <= 0;
            matched_2 <= 0;
            matched_3 <= 0;
            matched_4 <= 0;
            red <= 3'b000;
            white <= 3'b000;
        end

        else if (compareEn) begin
            // Red matches first
            if (red_match_1) begin
                if (matched_1)
                    white <= white - 3'b001;
                else
                    matched_1 <= 1;
                red <= red + 3'b001;
            end
            
            else if (red_match_2) begin
                if (matched_2)
                    white <= white - 3'b001;
                else
                    matched_2 <= 1;
                red <= red + 3'b001;
            end

            else if (red_match_3) begin
                if (matched_3)
                    white <= white - 3'b001;
                else
                    matched_3 <= 1;
                red <= red + 3'b001;
            end

            else if (red_match_4) begin
                if (matched_4)
                    white <= white - 3'b001;
                else
                    matched_4 <= 1;
                red <= red + 3'b001;
            end

            // White matches next
            if ((!matched_1) && white_match_1) begin
                matched_1 <= 1;
                white <= white + 3'b001;
            end

            else if ((!matched_2) && white_match_2) begin
                matched_2 <= 1;
                white <= white + 3'b001;
            end

            else if ((!matched_3) && white_match_3) begin
                matched_3 <= 1;
                white <= white + 3'b001;
            end

            else if ((!matched_4) && white_match_4) begin
                matched_4 <= 1;
                white <= white + 3'b001;
            end
        end
    end
    
endmodule


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
