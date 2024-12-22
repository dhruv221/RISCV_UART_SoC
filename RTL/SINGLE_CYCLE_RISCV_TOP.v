`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dhruv Wadhwa
// 
// Create Date: 14.12.2024 12:59:49
// Design Name: SINGLE_CYCLE_RISCV_TOP
// Module Name: SINGLE_CYCLE_RISCV_TOP
// Project Name: SingleCycle_RISCV
// Target Devices: Nexys 4 DDR
// Description: 
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module SINGLE_CYCLE_RISCV_TOP(
    input sys_clk,
    input imem_clk,
    input sys_rst,
    input hlt,
    input inst_mem_we,
    input pgm_mode,
    input [9:0] pgm_addr,
    input [7:0] pgm_data,
    input [9:0] io_data_mem_addr,
    output [31:0] io_data_mem_out
    );

    // WIRES
        // PROGRAM COUNTER
        wire [31:0] alu_result;
        wire pc_sel;
        wire [31:0] pc_curr;
        wire [31:0] pc_next;
        // INSTRUCTION MEMORY
        wire [31:0] instruction;
        // REGISTER FILE
        wire reg_we;
        wire [31:0] reg_file_data;
        wire [31:0] rs1;
        wire [31:0] rs2;
        // IMM GENERATOR
        wire [2:0] inst_type;
        wire [31:0] imm_x;
        // ALU
        wire [31:0] alu_in_a;
        wire [31:0] alu_in_b;
        // BRANCH COMPARATOR
        wire [2:0] funct3;
        wire brq;
        // CONTROL UNIT
        wire a_sel;
        wire b_sel;
        wire data_mem_we;
        wire [1:0] wb_sel;
        wire [3:0] alu_op;
        // DATA MEMORY
        wire [31:0] data_mem_data;
        // LOAD UNIT
        wire [31:0] x_data_mem_data;





    // PROGRAM COUNTER
        RV_PROGRAM_COUNTER RV_PROGRAM_COUNTER
        (
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .hlt(hlt),
            .pc_in(alu_result),
            .pc_sel(pc_sel),
            .pc_curr(pc_curr),
            .pc_next(pc_next)
        );

    // INSTRUCTION MEMORY
        reg [9:0] instruction_memory_addr;
        always @(*) begin
            if (pgm_mode & hlt)
                instruction_memory_addr <= pgm_addr;
            else
                instruction_memory_addr <= pc_curr;
        end

        RV_INSTRUCTION_MEMORY RV_INSTRUCTION_MEMORY
        (
            .clk(imem_clk),
            .we(inst_mem_we),
            .addr(instruction_memory_addr),
            .data_in(pgm_data),
            .data_out(instruction)
        );
    
    // REGISTER FILE
        RV_REGISTER_FILE RV_REGISTER_FILE
        (
            .sys_clk(sys_clk), 
            .sys_rst(sys_rst),  
            .we(reg_we), 
            .rd_addr(instruction[11:7]),
            .rs1_addr(instruction[19:15]),
            .rs2_addr(instruction[24:20]),
            .rd_data(reg_file_data),
            .rs1(rs1),
            .rs2(rs2) 
        );

        assign alu_in_a = a_sel ? rs1 : pc_curr;
        assign alu_in_b = b_sel ? imm_x : rs2;


    // IMM GENERATOR
        RV_IMM_GENERATOR RV_IMM_GENERATOR
        (
            .inst(instruction),
            .inst_type(inst_type),
            .imm_x(imm_x)
        );

    // ALU
        RV_ALU RV_ALU
        (
            .A_in(alu_in_a),
            .B_in(alu_in_b),
            .alu_op(alu_op),
            .result(alu_result)
        );

    // BRANCH COMPARATOR
        RV_BRANCH_COMPARATOR RV_BRANCH_COMPARATOR
        (
            .rs1(rs1),
            .rs2(rs2),
            .funct3(funct3),
            .brq(brq)
        );

    // CONTROL UNIT
        RV_CONTROL_UNIT RV_CONTROL_UNIT
        (
            .inst(instruction),
            .brq(brq),
            .hlt(hlt),
            .pc_sel(pc_sel),
            .reg_we(reg_we),
            .A_sel(a_sel),
            .B_sel(b_sel),
            .inst_type(inst_type),
            .alu_op(alu_op),
            .funct3(funct3),
            .mem_we(data_mem_we),
            .wb_sel(wb_sel)
        );

    // DATA MEMORY
        RV_DATA_MEMORY RV_DATA_MEMORY
        (
            .clk_a(sys_clk), 
            .clk_b(sys_clk), 
            .we_a(data_mem_we), 
            .we_b(1'b0),
            .addr_a(alu_result), 
            .addr_b(io_data_mem_addr),
            .data_in_a(rs2),
            .data_in_b(32'd0),
            .data_out_a(data_mem_data),
            .data_out_b(io_data_mem_out)
        );

    // LOAD UNIT
        RV_LOAD_UNIT RV_LOAD_UNIT
        (
            .data_in(data_mem_data),
            .funct3(funct3),
            .data_out(x_data_mem_data)
        );

    // WB MUX
        reg [31:0] wb_data;
        always @(*) begin
            case (wb_sel)
                2'd0: wb_data <= pc_next;
                2'd1: wb_data <= alu_result;
                2'd2: wb_data <= imm_x;
                2'd3: wb_data <= x_data_mem_data;
                default: wb_data <= 32'd0;
            endcase
        end
        assign reg_file_data = wb_data;
endmodule
