module cpu_tb;

logic clk;
logic rst;

cpu dut (

    .clk(clk),
    .rst(rst)

);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    #10;

    rst = 0;

    // Run processor
    #50;

    $display("x1 = %0d", dut.regfile_inst.regs[1]);
    $display("x2 = %0d", dut.regfile_inst.regs[2]);
    $display("x3 = %0d", dut.regfile_inst.regs[3]);

    $finish;

end

endmodule