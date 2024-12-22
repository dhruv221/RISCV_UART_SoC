`timescale 1ns / 1ps

module TEST_01_TOP(
    input clk_100MHz,
    input rst,
    input rx,
    input [9:0] SW,
    input mode,
    output [7:0] AN,
    output [6:0] cathode,
    output DP
    );
    
    // wires
    wire tick;
    wire [7:0] rx_data;
    wire rx_data_ready;
    
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


    reg [9:0] pgm_addr_counter;
    always @(posedge clk_100MHz) begin
        if (rst)
            pgm_addr_counter <= 0;
        else begin
            if (rx_data_ready & mode)
                pgm_addr_counter = pgm_addr_counter + 1;
        end
    end

    wire we;
    assign we = rx_data_ready & mode;

    reg [9:0] addr;
    always @(*) begin
        if (mode)
            addr <= pgm_addr_counter;
        else
            addr <= SW * 4;
    end

    wire [31:0] data_out;
    // Instruction memory
    RV_INSTRUCTION_MEMORY RV_INSTRUCTION_MEMORY
    (
        .clk(clk_100MHz),
        .we(we),
        .addr(addr),
        .data_in(rx_data),
        .data_out(data_out)
    );

    // seven segment
    SEVEN_SEGMENT_TOP SEVEN_SEGMENT_TOP
    (
        .clk_100MHz(clk_100MHz),
        .data(data_out),
        .AN(AN),
        .cathode(cathode),
        .DP(DP)
    );

endmodule