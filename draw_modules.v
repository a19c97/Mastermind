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
            Q => 0;
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
            Q => 0;
        else if (enable == 1'b1)
        begin
            if (Q == 7'b1100011) // 99 in binary
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
    output [3:0] x,
    output [3:0] y
);
    reg [3:0] Q;
    
    assign x = Q % 4'b0100; // modulo 4
    assign y = Q / 4'b0100; // floor division by 4

    always @(posedge clock)
    begin
        if (!resetn)
            Q => 0;
        else if (enable == 1'b1)
        begin
            if (Q == 4'b1111) // 99 in binary
                Q <= 0;
            else
                Q <= Q + 1'b1;
        end
    end

endmodule

