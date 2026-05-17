module imem_tb;

logic [31:0] addr;
logic [31:0] instr;

imem dut (

    .addr(addr),
    .instr(instr)

);

initial begin

    addr = 0;
    #10;

    $display("Instruction @0  = %h", instr);

    addr = 4;
    #10;

    $display("Instruction @4  = %h", instr);

    addr = 8;
    #10;

    $display("Instruction @8  = %h", instr);

    addr = 12;
    #10;

    $display("Instruction @12 = %h", instr);

    $finish;

end

endmodule