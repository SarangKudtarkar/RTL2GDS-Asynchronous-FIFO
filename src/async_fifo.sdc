# ============================================================
# Constraints for async_fifo
# ============================================================

# Define write clock (frequency depends on your system, adjust period)
create_clock -name wr_clk -period 10.0 [get_ports wr_clk]

# Define read clock (frequency depends on your system, adjust period)
create_clock -name rd_clk -period 12.5 [get_ports rd_clk]

# Set input delays (assuming no external delays, adjust as needed)
set_input_delay  0 -clock wr_clk [get_ports {wr_en wr_data[*]}]
set_input_delay  0 -clock rd_clk [get_ports {rd_en}]

# Set output delays (assuming no external delays, adjust as needed)
set_output_delay 0 -clock wr_clk [get_ports wr_full]
set_output_delay 0 -clock rd_clk [get_ports {rd_data[*] rd_empty}]

# ============================================================
# Handle asynchronous clock domains
# ============================================================

# The write and read clocks are asynchronous
set_clock_groups -asynchronous -group {wr_clk} -group {rd_clk}

# Alternatively, can use false paths explicitly:
# set_false_path -from [get_clocks wr_clk] -to [get_clocks rd_clk]
# set_false_path -from [get_clocks rd_clk] -to [get_clocks wr_clk]

# ============================================================
# End of async_fifo.sdc
# ============================================================
