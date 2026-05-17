module ex_wb_reg (

    input logic clk,
    input logic rst,

    //
    // Inputs from EX stage
    //
    input logic        ex_reg_write,
    input logic [4:0]  ex_rd,
    input logic [31:0] ex_result,

    //
    // Outputs to WB stage
    //
    output logic        wb_reg_write,
    output logic [4:0]  wb_rd,
    output logic [31:0] wb_result

);

always_ff @(posedge clk) begin

    if (rst) begin

        wb_reg_write <= 0;
        wb_rd        <= 0;
        wb_result    <= 0;

    end

    else begin

        wb_reg_write <= ex_reg_write;
        wb_rd        <= ex_rd;
        wb_result    <= ex_result;

    end

end

endmodule