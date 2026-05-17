module forwarding_unit (

    //
    // Source registers from current instruction
    //
    input logic [4:0] rs1,
    input logic [4:0] rs2,

    //
    // Destination register from EX stage
    //
    input logic [4:0] ex_rd,

    //
    // EX-stage write enable
    //
    input logic ex_reg_write,

    //
    // Forwarding control outputs
    //
    output logic forward_a,
    output logic forward_b

);

always_comb begin

    //
    // Default: no forwarding
    //
    forward_a = 0;
    forward_b = 0;

    //
    // Forward for rs1
    //
    if (ex_reg_write &&
        (ex_rd != 0) &&
        (ex_rd == rs1))

        forward_a = 1;

    //
    // Forward for rs2
    //
    if (ex_reg_write &&
        (ex_rd != 0) &&
        (ex_rd == rs2))

        forward_b = 1;

end

endmodule