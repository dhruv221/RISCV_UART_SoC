`timescale 1ns / 1ps


module RV_INSTRUCTION_MEMORY(
    input clk,
    input we,
    input [9:0] addr,
    input [7:0] data_in,
    output [31:0] data_out
    );

    reg [7:0] instruction_mem [0:1023];

    initial begin
        $readmemh("INSTRUCTION_memfile.mem", instruction_mem);
    end

    always @(posedge clk) begin
        if (we)
            instruction_mem[addr] <= data_in;
    end

    assign data_out = {instruction_mem[addr + 3], instruction_mem[addr + 2], instruction_mem[addr + 1], instruction_mem[addr]};
endmodule
