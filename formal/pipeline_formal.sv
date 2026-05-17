module pipeline_formal;

logic clk;
logic rst;

//
// DUT
//
cpu_pipeline dut (

    .clk(clk),
    .rst(rst)

);

//
// PROPERTY 1:
// Never write to x0
//
always @(posedge clk) begin

    assert(!(dut.wb_reg_write && (dut.wb_rd == 0)));

end

//
// PROPERTY 2:
// During stall, PC must remain stable
//
always @(posedge clk) begin

    if (!rst && dut.stall)

        assert($stable(dut.pc_inst.pc_out));

end

//
// PROPERTY 3:
// During stall, IF/ID register must remain stable
//
always @(posedge clk) begin

    if (!rst && dut.stall) begin

        assert($stable(dut.if_id_inst.id_instr));
        assert($stable(dut.if_id_inst.id_pc));

    end

end

//
// PROPERTY 4:
// Bubble insertion correctness
//
always @(posedge clk) begin

    if (!rst && $past(dut.stall))

        assert(dut.id_ex_inst.ex_reg_write == 0);

end

endmodule