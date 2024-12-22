`timescale 1ns / 1ps



module RISCV_SoC_TOP(
    input clk_100MHz,
    input SW_clk,
    input rst,
    input hlt,
    input pgm_mode,
    input rx,
    input [9:0] SW,
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
            .clk_100MHz(clk_100M), 
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
            .clk_100MHz(clk_100M),
            .reset(rst),
            .rx(rx),
            .sample_tick(tick),
            .data_ready(rx_data_ready),
            .data_out(rx_data)
         );


    reg [9:0] pgm_addr_counter;
    always @(posedge clk_100M) begin
        if (rst)
            pgm_addr_counter <= 0;
        else begin
            if (rx_data_ready & pgm_mode)
                pgm_addr_counter <= pgm_addr_counter + 1;
        end
    end

    wire we;
    assign we = rx_data_ready & pgm_mode;



    wire clk_50M, clk_100M;
    design_1_wrapper clock_ip
    (
        .clk_in1_0(clk_100MHz),
        .clk_out1_0(clk_50M),
        .clk_out2_0(clk_100M)
    );

    wire [31:0] RISCV_data_mem_out;
    SINGLE_CYCLE_RISCV_TOP SINGLE_CYCLE_RISCV_TOP
    (
        .sys_clk(clk_50M),
        .imem_clk(clk_100M),
        .sys_rst(rst),
        .hlt(hlt),
        .inst_mem_we(we),
        .pgm_mode(pgm_mode),
        .pgm_addr(pgm_addr_counter),
        .pgm_data(rx_data),
        .io_data_mem_addr(SW),
        .io_data_mem_out(RISCV_data_mem_out)
    );


    // seven segment
    SEVEN_SEGMENT_TOP SEVEN_SEGMENT_TOP
    (
        .clk_100MHz(clk_100M),
        .data(RISCV_data_mem_out),
        .AN(AN),
        .cathode(cathode),
        .DP(DP)
    );

endmodule
