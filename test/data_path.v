module datapath(
	input clk,
	input resetn,
	input [2:0] data_in,
	input load_code_1, load_code_2, load_code_3, load_code_4,
	input load_guess_1, load_guess_2, load_guess_3, load_guess_4,
	input [1:0] compare_i,
	input compare, reach_result_3,
	
	output reg [11:0] code, guess,
	output reg [2:0] red_out, white_out,
	output reg [2:0] guess_counter
);
	
	wire [2:0] red, white; // number of red and white pegs in feedback
	//reg [2:0] guess_counter; // counter to count up to 8 guesses
	reg [2:0] curr_code;
	
	// loading inputs
	always @ (posedge clk) begin
        if (!resetn) begin
			red_out <= 3'd0;
			white_out <= 3'd0;
			guess_counter <= 3'd0;
			code <= 12'd0;
			guess <= 12'd0;
			curr_code <= 3'd0;
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
		if (guess_counter == 3) begin
			if (red != 3'b100) begin
				// Game over! 
				red_out <= 3'b000;
				white_out <= 3'b000;
			end
			
		end
		if (red == 3'b100) begin
			// Win! 
			// red_out <= 3'd8;
			// white_out <= 3'd8;
		end
	end

	// increment guess_counter
	always @(posedge reach_result_3) begin
		guess_counter <= guess_counter + 1;
	end
	
	// assign curr_code
	always @(*) begin
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

	compare c(
		.clock(clk),
		.resetn(resetn),
		.compareEn(compare),
		.compare_i(compare_i),
		.curr_code(curr_code),
		.guess(guess),
		.red(red),
		.white(white)
	);

endmodule


module compare(clock, resetn, compareEn, compare_i, curr_code, guess, red, white);
    input resetn, clock, compareEn;
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
        if (!resetn) begin
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
