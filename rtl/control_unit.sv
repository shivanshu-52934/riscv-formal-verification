module control_unit (

    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic       reg_write,
    output logic       alu_src,

    output logic [2:0] alu_sel

);

always_comb begin

    // Default values
    reg_write = 0;
    alu_src   = 0;
    alu_sel   = 3'b000;

    case (opcode)

        // R-type instructions
        7'b0110011: begin

            reg_write = 1;
            alu_src   = 0;

            case ({funct7, funct3})

                10'b0000000000: alu_sel = 3'b000; // ADD
                10'b0100000000: alu_sel = 3'b001; // SUB

                default: alu_sel = 3'b000;

            endcase

        end

        // ADDI
        7'b0010011: begin

            reg_write = 1;
            alu_src   = 1;

            alu_sel = 3'b000;

        end

        default: begin

            reg_write = 0;
            alu_src   = 0;
            alu_sel   = 3'b000;

        end

    endcase

end

endmodule