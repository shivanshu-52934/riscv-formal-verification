module alu_formal;

logic [31:0] a;
logic [31:0] b;
logic [2:0] alu_sel;

logic [31:0] result;
logic zero;

alu dut (
    .a(a),
    .b(b),
    .alu_sel(alu_sel),
    .result(result),
    .zero(zero)
);

always_comb begin

    if (alu_sel == 3'b000)
        assert(result == a + b);

    if (alu_sel == 3'b001)
        assert(result == a - b);

    if (alu_sel == 3'b010)
        assert(result == (a & b));

    if (alu_sel == 3'b011)
        assert(result == (a | b));

    if (alu_sel == 3'b100)
        assert(result == (a ^ b));

end

endmodule