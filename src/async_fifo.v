module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  wire                     wr_clk,
    input  wire                     wr_rst,
    input  wire                     wr_en,
    input  wire [DATA_WIDTH-1:0]    wr_data,
    output wire                     wr_full,

    input  wire                     rd_clk,
    input  wire                     rd_rst,
    input  wire                     rd_en,
    output reg  [DATA_WIDTH-1:0]    rd_data,   // <-- now registered
    output wire                     rd_empty
);
    localparam DEPTH = 1 << ADDR_WIDTH;

    // ---------------------------------------------------------
    // Storage
    // ---------------------------------------------------------
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // ---------------------------------------------------------
    // Binary & Gray pointers (ADDR_WIDTH+1 to detect wrap)
    // ---------------------------------------------------------
    reg  [ADDR_WIDTH:0] wr_ptr, rd_ptr;
    reg  [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;

    // Next (incremented) binary/Gray pointers
    wire [ADDR_WIDTH:0] wr_ptr_bin_next = wr_ptr + 1'b1;
    wire [ADDR_WIDTH:0] rd_ptr_bin_next = rd_ptr + 1'b1;

    // Binary to Gray
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    wire [ADDR_WIDTH:0] wr_ptr_gray_next = bin2gray(wr_ptr_bin_next);
    wire [ADDR_WIDTH:0] rd_ptr_gray_next = bin2gray(rd_ptr_bin_next);

    // ---------------------------------------------------------
    // 2-flop synchronizers for CDC
    // ---------------------------------------------------------
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;

    // ---------------------------------------------------------
    // Status flags
    // ---------------------------------------------------------
    assign wr_full =
        (wr_ptr_gray_next == {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
                               rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});

    assign rd_empty = (rd_ptr_gray == wr_ptr_gray_sync2);

    // ---------------------------------------------------------
    // WRITE DOMAIN
    // ---------------------------------------------------------
    always @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            wr_ptr      <= { (ADDR_WIDTH+1){1'b0} };
            wr_ptr_gray <= { (ADDR_WIDTH+1){1'b0} };
        end else begin
            if (wr_en && !wr_full) begin
                mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
                wr_ptr      <= wr_ptr_bin_next;
                wr_ptr_gray <= wr_ptr_gray_next;
            end
        end
    end

    // Synchronize READ pointer into WRITE domain
    always @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            rd_ptr_gray_sync1 <= { (ADDR_WIDTH+1){1'b0} };
            rd_ptr_gray_sync2 <= { (ADDR_WIDTH+1){1'b0} };
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // ---------------------------------------------------------
    // READ DOMAIN
    // ---------------------------------------------------------
    always @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            rd_ptr      <= { (ADDR_WIDTH+1){1'b0} };
            rd_ptr_gray <= { (ADDR_WIDTH+1){1'b0} };
            rd_data     <= {DATA_WIDTH{1'b0}};   // reset data
        end else begin
            if (rd_en && !rd_empty) begin
                rd_data     <= mem[rd_ptr[ADDR_WIDTH-1:0]]; // <-- registered
                rd_ptr      <= rd_ptr_bin_next;
                rd_ptr_gray <= rd_ptr_gray_next;
            end
        end
    end

    // Synchronize WRITE pointer into READ domain
    always @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            wr_ptr_gray_sync1 <= { (ADDR_WIDTH+1){1'b0} };
            wr_ptr_gray_sync2 <= { (ADDR_WIDTH+1){1'b0} };
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

endmodule
