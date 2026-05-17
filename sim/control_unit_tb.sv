module control_unit_tb;

logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;

logic reg_write;
logic alu_src;
logic [2:0] alu_sel;

control_unit dut (

    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),

    .reg_write(reg_write),
    .alu_src(alu_src),
    .alu_sel(alu_sel)

);

initial begin

    // ADD
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;

    #10;

    $display("ADD:");
    $display("reg_write = %0d", reg_write);
    $display("alu_src   = %0d", alu_src);
    $display("alu_sel   = %0d", alu_sel);

    // SUB
    funct7 = 7'b0100000;

    #10;

    $display("SUB:");
    $display("alu_sel   = %0d", alu_sel);

    // ADDI
    opcode = 7'b0010011;

    #10;

    $display("ADDI:");
    $display("reg_write = %0d", reg_write);
    $display("alu_src   = %0d", alu_src);
    $display("alu_sel   = %0d", alu_sel);

    $finish;

end

endmodule