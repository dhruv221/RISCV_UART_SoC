`timescale 1ns / 1ps


module RV_DATA_MEMORY(
    input clk_a, clk_b, we_a, we_b,
    input  [9:0] addr_a, addr_b,
    input  [31:0] data_in_a,
    input  [31:0] data_in_b,
    output [31:0] data_out_a,
    output [31:0] data_out_b
    );

    (*ram_style = "block"*) reg [31:0] ram [0:1023];
    
    initial begin
        $readmemh("DATA_memfile.mem", ram);
    end
   

    always @(posedge clk_a)
    begin
        if (we_a)
            ram[addr_a] <= data_in_a;
        //doa <= ram[addra];
    end
    

    always @(posedge clk_b)
    begin
        if (we_b)
            ram[addr_b] <= data_in_b;
        //dob <= ram[addrb];
    end

    assign data_out_a = ram[addr_a];
    assign data_out_b = ram[addr_b];
endmodule
