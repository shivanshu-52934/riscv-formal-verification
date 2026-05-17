module pc_tb;

logic clk;
logic rst;

logic [31:0] next_pc;
logic [31:0] pc_out;

pc dut (

    .clk(clk),
    .rst(rst),

    .next_pc(next_pc),

    .pc_out(pc_out)

);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    next_pc = 0;

    #10;

    rst = 0;

    next_pc = 4;
    #10;

    $display("PC = %0d", pc_out);

    next_pc = 8;
    #10;

    $display("PC = %0d", pc_out);

    next_pc = 12;
    #10;

    $display("PC = %0d", pc_out);

    $finish;

end

endmodule