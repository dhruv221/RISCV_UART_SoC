`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Dhruv Wadhwa
// 
// Create Date:    06.04.2024 17:07:38
// Design Name:    REGISTER_FILE
// Module Name:    REGISTER_FILE
// Project Name:   SingleCycle_RISCV
// Target Devices: Nexys 4 DDR
// 
// Description: Regiter File for rv32i 
//                       +---------------------+
//                       |                     |
//              sys_clk -|                     |-> rs1
//               sys_rst-|      Register       |-> rs2
//                    we-|       File          |
//               rd_addr-|                     |
//               rd_data-|                     |
//              rs1_addr-|                     |
//              rs2_addr-|                     |
//                       |                     |
//                       +---------------------+
//              at rising clk: if (we) rd=data, if (rst) all register = 0
//              always output rs1 and rs2 data based on rs1 and rs2 address
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module RV_REGISTER_FILE(
    input sys_clk,         // system clock
    input sys_rst,         // system reset
    input we,              // write enable
    input [4:0] rd_addr,   // rd address
    input [4:0] rs1_addr,  // rs1 address
    input [4:0] rs2_addr,  // rs2 address
    input [31:0] rd_data,  // rd  data in
    output [31:0] rs1,     // rs1 data out
    output [31:0] rs2      // rs2 data out
    );


    reg [31:0] regFile[0:31];

    integer i;
    always @(posedge sys_clk) begin
        if (sys_rst) begin
            for (i = 0; i < 32; i = i+1)
            regFile[i] <= 0;
        end

        else begin
            if (we) begin
                regFile[rd_addr] <= rd_data;
                regFile[0] <= 32'd0;
            end
        end
    end

    assign rs1 = regFile[rs1_addr];
    assign rs2 = regFile[rs2_addr];

endmodule