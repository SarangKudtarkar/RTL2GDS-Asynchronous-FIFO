`timescale 1ns/1ps

module async_fifo_tb;

  localparam DATA_WIDTH = 8;
  localparam ADDR_WIDTH = 4;
  localparam DEPTH      = 1 << ADDR_WIDTH;

  // DUT ports
  reg                   wr_clk, wr_rst, wr_en;
  reg  [DATA_WIDTH-1:0] wr_data;
  wire                  wr_full;

  reg                   rd_clk, rd_rst, rd_en;
  wire [DATA_WIDTH-1:0] rd_data;
  wire                  rd_empty;

  // Instantiate DUT
  async_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
    .wr_clk   (wr_clk),
    .wr_rst   (wr_rst),
    .wr_en    (wr_en),
    .wr_data  (wr_data),
    .wr_full  (wr_full),

    .rd_clk   (rd_clk),
    .rd_rst   (rd_rst),
    .rd_en    (rd_en),
    .rd_data  (rd_data),
    .rd_empty (rd_empty)
  );

  // Clock generation
  initial wr_clk = 0;
  always  #5 wr_clk = ~wr_clk;   // 100 MHz

  initial rd_clk = 0;
  always  #7 rd_clk = ~rd_clk;   // ~71 MHz

  // Test procedure
  integer i;
  reg [DATA_WIDTH-1:0] expected;

  initial begin
    // VCD dump
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);

    // Init
    wr_rst = 1;
    rd_rst = 1;
    wr_en  = 0;
    rd_en  = 0;
    wr_data = 0;

    // Release resets
    #20;
    wr_rst = 0;
    rd_rst = 0;

    // --------------------------------------------------------
    // WRITE PHASE
    // --------------------------------------------------------
    $display("[%0t] Starting writes...", $time);
    for (i = 0; i < 8; i = i+1) begin
      @(posedge wr_clk);
      if (!wr_full) begin
        wr_data = i;
        wr_en   = 1;
        $display("[%0t] WRITE %0d", $time, wr_data);
      end
    end
    @(posedge wr_clk);
    wr_en = 0;

    // Small gap before reads
    #50;

    // --------------------------------------------------------
    // READ PHASE
    // --------------------------------------------------------
    $display("[%0t] Starting reads...", $time);
    for (i = 0; i < 8; i = i+1) begin
      expected = i;
      @(posedge rd_clk);
      if (!rd_empty) begin
        rd_en = 1;               // issue read
      end
      @(posedge rd_clk);          // wait one cycle for data
      rd_en = 0;
      if (rd_data !== expected)
        $display("[%0t] ERROR: Expected %0d, got %0d", $time, expected, rd_data);
      else
        $display("[%0t] OK: Read %0d", $time, rd_data);
    end

    // --------------------------------------------------------
    // FINISH
    // --------------------------------------------------------
    #100;
    $display("[%0t] TESTBENCH FINISHED", $time);
    $finish;
  end

endmodule
