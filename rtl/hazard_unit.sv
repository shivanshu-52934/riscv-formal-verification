module hazard_unit (

    //
    // Current instruction source registers
    //
    input logic [4:0] rs1,
    input logic [4:0] rs2,

    //
    // Previous instruction destination register
    //
    input logic [4:0] ex_rd,

    //
    // Previous instruction writes register?
    //
    input logic ex_reg_write,

    //
    // Hazard output
    //
    output logic hazard

);

always_comb begin

    hazard = 0;

    if (ex_reg_write &&
        (ex_rd != 0) &&
        ((ex_rd == rs1) || (ex_rd == rs2)))

        hazard = 1;

end

endmodule