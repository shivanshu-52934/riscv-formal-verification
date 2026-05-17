module cpu_pipeline_tb;

logic clk;
logic rst;

cpu_pipeline dut (

    .clk(clk),
    .rst(rst)

);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    #10;

    rst = 0;

    // Run pipeline long enough
    #150;

    $display("x1 = %0d", dut.regfile_inst.regs[1]);
    $display("x2 = %0d", dut.regfile_inst.regs[2]);
    $display("x3 = %0d", dut.regfile_inst.regs[3]);

    $finish;

end

endmodule