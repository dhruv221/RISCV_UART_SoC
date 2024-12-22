`timescale 1ns / 1ps


module UART_RX_TOP(
    input clk_100MHz,
    input rst,
    input rx,
    output inst_rdy,
    output [7:0] AN,
    output [6:0] cathode,
    output DP
    );

    // wires
    wire tick;
    wire [7:0] rx_data;
    wire rx_data_ready;
    wire [31:0] rx_word;
    
    // baud generator
    UART_BAUD_GENERATOR 
        #(
            .M(3), 
            .N(2)
         ) 
        UART_BAUD_GENERATOR   
        (
            .clk_100MHz(clk_100MHz), 
            .reset(rst),
            .tick(tick)
         );
    
    // receive module
     UART_RX_UNIT
        #(
            .DBITS(8),
            .SB_TICK(16)
         )
         UART_RX_UNIT
         (
            .clk_100MHz(clk_100MHz),
            .reset(rst),
            .rx(rx),
            .sample_tick(tick),
            .data_ready(rx_data_ready),
            .data_out(rx_data)
         );

    // 32 bit byte shifter
    UART_RX_WORD_BUFFER UART_RX_WORD_BUFFER
    (
        .clk_100MHz(clk_100MHz),
        .rst(rst),
        .en(rx_data_ready),
        .rx_data(rx_data),
        .rx_inst_buffer_out(rx_word),
        .inst_rdy(inst_rdy)
    );

    // seven segment
    SEVEN_SEGMENT_TOP SEVEN_SEGMENT_TOP
    (
        .clk_100MHz(clk_100MHz),
        .data(rx_word),
        .AN(AN),
        .cathode(cathode),
        .DP(DP)
    );
    


endmodule