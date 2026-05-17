module regfile_tb;

logic clk;
logic rst;

logic we;

logic [4:0] waddr;
logic [31:0] wdata;

logic [4:0] raddr1;
logic [4:0] raddr2;

logic [31:0] rdata1;
logic [31:0] rdata2;

regfile dut (

    .clk(clk),
    .rst(rst),

    .we(we),

    .waddr(waddr),
    .wdata(wdata),

    .raddr1(raddr1),
    .raddr2(raddr2),

    .rdata1(rdata1),
    .rdata2(rdata2)

);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    we = 0;

    #10;
    rst = 0;

    // Write 55 into x5
    we = 1;
    waddr = 5;
    wdata = 55;

    #10;

    // Read x5
    raddr1 = 5;

    #10;

    $display("x5 = %0d", rdata1);

    // Try writing x0
    waddr = 0;
    wdata = 999;

    #10;

    raddr1 = 0;

    #10;

    $display("x0 = %0d", rdata1);

    $finish;

end

endmodule