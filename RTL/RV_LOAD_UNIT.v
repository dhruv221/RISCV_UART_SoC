`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Dhruv Wadhwa
// 
// Create Date:    11.05.2024 20:27:58
// Design Name:    LOAD_UNIT
// Module Name:    LOAD_UNIT
// Project Name:   SingleCycle_RISCV
// Target Devices: Nexys 4 DDR
// 
// Description: sx or zx data mem output based on bit 2 of funct 3
//                       +---------------------+
//             dmem_dout-|                     |-> xdmem_d
//                funct3-|       Load          |
//                       |       unit          |
//                       |                     |
//                       +---------------------+
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module RV_LOAD_UNIT(
    input [31:0] data_in,
    input [2:0] funct3,
    output reg [31:0] data_out
    );

    always @(*) begin
        case (funct3)
            3'b000: data_out <= {{24{data_in[7]}}, data_in[7:0]};   //lb
            3'b001: data_out <= {{16{data_in[15]}}, data_in[15:0]}; //lh
            3'b010: data_out <= data_in;                            //lw
            3'b100: data_out <= {24'd0, data_in[7:0]};              //lbu
            3'b101: data_out <= {16'd0, data_in[15:0]};             //lhu
            
            default: data_out <= data_in;
        endcase
    end
endmodule
