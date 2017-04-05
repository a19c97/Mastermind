module mastermind(
	SW, KEY, CLOCK_50, HEX5, HEX4, HEX1, HEX0,
	VGA_CLK,   						//	VGA Clock
	VGA_HS,							//	VGA H_SYNC
	VGA_VS,							//	VGA V_SYNC
	VGA_BLANK_N,						//	VGA BLANK
	VGA_SYNC_N,						//	VGA SYNC
	VGA_R,   						//	VGA Red[9:0]
	VGA_G,	 						//	VGA Green[9:0]
	VGA_B   						//	VGA Blue[9:0]
);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [6:0] HEX5, HEX4, HEX2, HEX1, HEX0;
    
    // VGA outputs
    output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
    
    wire load, resetn, reset_clock, soft_reset;
    assign resetn = KEY[1];
    assign load = ~KEY[0];
    assign reset_clock = KEY[2];
    assign soft_reset = KEY[3];
    
    wire [11:0] code, guess;
    wire [2:0] red_out, white_out;
    wire load_code_1, load_code_2, load_code_3, load_code_4, 
         load_guess_1, load_guess_2, load_guess_3, load_guess_4;
    wire draw_result_1, draw_result_2;
    wire compare;
    wire [1:0] compare_i;
    wire reach_result_5, reset_red_white, erase_code;
    wire [2:0] guess_counter;
    wire [2:0] curr_code;
    wire slow_clock;
    wire [27:0] q;
    wire [3:0] one_score, two_score;
    wire one_sets_code;

    wire [6:0] x_out, y_out;
    wire draw_out;
    wire [2:0] colour_out;
    
    vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour_out),
			.x(x_out),
			.y(y_out),
			.plot(draw_out),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION = "160x120";
	defparam VGA.MONOCHROME = "FALSE";		
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "black.mif";
    
    mastermind_control ctrl(
		.clk(slow_clock),
    	.resetn(resetn),
        .reset_soft(reset_soft),
    	.load(load),	
    	.compare(compare),
		.compare_i(compare_i),
		.reach_result_5(reach_result_5),
		.reset_red_white(reset_red_white),
    	.load_code_1(load_code_1),
    	.load_code_2(load_code_2),
    	.load_code_3(load_code_3),
    	.load_code_4(load_code_4),
    	.load_guess_1(load_guess_1),
    	.load_guess_2(load_guess_2),
    	.load_guess_3(load_guess_3),
    	.load_guess_4(load_guess_4),
		.erase_code(erase_code),
        .draw_result_1(draw_result_1),
        .draw_result_2(draw_result_2),
        .one_score(one_score),
        .two_score(two_score),
		.one_sets_code(one_sets_code)
    );
    
    mastermind_datapath data(
    	.clk(slow_clock),
        .fast_clk(CLOCK_50),
    	.resetn(resetn),
    	.reset_soft(reset_soft),
    	.data_in(SW[2:0]),
    	.load_code_1(load_code_1),
    	.load_code_2(load_code_2),
    	.load_code_3(load_code_3),
    	.load_code_4(load_code_4),
    	.load_guess_1(load_guess_1),
    	.load_guess_2(load_guess_2),
    	.load_guess_3(load_guess_3),
    	.load_guess_4(load_guess_4),

        .erase_code(erase_code),
        .draw_result_1(draw_result_1),
        .draw_result_2(draw_result_2),

		.compare_i(compare_i),
		.compare(compare),
		.reach_result_5(reach_result_5),
		.reset_red_white(reset_red_white),
    	.code(code),
    	.guess(guess),
    	.red_out(red_out),
    	.white_out(white_out),
		.guess_counter(guess_counter),
		.curr_code(curr_code),

        .x_out(x_out),
        .y_out(y_out),
        .draw_out(draw_out),
        .colour_out(colour_out)
    );
    
    slow_clock sc(
    	.clock(CLOCK_50),
		.reset_n(reset_clock),
		.slow_clock(slow_clock),
		.q(q)
    );
    
    hex_decoder H0(
        .hex_digit(one_score), 
        .segments(HEX0)
    );
    
    hex_decoder H1(
        .hex_digit(two_score), 
        .segments(HEX1)
    );
    
    hex_decoder H2(
        .hex_digit({3'b0, one_sets_code}), 
        .segments(HEX2)
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
	input reset_soft,
	
	output reg compare, 
	output reg load_code_1, load_code_2, load_code_3, load_code_4,
	output reg load_guess_1, load_guess_2, load_guess_3, load_guess_4,
    output reg erase_code,
	output reg draw_result_1, draw_result_2,
	output reg [1:0] compare_i,
	output reg reach_result_5, reset_red_white
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
	    RESULT_4 = 8'd20,
        RESULT_5 = 8'd21,
	    ERASE_CODE = 8'd22,
	    ERASE_CODE_WAIT = 8'd23;
        
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
        	LOAD_CODE_4_WAIT: next_state = load ? LOAD_CODE_4_WAIT : ERASE_CODE;
		    ERASE_CODE: next_state = load ? ERASE_CODE_WAIT: ERASE_CODE;
		    ERASE_CODE_WAIT: next_state = load ? ERASE_CODE_WAIT : GUESS_1;
        	GUESS_1: next_state = load ? GUESS_1_WAIT : GUESS_1;
        	GUESS_1_WAIT: next_state = load ? GUESS_1_WAIT : GUESS_2;
        	GUESS_2: next_state = load ? GUESS_2_WAIT : GUESS_2;
        	GUESS_2_WAIT: next_state = load ? GUESS_2_WAIT : GUESS_3;
        	GUESS_3: next_state = load ? GUESS_3_WAIT : GUESS_3;
        	GUESS_3_WAIT: next_state = load ? GUESS_3_WAIT : GUESS_4;
        	GUESS_4: next_state = load ? GUESS_4_WAIT : GUESS_4;
        	GUESS_4_WAIT: next_state = load ? GUESS_4_WAIT : RESULT_0;
		    RESULT_0: next_state = RESULT_1;
		    RESULT_1: next_state = RESULT_2;
		    RESULT_2: next_state = RESULT_3;
		    RESULT_3: next_state = RESULT_4;	
		    RESULT_4: next_state = RESULT_5;
            RESULT_5: next_state = GUESS_1;
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

        erase_code = 1'b0;

        draw_result_1 = 1'b0;
        draw_result_2 = 1'b0;
        
		compare = 1'b0;
		compare_i = 2'd0;
		reach_result_5 = 1'b0;
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
		    ERASE_CODE: begin
			    erase_code = 1'b1;
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
			    reset_red_white = 1'b1;
    		end
    		RESULT_0: begin
			    compare = 1'b1;
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
                draw_result_1 = 1'b1;
    		end
            RESULT_5: begin
                draw_result_2 = 1'b1;
				reach_result_5 = 1'b1;
            end
    	endcase
    end
    
    always@(posedge clk)
    begin: state_FFs
        if (!resetn || !reset_soft)
            current_state <= LOAD_CODE_1;
        else
            current_state <= next_state;
    end 

endmodule


module mastermind_datapath(
	input clk,
    input fast_clk,
	input resetn,
	input reset_n,
	input [2:0] data_in,
	input load_code_1, load_code_2, load_code_3, load_code_4,
	input load_guess_1, load_guess_2, load_guess_3, load_guess_4,
    input erase_code,
    input draw_result_1, draw_result_2,
	input [1:0] compare_i,
	input compare, reach_result_5, reset_red_white,
	
	output reg [11:0] code, guess,
	output reg [2:0] red_out, white_out,
	output reg [2:0] guess_counter,
	output reg [2:0] curr_code,

    output reg [6:0] x_out,
    output reg [6:0] y_out,
    output reg draw_out,
    output reg [2:0] colour_out,
    
    output reg [3:0] one_score, two_score,
    output reg one_sets_code
);
	
	wire [2:0] red, white; // number of red and white pegs in feedback
	
	// loading inputs
	always @ (posedge clk) begin
        if (!resetn || !reset_soft) begin
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
        end
    end
    
    // Drawing modules
    
    wire [8:0] big_x, big_y;
    wire [6:0] medium_x, medium_y;
    wire [11:0] erase_x, erase_y;
    wire [6:0] small_red_x, small_red_y;
    wire [6:0] small_white_x, small_white_y;
    wire [14:0] erase_screen_x, erase_screen_y;
    
    wire erase_screen;
    assign erase_screen = (load_guess_1 == 1'b1 && (guess_counter == 3'b111 || red_out == 3'b100)) ? 1 : 0;
    
    big_square bs_counter(
    	.enable(load_code_1 || load_code_2 || load_code_3 || load_code_4),
    	.clock(fast_clk),
    	.resetn(resetn),
    	.x(big_x),
    	.y(big_y)
    );
    
    medium_square ms_counter(
    	.enable(load_guess_1 || load_guess_2 || load_guess_3 || load_guess_4),
    	.clock(fast_clk),
    	.resetn(resetn),
    	.x(medium_x),
    	.y(medium_y)
    );
    
    erase_code_squares erase_counter(
    	.enable(erase_code),
    	.clock(fast_clk),
    	.resetn(resetn),
    	.x(erase_x),
    	.y(erase_y)
    );

    small_squares red_counter(
        .enable(draw_result_1),
        .clock(fast_clk),
        .resetn(resetn),
        .peg_count(red_out),
        .x(small_red_x),
        .y(small_red_y)
    );

    small_squares white_counter(
        .enable(draw_result_2),
        .clock(fast_clk),
        .resetn(resetn),
        .peg_count(white_out),
        .x(small_white_x),
        .y(small_white_y)
    );

	erase_screen es_counter(
		.enable(erase_screen),
		.clock(fast_clk),
		.resetn(resetn),
		.x(erase_screen_x),
		.y(erase_screen_y)
	);

    // Drawing always block 
    always @(*) begin
        if (!resetn || !reset_soft) begin
            x_out <= 0;
            y_out <= 0;
            draw_out <= 0;
            colour_out <= 0;
        end
        else begin
            draw_out <= (load_code_1 || load_code_2 || load_code_3 || load_code_4 || load_guess_1 || load_guess_2 || load_guess_3 || load_guess_4 || erase_code || draw_result_1 || draw_result_2 || erase_screen) ? 1'b1 : 1'b0;

            if (load_code_1) begin
		        x_out <= 7'd10 + big_x[6:0];
		        y_out <= 7'd50 + big_y[6:0];
		        colour_out <= data_in;
            end
            if (load_code_2) begin
                x_out <= 7'd40 + big_x[6:0];
                y_out <= 7'd50 + big_y[6:0];
                colour_out <= data_in;
            end
            if (load_code_3) begin
                x_out <= 7'd70 + big_x[6:0];
                y_out <= 7'd50 + big_y[6:0];
                colour_out <= data_in;
            end
            if (load_code_4) begin
                x_out <= 7'd100 + big_x[6:0];
                y_out <= 7'd50 + big_y[6:0];
                colour_out <= data_in;
            end
            if (load_guess_1) begin
                if (!erase_screen) begin
                    x_out <= 7'd10 + medium_x;
                    y_out <= 7'd10 + (7'd15 * {4'b0, guess_counter}) + medium_y;
                    colour_out <= data_in;
                end
                else begin
                    x_out <= erase_screen_x[6:0];
                    y_out <= erase_screen_y[6:0];
                    colour_out <= 3'b000;
                end
                
                // win condition
                //if (red_out == 3'd4) begin
                //end 
                // loss condition
                //if (guess_counter == 3'd7) begin
                //    if (red_out != 3'd4) begin
                //    end
                //end
            end
            if (load_guess_2) begin
                x_out <= 7'd30 + medium_x;
                y_out <= 7'd10 + (7'd15 * {4'b0, guess_counter}) + medium_y;
                colour_out <= data_in;
            end
            if (load_guess_3) begin
                x_out <= 7'd50 + medium_x;
                y_out <= 7'd10 + (7'd15 * {4'b0, guess_counter}) + medium_y;
                colour_out <= data_in;
            end
            if (load_guess_4) begin
                x_out <= 7'd70 + medium_x;
                y_out <= 7'd10 + (7'd15 * {4'b0, guess_counter}) + medium_y;
                colour_out <= data_in;
            end

            if (erase_code) begin
                x_out <= 7'd10 + erase_x[6:0];
                y_out <= 7'd50 + erase_y[6:0];
                colour_out <= 3'b000;
            end

            if (draw_result_1) begin
            	if (red_out == 3'd0)
            		colour_out <= 3'b000;
            	else
					colour_out <= 3'b100; // Draw red
					
		        x_out <= 7'd100 + small_red_x;
	            y_out <= 7'd10 + (7'd15 * {4'b0, guess_counter}) + small_red_y;
            end

            if (draw_result_2) begin
            	if (white_out == 3'd0)
            		colour_out <= 3'b000;
            	else
            		colour_out <= 3'b111; // Draw white
           		
                x_out <= 7'd100 + small_white_x;
                y_out <= 7'd16 + (7'd15 * {4'b0, guess_counter}) + small_white_y;
                
            end
        end
    end
	
    // Red and white always block
	always @(*) begin
		if (!reset_soft) begin // reset_soft should leave scores unchanged
			red_out <= 3'd0;
			white_out <= 3'd0;
			one_sets_code <= one_sets_code ? 1'b0 : 1'b1; // flip one_sets_code
		end
		if (!resetn) begin
			red_out <= 3'd0;
			white_out <= 3'd0;
			one_score <= 4'd0;
			two_score <= 4'd0;
			one_sets_code <= 1'b1;
		end
		else begin 
			red_out <= red;
			white_out <= white;
		end
	end
	
    // Curr code always block
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

	// Guess_counter
	always @(posedge clk) begin
		if (!resetn) begin
			guess_counter <= 3'd0;
		end
		if (reach_result_5) begin
            if (guess_counter == 3'd7)
                guess_counter <= 3'd0;
            else begin
			    guess_counter <= guess_counter + 1;
			    if one_sets_code begin
				    one_score <= one_score + 1;
			    end 
			    else begin
				    two_score <= two_score + 1;
			    end
			end
		end
	end
	

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


module slow_clock(reset_n, clock, slow_clock, q); 

	input clock;
	input reset_n;
	output reg slow_clock;
	output reg [27:0] q;
	
	always @(posedge clock)
	begin 
		if (!reset_n)
		begin
			q <= 28'd0;
			slow_clock <= 1'b0;
		end
		else
		begin
			if (q == (20'b11110100001001000000 - 1))
			//if (q == 27'd3)
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


module big_square(
    input enable,
    input clock, // 50 MHz clock
    input resetn,
    output [8:0] x,
    output [8:0] y
);
    reg [8:0] Q;
    
    assign x = Q % 9'd20; // modulo 20
    assign y = Q / 9'd20; // floor division by 20

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 9'd399)
                Q <= 0;
            else
                Q <= Q + 1'b1;
        end
    end

endmodule


module medium_square(
    input enable,
    input clock, // 50 MHz clock
    input resetn,
    output [6:0] x,
    output [6:0] y
);
    reg [6:0] Q;
    
    assign x = Q % 7'd10; // modulo 10
    assign y = Q / 7'd10; // floor division by 10

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 7'd99)
                Q <= 0;
            else
                Q <= Q + 1'b1;
        end
    end

endmodule


module erase_code_squares(
    input enable,
    input clock, // 50 MHz clock
    input resetn,
    output [11:0] x,
    output [11:0] y
);

    reg [11:0] Q;
    
    assign x = Q % 12'd110; // modulo 110
    assign y = Q / 12'd110; // floor division by 110

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 12'd2199)
                Q <= 0;
            else
                Q <= Q + 1'b1;
        end
    end 

endmodule 


module small_squares(
    input enable,
    input clock, // 50 MHz clock
    input resetn,
    input [2:0] peg_count,
    output reg [6:0] x,
    output reg [6:0] y
);
    reg [6:0] Q;
    
    always @(*) begin
        if (!resetn)
		  begin
            x <= 0;
				y <= 0;
		  end
        else begin
		      y <= Q / 7'd22;
            case (peg_count)
                3'd0: begin
                    x <= 7'b0;
                end
                3'd1: begin
                    if (Q % 7'd22 >= 7'd4)
                        x <= 0;
                    else
                        x <= Q % 7'd22;
                end
                
                3'd2: begin
                    if (Q % 7'd22 >= 7'd10)
                        x <= 0;
                    else if (Q % 7'd22 == 7'd4 ||
                             Q % 7'd22 == 7'd5)
                        x <= 0;
                    else
                        x <= Q % 7'd22;
                end
                
                3'd3: begin
                    if (Q % 7'd22 >= 7'd16)
                        x <= 0;
                    else if (Q % 7'd22 == 7'd4 ||
                             Q % 7'd22 == 7'd5 ||
                             Q % 7'd22 == 7'd10 ||
                             Q % 7'd22 == 7'd11)
                        x <= 0;
                    else
                        x <= Q % 7'd22;
                end
                
                3'd4: begin
                    if (Q % 7'd22 == 7'd4 ||
                             Q % 7'd22 == 7'd5 ||
                             Q % 7'd22 == 7'd10 ||
                             Q % 7'd22 == 7'd11 ||
                             Q % 7'd22 == 7'd16 ||
                             Q % 7'd22 == 7'd17)
                        x <= 0;
                    else
                        x <= Q % 7'd22;
                end

                default: x <= 0;
            endcase
        end
    end



    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 7'd87)
                Q <= 0;
            else
                Q <= Q + 1'b1;
        end
    end

endmodule


module erase_screen(
    input enable,
    input clock, // 50 MHz clock
    input resetn,
    output [13:0] x,
    output [13:0] y
);
    reg [13:0] Q;
    
    assign x = Q % 14'd128; // modulo 128
    assign y = Q / 14'd128; // floor division by 128

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 14'd16383)
                Q <= 0;
            else
                Q <= Q + 1'b1;
        end
    end

endmodule

