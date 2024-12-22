`timescale 1ns / 1ps


module SEVEN_SEGMENT_TOP(
    input clk_100MHz,
    input [31:0] data,
    output [7:0] AN,
    output [6:0] cathode,
    output DP
    );

    // wire clk;
    // reg [10:0] counter;
    // always @(posedge clk_100MHz) begin
    //     counter <= counter + 1;
    // end

    SEVEN_SEGMENT_DRIVER SEVEN_SEGMENT_DRIVER(
    .clk(clk_100MHz),
    .data(data),
    .segment_anode(AN),
    .segment_cathode(cathode),
    .segment_dp(DP)
    );

endmodule