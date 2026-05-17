module alu_tb;

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

initial begin

    a = 10;
    b = 5;

    alu_sel = 3'b000; #10;
    $display("ADD Result = %0d", result);

    alu_sel = 3'b001; #10;
    $display("SUB Result = %0d", result);

    alu_sel = 3'b010; #10;
    $display("AND Result = %0d", result);

    alu_sel = 3'b011; #10;
    $display("OR Result = %0d", result);

    alu_sel = 3'b100; #10;
    $display("XOR Result = %0d", result);

    $finish;

end

endmodule