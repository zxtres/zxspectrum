set_property PACKAGE_PIN M6 [get_ports sd_clk]
set_property PACKAGE_PIN T4 [get_ports flash_clk]
# Pines y estandares de niveles logicos
#Clock
set_property PACKAGE_PIN Y18 [get_ports clk50mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk50mhz]

#Leds y Botones
set_property PACKAGE_PIN H13 [get_ports testled]
set_property IOSTANDARD LVCMOS33 [get_ports testled]
set_property PACKAGE_PIN G15 [get_ports testled2]
set_property IOSTANDARD LVCMOS33 [get_ports testled2]
#set_property PACKAGE_PIN G15 [get_ports BTN]
#set_property IOSTANDARD LVCMOS33 [get_ports BTN]
#set_property PULLUP true [get_ports BTN]

#Keyboard and mouse
set_property PACKAGE_PIN U1 [get_ports clkps2]
set_property IOSTANDARD LVCMOS33 [get_ports clkps2]
set_property PULLUP true [get_ports clkps2]
set_property PACKAGE_PIN T1 [get_ports dataps2]
set_property IOSTANDARD LVCMOS33 [get_ports dataps2]
set_property PACKAGE_PIN P4 [get_ports mouseclk]
set_property IOSTANDARD LVCMOS33 [get_ports mouseclk]
set_property PULLUP true [get_ports dataps2]
set_property PACKAGE_PIN N5 [get_ports mousedata]
set_property PULLUP true [get_ports mousedata]
set_property IOSTANDARD LVCMOS33 [get_ports mousedata]

# Video output
set_property PACKAGE_PIN V18 [get_ports vga_hs]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hs]
set_property PACKAGE_PIN P19 [get_ports vga_vs]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vs]
set_property PACKAGE_PIN W21 [get_ports {vga_b[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[7]}]
set_property PACKAGE_PIN W19 [get_ports {vga_b[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[6]}]
set_property PACKAGE_PIN AA20 [get_ports {vga_b[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[5]}]
set_property PACKAGE_PIN Y21 [get_ports {vga_b[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[4]}]
set_property PACKAGE_PIN AB21 [get_ports {vga_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[3]}]
set_property PACKAGE_PIN T20 [get_ports {vga_b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN T6 [get_ports {vga_b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN U5 [get_ports {vga_b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[0]}]

set_property PACKAGE_PIN W17 [get_ports {vga_r[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[7]}]
set_property PACKAGE_PIN AA19 [get_ports {vga_r[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[6]}]
set_property PACKAGE_PIN AB20 [get_ports {vga_r[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[5]}]
set_property PACKAGE_PIN V20 [get_ports {vga_r[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[4]}]
set_property PACKAGE_PIN Y19 [get_ports {vga_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[3]}]
set_property PACKAGE_PIN P20 [get_ports {vga_r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN T5 [get_ports {vga_r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN R6 [get_ports {vga_r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[0]}]

set_property PACKAGE_PIN W22 [get_ports {vga_g[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[7]}]
set_property PACKAGE_PIN AA21 [get_ports {vga_g[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[6]}]
set_property PACKAGE_PIN Y22 [get_ports {vga_g[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[5]}]
set_property PACKAGE_PIN AB22 [get_ports {vga_g[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[4]}]
set_property PACKAGE_PIN W20 [get_ports {vga_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[3]}]
set_property PACKAGE_PIN V17 [get_ports {vga_g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN V4 [get_ports {vga_g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN V5 [get_ports {vga_g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[0]}]

#Audio
set_property PACKAGE_PIN V19 [get_ports audio_out_left]
set_property IOSTANDARD LVCMOS33 [get_ports audio_out_left]
set_property PACKAGE_PIN U17 [get_ports audio_out_right]
set_property IOSTANDARD LVCMOS33 [get_ports audio_out_right]
set_property PACKAGE_PIN B1 [get_ports ear]
set_property IOSTANDARD LVCMOS33 [get_ports ear]

set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS33} [get_ports i2s_bclk]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports i2s_lrclk]
set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports i2s_dout]

#Joystick
set_property PACKAGE_PIN V2 [get_ports joy_clk]
set_property IOSTANDARD LVCMOS33 [get_ports joy_clk]
set_property PACKAGE_PIN U2 [get_ports joy_load_n]
set_property IOSTANDARD LVCMOS33 [get_ports joy_load_n]
set_property PACKAGE_PIN W2 [get_ports joy_data]
set_property IOSTANDARD LVCMOS33 [get_ports joy_data]

#SRAM
set_property PACKAGE_PIN U18 [get_ports {sram_addr[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[0]}]
set_property PACKAGE_PIN AB18 [get_ports {sram_addr[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[1]}]
set_property PACKAGE_PIN P15 [get_ports {sram_addr[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[2]}]
set_property PACKAGE_PIN T18 [get_ports {sram_addr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[3]}]
set_property PACKAGE_PIN R17 [get_ports {sram_addr[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[4]}]
set_property PACKAGE_PIN P14 [get_ports {sram_addr[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[5]}]
set_property PACKAGE_PIN AB3 [get_ports {sram_addr[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[6]}]
set_property PACKAGE_PIN Y3 [get_ports {sram_addr[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[7]}]
set_property PACKAGE_PIN R14 [get_ports {sram_addr[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[8]}]
set_property PACKAGE_PIN T3 [get_ports {sram_addr[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[9]}]
set_property PACKAGE_PIN P16 [get_ports {sram_addr[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[10]}]
set_property PACKAGE_PIN AA3 [get_ports {sram_addr[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[11]}]
set_property PACKAGE_PIN P17 [get_ports {sram_addr[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[12]}]
set_property PACKAGE_PIN AB2 [get_ports {sram_addr[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[13]}]
set_property PACKAGE_PIN AA18 [get_ports {sram_addr[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[14]}]
set_property PACKAGE_PIN Y2 [get_ports {sram_addr[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[15]}]
set_property PACKAGE_PIN Y1 [get_ports {sram_addr[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[16]}]
set_property PACKAGE_PIN W1 [get_ports {sram_addr[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[17]}]
set_property PACKAGE_PIN V3 [get_ports {sram_addr[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[18]}]
set_property PACKAGE_PIN G2 [get_ports {sram_addr[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_addr[19]}]

set_property PACKAGE_PIN N17 [get_ports {sram_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[0]}]
set_property PACKAGE_PIN AA5 [get_ports {sram_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[1]}]
set_property PACKAGE_PIN N14 [get_ports {sram_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[2]}]
set_property PACKAGE_PIN N13 [get_ports {sram_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[3]}]
set_property PACKAGE_PIN R16 [get_ports {sram_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[4]}]
set_property PACKAGE_PIN AA1 [get_ports {sram_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[5]}]
set_property PACKAGE_PIN AB1 [get_ports {sram_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[6]}]
set_property PACKAGE_PIN U3 [get_ports {sram_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[7]}]
set_property PACKAGE_PIN N2 [get_ports {sram_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[8]}]
set_property PACKAGE_PIN P2 [get_ports {sram_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[9]}]
set_property PACKAGE_PIN P1 [get_ports {sram_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[10]}]
set_property PACKAGE_PIN R1 [get_ports {sram_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[11]}]
set_property PACKAGE_PIN K6 [get_ports {sram_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[12]}]
set_property PACKAGE_PIN L1 [get_ports {sram_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[13]}]
set_property PACKAGE_PIN M1 [get_ports {sram_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[14]}]
set_property PACKAGE_PIN K4 [get_ports {sram_data[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sram_data[15]}]

set_property PACKAGE_PIN N15 [get_ports sram_we_n]
set_property IOSTANDARD LVCMOS33 [get_ports sram_we_n]

set_property PACKAGE_PIN E1 [get_ports sram_oe_n]
set_property IOSTANDARD LVCMOS33 [get_ports sram_oe_n]

set_property PACKAGE_PIN U20 [get_ports sram_ub_n]
set_property IOSTANDARD LVCMOS33 [get_ports sram_ub_n]
set_property PACKAGE_PIN N4 [get_ports sram_lb_n]
set_property IOSTANDARD LVCMOS33 [get_ports sram_lb_n]

#SD
set_property IOSTANDARD LVCMOS33 [get_ports sd_clk]
set_property PACKAGE_PIN L5 [get_ports sd_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports sd_cs_n]
set_property PACKAGE_PIN M5 [get_ports sd_miso]
set_property IOSTANDARD LVCMOS33 [get_ports sd_miso]
set_property PULLUP true [get_ports sd_miso]
set_property PACKAGE_PIN L4 [get_ports sd_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports sd_mosi]

#UART
set_property PACKAGE_PIN N3 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property PACKAGE_PIN D1 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property PACKAGE_PIN H5 [get_ports uart_rts]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rts]
set_property PACKAGE_PIN J2 [get_ports uart_gpio0]
set_property IOSTANDARD LVCMOS33 [get_ports uart_gpio0]
set_property PACKAGE_PIN L6 [get_ports uart_reset]
set_property IOSTANDARD LVCMOS33 [get_ports uart_reset]

#I2C
set_property PACKAGE_PIN Y7 [get_ports i2c_sda]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_sda]
set_property PULLUP true [get_ports i2c_sda]
set_property PACKAGE_PIN AB6 [get_ports i2c_scl]
set_property IOSTANDARD LVCMOS33 [get_ports i2c_scl]
set_property PULLUP true [get_ports i2c_scl] 

#MIDI
set_property PACKAGE_PIN Y8 [get_ports midi_wsbd]
set_property IOSTANDARD LVCMOS33 [get_ports midi_wsbd]
set_property PACKAGE_PIN AA8 [get_ports midi_clkbd]
set_property IOSTANDARD LVCMOS33 [get_ports midi_clkbd]
set_property PACKAGE_PIN AB8 [get_ports midi_dabd]
set_property IOSTANDARD LVCMOS33 [get_ports midi_dabd]
set_property PACKAGE_PIN AB7 [get_ports midi_out]
set_property IOSTANDARD LVCMOS33 [get_ports midi_out]

#Flash SPI
set_property IOSTANDARD LVCMOS33 [get_ports flash_clk]
set_property PACKAGE_PIN T19 [get_ports flash_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports flash_cs_n]
set_property PACKAGE_PIN R22 [get_ports flash_miso]
set_property IOSTANDARD LVCMOS33 [get_ports flash_miso]
set_property PULLUP true [get_ports flash_miso]
set_property PACKAGE_PIN P22 [get_ports flash_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports flash_mosi]
set_property PACKAGE_PIN P21 [get_ports flash_wp]
set_property IOSTANDARD LVCMOS33 [get_ports flash_wp]
set_property PACKAGE_PIN R21 [get_ports flash_hold]
set_property IOSTANDARD LVCMOS33 [get_ports flash_hold]

#
# SDRAM signals
#
#set_property PACKAGE_PIN G20 [get_ports sdram_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_clk]
#set_property PACKAGE_PIN H22 [get_ports sdram_cke]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_cke]

#set_property PACKAGE_PIN L21 [get_ports sdram_dqmh_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dqmh_n]
#set_property PACKAGE_PIN M18 [get_ports sdram_dqml_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dqml_n]

#set_property PACKAGE_PIN L18 [get_ports sdram_cas_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_cas_n]
#set_property PACKAGE_PIN K19 [get_ports sdram_ras_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_ras_n]
#set_property PACKAGE_PIN J17 [get_ports sdram_we_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_we_n]
#set_property PACKAGE_PIN N22 [get_ports sdram_cs_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_cs_n]

#set_property PACKAGE_PIN H20 [get_ports sdram_ba[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_ba[1]]
#set_property PACKAGE_PIN J19 [get_ports sdram_ba[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_ba[0]]

#set_property PACKAGE_PIN J22 [get_ports sdram_addr[12]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[12]]
#set_property PACKAGE_PIN J15 [get_ports sdram_addr[11]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[11]]
#set_property PACKAGE_PIN K21 [get_ports sdram_addr[10]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[10]]
#set_property PACKAGE_PIN H15 [get_ports sdram_addr[9]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[9]]
#set_property PACKAGE_PIN G18 [get_ports sdram_addr[8]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[8]]
#set_property PACKAGE_PIN G17 [get_ports sdram_addr[7]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[7]]
#set_property PACKAGE_PIN H14 [get_ports sdram_addr[6]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[6]]
#set_property PACKAGE_PIN J14 [get_ports sdram_addr[5]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[5]]
#set_property PACKAGE_PIN G16 [get_ports sdram_addr[4]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[4]]
#set_property PACKAGE_PIN J20 [get_ports sdram_addr[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[3]]
#set_property PACKAGE_PIN J21 [get_ports sdram_addr[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[2]]
#set_property PACKAGE_PIN K22 [get_ports sdram_addr[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[1]]
#set_property PACKAGE_PIN H19 [get_ports sdram_addr[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_addr[0]]

#set_property PACKAGE_PIN M13 [get_ports sdram_dq[0]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[0]]
#set_property PACKAGE_PIN L13 [get_ports sdram_dq[1]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[1]]
#set_property PACKAGE_PIN L16 [get_ports sdram_dq[2]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[2]]
#set_property PACKAGE_PIN M15 [get_ports sdram_dq[3]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[3]]
#set_property PACKAGE_PIN K16 [get_ports sdram_dq[4]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[4]]
#set_property PACKAGE_PIN L14 [get_ports sdram_dq[5]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[5]]
#set_property PACKAGE_PIN K17 [get_ports sdram_dq[6]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[6]]
#set_property PACKAGE_PIN K14 [get_ports sdram_dq[7]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[7]]
#set_property PACKAGE_PIN M21 [get_ports sdram_dq[8]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[8]]
#set_property PACKAGE_PIN M22 [get_ports sdram_dq[9]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[9]]
#set_property PACKAGE_PIN N19 [get_ports sdram_dq[10]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[10]]
#set_property PACKAGE_PIN M20 [get_ports sdram_dq[11]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[11]]
#set_property PACKAGE_PIN N18 [get_ports sdram_dq[12]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[12]]
#set_property PACKAGE_PIN N20 [get_ports sdram_dq[13]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[13]]
#set_property PACKAGE_PIN M16 [get_ports sdram_dq[14]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[14]]
#set_property PACKAGE_PIN L15 [get_ports sdram_dq[15]]
#set_property IOSTANDARD LVCMOS33 [get_ports sdram_dq[15]]

