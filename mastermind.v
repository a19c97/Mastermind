module mastermind_top(
	SW, KEY, CLOCK_50, HEX6, HEX5, HEX3, HEX2, HEX1, HEX0
);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output HEX6, HEX5, HEX3, HEX2, HEX1, HEX0;
    
    wire load, resetn;
    assign resetn = KEY[1];
    assign load = KEY[0];
    
    wire [11:0] code, guess;
    wire [2:0] red, white;
    wire load_code_1, load_code_2, load_code_3, load_code_4, 
    load_guess_1, load_guess_2, load_guess_3, load_guess_4;
    wire compare;
    
    mastermind_control ctrl(
    	.clk(CLOCK_50),
    	.resetn(resetn),
    	.load(load),
    	
    	.compare(compare),
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
    	
    	.code(code),
    	.guess(guess),
    	.red_out(red),
    	.white_out(white)
    );
    
    hex_decoder H0(
        .hex_digit(code[2:0]), 
        .segments(HEX0)
    );
    
    hex_decoder H1(
        .hex_digit(code[5:3]), 
        .segments(HEX1)
    );
    
    hex_decoder H2(
        .hex_digit(code[8:6]), 
        .segments(HEX2)
    );
    
    hex_decoder H3(
        .hex_digit(code[11:9]), 
        .segments(HEX3)
    );
    
    hex_decoder H6(
        .hex_digit(red), 
        .segments(HEX6)
    );
    
    hex_decoder H5(
        .hex_digit(white), 
        .segments(HEX5)
    );
    
endmodule


module mastermind_control(
	input clk,
	input resetn,
	input load,
	
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
        	RESULT: next_state = resetn ? GUESS_1 : RESULT;
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
    		RESULT: begin
    			compare = 1'b1;
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


module mastermind_datapath(
	input clk,
	input resetn,
	input [2:0] data_in,
	input load_code_1, load_code_2, load_code_3, load_code_4,
	input load_guess_1, load_guess_2, load_guess_3, load_guess_4,
	input compare,
	
	output reg [11:0] code, guess;
	output reg [2:0] red_out, white_out;
);
	
	reg [2:0] red, white; // number of red and white pegs in feedback
	reg [2:0] guess_counter; // counter to count up to 8 guesses
	
	// loading inputs
	always @ (posedge clk) begin
        if (!resetn) begin
			red_out <= 3'd0;
			white_out <= 3'd0;
			guess_counter <= 3'd0;
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
			if (compare) begin
				red_out <= red;
				white_out <= white;
			end
        end
    end
	
	// determine win or loss
	always @(*) begin
		if (guess_counter == 8) begin
			// Lost!
			
		end
		if (red == 4) begin
			// Win! 
			
		end
	end

	// increment guess_counter
	// HOW???

	
	compare c(
		.code(code),
		.guess(guess),
		.red(red),
		.white(white)
	);

endmodule


module compare(
	input [11:0] code, guess,
	output [2:0] red, white
);
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