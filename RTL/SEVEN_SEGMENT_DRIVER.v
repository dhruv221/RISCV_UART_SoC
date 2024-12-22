`timescale 1ns / 1ps


module SEVEN_SEGMENT_DRIVER(
    input clk,
    input [31:0] data,
    output reg [6:0] segment_cathode,
    output reg [7:0] segment_anode,
    output segment_dp
    );

    wire clk_en;
    reg [10:0] clk_divider;
    always @(posedge clk) begin
        clk_divider <= clk_divider + 1;
    end
    assign clk_en = (clk_divider == 512);

    reg [2:0] counter;
    always @(posedge clk) begin
        if (clk_en)
            counter <= counter + 1;
    end

    always @(*) begin
        case (counter)
        3'b000: segment_anode <= 8'b11111110;
        3'b001: segment_anode <= 8'b11111101;
        3'b010: segment_anode <= 8'b11111011;
        3'b011: segment_anode <= 8'b11110111;
        3'b100: segment_anode <= 8'b11101111;
        3'b101: segment_anode <= 8'b11011111;
        3'b110: segment_anode <= 8'b10111111;
        3'b111: segment_anode <= 8'b01111111;
        endcase
    end

    reg [3:0] nibble;
    wire [3:0] n1, n2, n3, n4, n5, n6, n7, n8;
    assign n1 = data[3:0];
    assign n2 = data[7:4];
    assign n3 = data[11:8];
    assign n4 = data[15:12];
    assign n5 = data[19:16];
    assign n6 = data[23:20];
    assign n7 = data[27:24];
    assign n8 = data[31:28];

    always @(*) begin
        case (counter)
        3'b000: nibble <= n1;
        3'b001: nibble <= n2;
        3'b010: nibble <= n3;
        3'b011: nibble <= n4;
        3'b100: nibble <= n5;
        3'b101: nibble <= n6;
        3'b110: nibble <= n7;
        3'b111: nibble <= n8;
        endcase
    end


    always @(*) begin
        case (nibble)
        4'b0000: segment_cathode <= 7'b0000001; //0
        4'b0001: segment_cathode <= 7'b1001111; //1
        4'b0010: segment_cathode <= 7'b0010010; //2
        4'b0011: segment_cathode <= 7'b0000110; //3
        4'b0100: segment_cathode <= 7'b1001100; //4
        4'b0101: segment_cathode <= 7'b0100100; //5
        4'b0110: segment_cathode <= 7'b0100000; //6
        4'b0111: segment_cathode <= 7'b0001111; //7

        4'b1000: segment_cathode <= 7'b0000000; //8
        4'b1001: segment_cathode <= 7'b0000100; //9
        4'b1010: segment_cathode <= 7'b0001000; //A
        4'b1011: segment_cathode <= 7'b1100000; //B
        4'b1100: segment_cathode <= 7'b0110001; //C
        4'b1101: segment_cathode <= 7'b1000010; //D
        4'b1110: segment_cathode <= 7'b0110000; //E
        4'b1111: segment_cathode <= 7'b0111000; //F
        endcase
    end

    assign segment_dp = 1'b1;
endmodule
