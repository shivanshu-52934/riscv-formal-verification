module id_ex_reg (

    input logic clk,
    input logic rst,

    //
    // Stall signal
    //
    input logic stall,

    //
    // Inputs from ID stage
    //
    input logic       id_reg_write,
    input logic       id_alu_src,
    input logic [2:0] id_alu_sel,

    input logic [31:0] id_rdata1,
    input logic [31:0] id_rdata2,
    input logic [31:0] id_imm,

    input logic [4:0] id_rd,

    //
    // Outputs to EX stage
    //
    output logic       ex_reg_write,
    output logic       ex_alu_src,
    output logic [2:0] ex_alu_sel,

    output logic [31:0] ex_rdata1,
    output logic [31:0] ex_rdata2,
    output logic [31:0] ex_imm,

    output logic [4:0] ex_rd

);

always_ff @(posedge clk) begin

    if (rst) begin

        ex_reg_write <= 0;
        ex_alu_src   <= 0;
        ex_alu_sel   <= 0;

        ex_rdata1 <= 0;
        ex_rdata2 <= 0;
        ex_imm    <= 0;

        ex_rd <= 0;

    end

    //
    // INSERT BUBBLE DURING STALL
    //
    else if (stall) begin

        ex_reg_write <= 0;
        ex_alu_src   <= 0;
        ex_alu_sel   <= 0;

        ex_rdata1 <= 0;
        ex_rdata2 <= 0;
        ex_imm    <= 0;

        ex_rd <= 0;

    end

    else begin

        ex_reg_write <= id_reg_write;
        ex_alu_src   <= id_alu_src;
        ex_alu_sel   <= id_alu_sel;

        ex_rdata1 <= id_rdata1;
        ex_rdata2 <= id_rdata2;
        ex_imm    <= id_imm;

        ex_rd <= id_rd;

    end

end

endmodule