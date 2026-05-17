module if_id_reg (

    input logic clk,
    input logic rst,

    input logic stall,

    input logic [31:0] if_pc,
    input logic [31:0] if_instr,

    output logic [31:0] id_pc,
    output logic [31:0] id_instr

);

always_ff @(posedge clk) begin

    if (rst) begin

        id_pc    <= 32'd0;
        id_instr <= 32'd0;

    end

    //
    // Freeze IF/ID during stall
    //
    else if (!stall) begin

        id_pc    <= if_pc;
        id_instr <= if_instr;

    end

end

endmodule