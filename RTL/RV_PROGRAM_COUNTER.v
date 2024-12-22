`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Dhruv Wadhwa
// 
// Create Date:    10.05.2024 18:17:27
// Design Name:    PROGRAM_COUNTER
// Module Name:    PROGRAM_COUNTER
// Project Name:   SingleCycle_RISCV
// Target Devices: Nexys 4 DDR
// 
// Description: Program counter for 32 bit wide instruction memory
//                        +---------------------+
//                sys_clk-|                     |-> pc_curr
//                sys_rst-|         PC          |-> pc_next
//                 pc_sel-|                     |
//                  pc_in-|                     |
//                        +---------------------+
//
//
//////////////////////////////////////////////////////////////////////////////////


module RV_PROGRAM_COUNTER(
    input sys_clk,         // system clock
    input sys_rst,         // system reset
    input hlt,             // hault pc
    input [31:0] pc_in,    // pc input value
    input pc_sel,          // pc update source select
    output [31:0] pc_curr, // pc current value
    output [31:0] pc_next  // pc next value
    );

    reg [31:0] PC;

    always @(posedge sys_clk) begin
        if (sys_rst)
            PC <= 0;

        else begin
            if (hlt == 0) begin
                case (pc_sel)
                    1'b0: PC <= PC + 4;
                    1'b1: PC <= pc_in;
                    default: PC <= PC + 4;
                endcase
            end
        end
    end

    assign pc_curr = PC;
    assign pc_next = PC + 4;
endmodule