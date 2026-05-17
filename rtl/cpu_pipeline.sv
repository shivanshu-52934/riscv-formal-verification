module cpu_pipeline (

    input logic clk,
    input logic rst

);

//
// Hazard + stall signals
//

logic hazard;
logic stall;

//
// IF STAGE
//

logic [31:0] pc;
logic [31:0] next_pc;
logic [31:0] if_instr;

assign next_pc = pc + 4;

pc pc_inst (

    .clk(clk),
    .rst(rst),

    .stall(stall),

    .next_pc(next_pc),

    .pc_out(pc)

);

imem imem_inst (

    .addr(pc),

    .instr(if_instr)

);

//
// IF/ID PIPELINE REGISTER
//

logic [31:0] id_pc;
logic [31:0] id_instr;

if_id_reg if_id_inst (

    .clk(clk),
    .rst(rst),

    .stall(stall),

    .if_pc(pc),
    .if_instr(if_instr),

    .id_pc(id_pc),
    .id_instr(id_instr)

);

//
// ID STAGE
//

logic [6:0] opcode;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;

decoder decoder_inst (

    .instr(id_instr),

    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)

);

//
// CONTROL UNIT
//

logic id_reg_write;
logic id_alu_src;
logic [2:0] id_alu_sel;

control_unit control_inst (

    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),

    .reg_write(id_reg_write),
    .alu_src(id_alu_src),

    .alu_sel(id_alu_sel)

);

//
// REGISTER FILE
//

logic [31:0] rdata1;
logic [31:0] rdata2;

//
// WB stage
//
logic wb_reg_write;
logic [4:0] wb_rd;
logic [31:0] wb_result;

regfile regfile_inst (

    .clk(clk),
    .rst(rst),

    .we(wb_reg_write),

    .waddr(wb_rd),
    .wdata(wb_result),

    .raddr1(rs1),
    .raddr2(rs2),

    .rdata1(rdata1),
    .rdata2(rdata2)

);

//
// Immediate generation
//

logic [31:0] imm;

assign imm = {{20{id_instr[31]}}, id_instr[31:20]};

//
// ID/EX PIPELINE REGISTER
//

logic ex_reg_write;
logic ex_alu_src;
logic [2:0] ex_alu_sel;

logic [31:0] ex_rdata1;
logic [31:0] ex_rdata2;
logic [31:0] ex_imm;

logic [4:0] ex_rd;

id_ex_reg id_ex_inst (

    .clk(clk),
    .rst(rst),

    .stall(stall),

    //
    // Inputs from ID stage
    //
    .id_reg_write(id_reg_write),
    .id_alu_src(id_alu_src),
    .id_alu_sel(id_alu_sel),

    .id_rdata1(rdata1),
    .id_rdata2(rdata2),
    .id_imm(imm),

    .id_rd(rd),

    //
    // Outputs to EX stage
    //
    .ex_reg_write(ex_reg_write),
    .ex_alu_src(ex_alu_src),
    .ex_alu_sel(ex_alu_sel),

    .ex_rdata1(ex_rdata1),
    .ex_rdata2(ex_rdata2),
    .ex_imm(ex_imm),

    .ex_rd(ex_rd)

);

//
// HAZARD DETECTOR
//

hazard_unit hazard_inst (

    .rs1(rs1),
    .rs2(rs2),

    .ex_rd(ex_rd),

    .ex_reg_write(ex_reg_write),

    .hazard(hazard)

);

//
// STALL CONTROLLER
//

stall_controller stall_inst (

    .clk(clk),
    .rst(rst),

    .hazard(hazard),

    .stall(stall)

);

//
// EXECUTE STAGE
//

logic [31:0] alu_b;

assign alu_b =
    (ex_alu_src) ? ex_imm : ex_rdata2;

logic [31:0] alu_result;
logic zero;

alu alu_inst (

    .a(ex_rdata1),
    .b(alu_b),

    .alu_sel(ex_alu_sel),

    .result(alu_result),
    .zero(zero)

);

//
// EX/WB PIPELINE REGISTER
//

ex_wb_reg ex_wb_inst (

    .clk(clk),
    .rst(rst),

    .ex_reg_write(ex_reg_write),
    .ex_rd(ex_rd),
    .ex_result(alu_result),

    .wb_reg_write(wb_reg_write),
    .wb_rd(wb_rd),
    .wb_result(wb_result)

);

endmodule