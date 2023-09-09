#create_property iob port -type string

# Contraints de tiempo
create_clock -period 20.000 -name clk50mhz [get_ports clk50mhz]

#set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks dp_refclk]
#set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks dp_refclk]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_out2_clk_wiz_0]
set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks clk_out3_clk_wiz_0]
set_false_path -from [get_clocks clk_out3_clk_wiz_0] -to [get_clocks clk_out2_clk_wiz_0]
#set_false_path -from [get_clocks dp_refclk] -to [get_clocks tx_symbol_clk]
#set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks tx_symbol_clk]
set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks tx_symbol_clk]
set_false_path -from [get_clocks tx_symbol_clk] -to [get_clocks clk_out2_clk_wiz_0] 

# 3, 6, 9, 12, 16, 22, 26, 33, 40, 50, 66
set_property BITSTREAM.CONFIG.CONFIGRATE 6 [current_design]
set_property BITSTREAM.CONFIG.CCLKPIN PULLNONE [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_MODE SPIx1 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]
set_property BITSTREAM.CONFIG.M1PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M2PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M0PIN PULLNONE [current_design]

#set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]
#set_property BITSTREAM.CONFIG.NEXT_CONFIG_ADDR 0x0100000 [current_design]
