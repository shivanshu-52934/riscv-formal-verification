module cpu (

    input logic clk,
    input logic rst

);

//
// PC
//
logic [31:0] pc;
logic [31:0] next_pc;

//
// IF stage instruction
//
logic [31:0] if_instr;

//
// IF/ID pipeline outputs
//
logic [31:0] id_instr;
logic [31:0] id_pc;

//
// Decoder signals
//
logic [6:0] opcode;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;

//
// Register file
//
logic [31:0] rdata1;
logic [31:0] rdata2;

//
// Immediate
//
logic [31:0] imm;

//
// Control signals
//
logic reg_write;
logic alu_src;
logic [2:0] alu_sel;

//
// ALU
//
logic [31:0] alu_b;
logic [31:0] alu_result;
logic zero;

//
// PC increment
//
assign next_pc = pc + 4;

//
// Immediate generation (I-type only for ADDI)
//
assign imm = {{20{instr[31]}}, instr[31:20]};

//
// ALU input mux
//
assign alu_b = (alu_src) ? imm : rdata2;

//
// Module Instantiations
//

pc pc_inst (

    .clk(clk),
    .rst(rst),

    .next_pc(next_pc),

    .pc_out(pc)

);

imem imem_inst (

    .addr(pc),

    .instr(instr)

);

decoder decoder_inst (

    .instr(instr),

    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)

);

control_unit control_inst (

    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),

    .reg_write(reg_write),
    .alu_src(alu_src),

    .alu_sel(alu_sel)

);

regfile regfile_inst (

    .clk(clk),
    .rst(rst),

    .we(reg_write),

    .waddr(rd),
    .wdata(alu_result),

    .raddr1(rs1),
    .raddr2(rs2),

    .rdata1(rdata1),
    .rdata2(rdata2)

);

alu alu_inst (

    .a(rdata1),
    .b(alu_b),

    .alu_sel(alu_sel),

    .result(alu_result),
    .zero(zero)

);

endmodule