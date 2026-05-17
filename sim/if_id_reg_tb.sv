module if_id_reg_tb;

logic clk;
logic rst;

logic [31:0] if_pc;
logic [31:0] if_instr;

logic [31:0] id_pc;
logic [31:0] id_instr;

if_id_reg dut (

    .clk(clk),
    .rst(rst),

    .if_pc(if_pc),
    .if_instr(if_instr),

    .id_pc(id_pc),
    .id_instr(id_instr)

);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    if_pc = 0;
    if_instr = 32'h00500093;

    #10;

    rst = 0;

    #10;

    $display("ID PC    = %0d", id_pc);
    $display("ID INSTR = %h", id_instr);

    if_pc = 4;
    if_instr = 32'h00A00113;

    #10;

    $display("ID PC    = %0d", id_pc);
    $display("ID INSTR = %h", id_instr);

    $finish;

end

endmodule