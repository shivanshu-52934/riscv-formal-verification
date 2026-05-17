module regfile (

    input  logic        clk,
    input  logic        rst,

    input  logic        we,

    input  logic [4:0]  waddr,
    input  logic [31:0] wdata,

    input  logic [4:0]  raddr1,
    input  logic [4:0]  raddr2,

    output logic [31:0] rdata1,
    output logic [31:0] rdata2

);

logic [31:0] regs [31:0];

integer i;

always_ff @(posedge clk) begin

    if (rst) begin

        for (i = 0; i < 32; i = i + 1)
            regs[i] <= 32'b0;

    end

    else begin

        if (we && (waddr != 5'd0))
            regs[waddr] <= wdata;

        regs[0] <= 32'b0;

    end

end

assign rdata1 = regs[raddr1];
assign rdata2 = regs[raddr2];

endmodule