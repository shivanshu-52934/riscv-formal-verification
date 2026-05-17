module imem (

    input  logic [31:0] addr,

    output logic [31:0] instr

);

always_comb begin

    case (addr)

        32'd0:  instr = 32'h00500093; // ADDI x1, x0, 5
        32'd4:  instr = 32'h00A00113; // ADDI x2, x0, 10
        32'd8:  instr = 32'h002081B3; // ADD x3, x1, x2

        default: instr = 32'h00000013; // NOP

    endcase

end

endmodule