###############################################################################
# Created by write_sdc
# Fri Aug 29 07:27:20 2025
###############################################################################
current_design async_fifo
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name wr_clk -period 10.0000 [get_ports {wr_clk}]
set_propagated_clock [get_clocks {wr_clk}]
create_clock -name rd_clk -period 12.5000 [get_ports {rd_clk}]
set_propagated_clock [get_clocks {rd_clk}]
set_clock_groups -name group1 -asynchronous \
 -group [get_clocks {rd_clk}]\
 -group [get_clocks {wr_clk}]
set_input_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_en}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[0]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[1]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[2]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[3]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[4]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[5]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[6]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_data[7]}]
set_input_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_en}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[0]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[1]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[2]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[3]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[4]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[5]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[6]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_data[7]}]
set_output_delay 0.0000 -clock [get_clocks {rd_clk}] -add_delay [get_ports {rd_empty}]
set_output_delay 0.0000 -clock [get_clocks {wr_clk}] -add_delay [get_ports {wr_full}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
