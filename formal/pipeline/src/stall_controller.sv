module stall_controller (

    input logic clk,
    input logic rst,

    //
    // Hazard detected?
    //
    input logic hazard,

    //
    // Stall output
    //
    output logic stall

);

logic [1:0] stall_counter;

always_ff @(posedge clk) begin

    if (rst) begin

        stall_counter <= 0;

    end

    else begin

        //
        // Start 2-cycle stall
        //
        if (hazard && (stall_counter == 0))

            stall_counter <= 2;

        //
        // Countdown
        //
        else if (stall_counter != 0)

            stall_counter <= stall_counter - 1;

    end

end

assign stall = (stall_counter != 0);

endmodule