
# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# Clock groups
set_clock_groups -asynchronous -group [get_clocks {spiclk}] -group [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[*]]

# SDRAM delays
set_input_delay -clock [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[1]] -reference_pin ${RAM_CLK} -max 6.4 [get_ports ${RAM_IN}]
set_input_delay -clock [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[1]] -reference_pin ${RAM_CLK} -min 3.2 [get_ports ${RAM_IN}]

set_output_delay -clock [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[1]] -reference_pin ${RAM_CLK} -max 1.5 [get_ports ${RAM_OUT}]
set_output_delay -clock [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[1]] -reference_pin ${RAM_CLK} -min -0.8 [get_ports ${RAM_OUT}]

# Some relaxed constrain to the VGA pins. The signals should arrive together, the delay is not really important.
set_output_delay -clock [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]] -max 0 [get_ports {VGA_*}]
set_output_delay -clock [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]] -min -5 [get_ports {VGA_*}]
set_multicycle_path -to [get_ports {VGA_*}] -setup 5
set_multicycle_path -to [get_ports {VGA_*}] -hold 5

set_multicycle_path -to ${topmodule}video|video_mixer|sd|Hq2x|* -setup 6
set_multicycle_path -to ${topmodule}video|video_mixer|sd|Hq2x|* -hold 6

set_multicycle_path -from ${topmodule}cpu|u0|* -setup 2
set_multicycle_path -from ${topmodule}cpu|u0|* -hold 2

set_multicycle_path -to ${topmodule}psg|outmix*|* -setup 2
set_multicycle_path -to ${topmodule}psg|outmix*|* -hold 2
set_multicycle_path -to ${topmodule}sid|adsr|* -setup 2
set_multicycle_path -to ${topmodule}sid|adsr|* -hold 2

set_multicycle_path -from [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[1]] -to [get_clocks ${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]] -setup -end 2

# Don't bother optimizing sigma_delta_dac
set_false_path -to ${FALSE_OUT}
set_false_path -from ${FALSE_IN}
