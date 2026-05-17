`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  pipeline_formal UUT (

  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    // UUT.$auto$async2sync.\cc:107:execute$513  = 1'b0;
    // UUT.$auto$async2sync.\cc:107:execute$531  = 1'b0;
    // UUT.$auto$async2sync.\cc:107:execute$537  = 1'b0;
    // UUT.$auto$async2sync.\cc:116:execute$517  = 1'b1;
    // UUT.$auto$async2sync.\cc:116:execute$523  = 1'b1;
    // UUT.$auto$async2sync.\cc:116:execute$529  = 1'b1;
    // UUT.$auto$async2sync.\cc:116:execute$535  = 1'b1;
    // UUT.$auto$async2sync.\cc:116:execute$541  = 1'b1;
    UUT._witness_.anyinit_procdff_471 = 1'b1;
    UUT._witness_.anyinit_procdff_472 = 1'b1;
    UUT._witness_.anyinit_procdff_473 = 1'b1;
    UUT._witness_.anyinit_procdff_474 = 1'b1;

    // state 0
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
