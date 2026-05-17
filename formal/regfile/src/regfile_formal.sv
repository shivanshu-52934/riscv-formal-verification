module regfile_formal;

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

// Force reset initially
initial begin
    rst = 1;
end

// Basic invariant
always @(posedge clk) begin

    if (!rst)
        assert(dut.regs[0] == 32'd0);

end

endmodule