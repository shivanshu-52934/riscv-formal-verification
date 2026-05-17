module decoder_tb;

logic [31:0] instr;

logic [6:0] opcode;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;

decoder dut (

    .instr(instr),

    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)

);

initial begin

    // ADD x3, x1, x2
    instr = 32'h002081B3;

    #10;

    $display("opcode = %b", opcode);
    $display("rd      = %0d", rd);
    $display("funct3  = %b", funct3);
    $display("rs1     = %0d", rs1);
    $display("rs2     = %0d", rs2);
    $display("funct7  = %b", funct7);

    $finish;

end

endmodule