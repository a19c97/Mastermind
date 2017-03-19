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

    // White matches
    wire white_match_1;
    wire white_match_2;
    wire white_match_3;
    wire white_match_4;

    assign white_match_1 = ((!red_match_1) && match_1);
    assign white_match_2 = ((!red_match_2) && match_2);
    assign white_match_3 = ((!red_match_3) && match_3);
    assign white_match_4 = ((!red_match_4) && match_4);

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
            if ((!matched_1) && red_match_1) begin
                matched_1 <= 1;
                red <= red + 3'b001;
            end
            
            else if ((!matched_2) && red_match_2) begin
                matched_2 <= 1;
                red <= red + 3'b001;
            end

            else if ((!matched_3) && red_match_3) begin
                matched_3 <= 1;
                red <= red + 3'b001;
            end

            else if ((!matched_4) && red_match_4) begin
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

