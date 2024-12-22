`timescale 1ns / 1ps


module UART_RX_WORD_BUFFER(
    input clk_100MHz,
    input rst,
    input en,
    input [7:0] rx_data,
    output [31:0] rx_inst_buffer_out,
    output inst_rdy
    );

    reg [7:0] inst_buffer_0;
    reg [7:0] inst_buffer_1;
    reg [7:0] inst_buffer_2;
    reg [7:0] inst_buffer_3;
    reg [2:0] counter;

    always @(posedge clk_100MHz) begin
        if (rst) begin
            inst_buffer_0 <= 0;
            inst_buffer_1 <= 0;
            inst_buffer_2 <= 0;
            inst_buffer_3 <= 0;
        end

        else begin
            if (en) begin
                inst_buffer_0 <= rx_data;
                inst_buffer_1 <= inst_buffer_0;
                inst_buffer_2 <= inst_buffer_1;
                inst_buffer_3 <= inst_buffer_2;
            end
        end
    end

    always @(posedge clk_100MHz) begin
        if (rst)
            counter <= 0;

        else begin
            if (en) begin
                counter <= counter + 1;
                if (counter == 3'd4)
                    counter <= 1;
            end
        end
    end

assign rx_inst_buffer_out = {inst_buffer_3, inst_buffer_2, inst_buffer_1, inst_buffer_0};
assign inst_rdy = (counter == 3'd4) ? 1'b1 : 1'b0; 

endmodule