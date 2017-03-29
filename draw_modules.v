module big_square(
    input enable,
    input clock, // 50 MHz clock
    input resetn,
    output [8:0] x,
    output [8:0] y
);
    reg [8:0] Q;
    
    assign x = Q % 9'b000010100; // modulo 20
    assign y = Q / 9'b000010100; // floor division by 20

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 9'b110001111) // 399 in binary
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
    
    assign x = Q % 7'b0001010; // modulo 10
    assign y = Q / 7'b0001010; // floor division by 10

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 7'b1100011) // 99 in binary
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
    reg [6:0] Q;
    
    assign x = Q % 12'b000001101110; // modulo 110
    assign y = Q / 12'b000001101110; // floor division by 110

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 12'b100010010111) // 2199 in binary
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
    output [6:0] y
);
    reg [6:0] Q;
    
    always @(*) begin
        if (!resetn)
            x <= 0;
        else begin
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

    assign y = Q / 7'd22; // floor division by 22

    always @(posedge clock)
    begin
        if (!resetn)
            Q <= 0;
        else if (enable == 1'b1)
        begin
            if (Q == 7'd87) // 87 in binary
                Q <= 0;
            else
                Q <= Q + 1'b1;
        end
    end

endmodule

