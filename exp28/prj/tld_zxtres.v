`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:28:18 02/06/2014 
// Design Name: 
// Module Name:    test1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tld_zxtres (
   input wire clk50mhz,

   output wire [5:0] vga_r,
   output wire [5:0] vga_g,
   output wire [5:0] vga_b,
   output wire vga_hs,
   output wire vga_vs,
   input wire ear,
   inout wire clkps2,
   inout wire dataps2,
   inout wire mouseclk,
   inout wire mousedata,
   output wire audio_out_left,
   output wire audio_out_right,
   
   output wire [19:0] sram_addr,
   inout wire [7:0] sram_data,
   output wire sram_we_n,
   
   output wire flash_cs_n,
   output wire flash_clk,
   output wire flash_mosi,
   input wire flash_miso,
   output wire flash_wp,
   output wire flash_hold,
   
   output wire uart_tx,
   input wire uart_rx,
   output wire uart_rts,
   output wire uart_reset,
   output wire uart_gpio0,
   
   input wire joy_data,
   output wire joy_clk,
   output wire joy_load_n,
   
   output wire i2s_bclk,
   output wire i2s_lrclk,
   output wire i2s_dout,  
   
   output wire sd_cs_n,    
   output wire sd_clk,     
   output wire sd_mosi,    
   input wire sd_miso,
   
   output wire dp_tx_lane_p,
   output wire dp_tx_lane_n,
   input wire  dp_refclk_p,
   input wire  dp_refclk_n,
   input wire  dp_tx_hp_detect,
   inout wire  dp_tx_auxch_tx_p,
   inout wire  dp_tx_auxch_tx_n,
   inout wire  dp_tx_auxch_rx_p,
   inout wire  dp_tx_auxch_rx_n,   
   
   output wire testled,   // nos servirá como testigo de uso de la SPI
   output wire testled2
   );

   wire sysclk, clk_icap, clkpalntsc;
   wire pll_locked;
   
   //clock_generator relojes_maestros
   relojes_mmcm relojes_maestros
   (// Clock in ports
    .CLK_IN1            (clk50mhz),
    // Clock out ports
    .CLK_OUT1           (clkpalntsc),
    .CLK_OUT2           (sysclk),
    .CLK_OUT3           (clk_icap),
    
    .reset(1'b0),
    .locked(pll_locked)
    );

   wire [2:0] ri, gi, bi;
	 wire [1:0] monochrome_switcher;
	 wire [1:0] interlace_mode;
   wire hsync_pal, vsync_pal, csync_pal;   
   
	 wire wifi_switcher;
   wire campo_imagen, interlaced_image;
   wire [20:0] sram_addr_2mb;
   assign sram_addr = sram_addr_2mb[19:0];
   
   wire vga_enable, scanlines_enable, clk14en;
   wire [1:0] ula_mode;
   wire [8:0] ula_hcont, ula_vcont;
   
   wire [15:0] audio_left, audio_right;
   
   wire enable_gencolorclk, color_mode;
   
   wire joy1up, joy1down, joy1left, joy1right, joy1fire1, joy1fire2, joy1fire3;
   wire joy2up, joy2down, joy2left, joy2right, joy2fire1, joy2fire2;

   reg [19:0] espera_reset = 20'h00000;
   reg reset_core_n = 1'b0;
   always @(posedge sysclk) begin
     reset_core_n <= (espera_reset == 20'hFFFFF);
     if (pll_locked == 1'b0 && reset_core_n == 1'b0)
       espera_reset <= 20'h00000;
     else if (espera_reset != 20'hFFFFF)
       espera_reset <= espera_reset + 1;
   end      

   zxuno #(.MASTERCLK(28000000), .FPGA_MODEL(3'b011)) la_maquina (
    .sysclk(sysclk),
    .clk_icap(clk_icap),
    .power_on_reset_n(reset_core_n),
    .r(ri),
    .g(gi),
    .b(bi),
    .hsync(hsync_pal),
    .vsync(vsync_pal),
    .csync(csync_pal),
    .vrampage(campo_imagen),
    .monochrome_switcher(monochrome_switcher),
    .interlace_mode(interlace_mode),
    
    .clkps2(clkps2),
    .dataps2(dataps2),
    .ear_ext(ear),
    .audio_left(audio_left),
    .audio_right(audio_right),

    .midi_out(),
    .clkbd(1'b0),
    .wsbd(1'b0),
    .dabd(1'b0),    
  
    .uart_tx(uart_tx),
    .uart_rx(uart_rx),
    .uart_rts(uart_rts),

    .sram_addr(sram_addr_2mb),
    .sram_data(sram_data),
    .sram_we_n(sram_we_n),
    
    .flash_cs_n(flash_cs_n),
    .flash_clk(flash_clk),
    .flash_di(flash_mosi),
    .flash_do(flash_miso),
                                                   
    .sd_cs_n(sd_cs_n),
    .sd_clk(sd_clk),
    .sd_mosi(sd_mosi),
    .sd_miso(sd_miso),
    
    .joy1up(joy1up),
    .joy1down(joy1down),
    .joy1left(joy1left),
    .joy1right(joy1right),
    .joy1fire1(joy1fire1),
    .joy1fire2(joy1fire2),    
  
    .joy2up(joy2up),
    .joy2down(joy2down),
    .joy2left(joy2left),
    .joy2right(joy2right),
    .joy2fire1(joy2fire1),
    .joy2fire2(joy2fire2),  
    
    .joy1fire3(joy1fire3),  

    .mouseclk(mouseclk),
    .mousedata(mousedata),
    
    .vga_enable(vga_enable),
    .scanlines_enable(scanlines_enable),
    .freq_option(),
    .clk14en_tovga(clk14en),
    .ula_mode(ula_mode),
    .ula_hcont(ula_hcont),
    .ula_vcont(ula_vcont),
    
    .ad724_xtal(),
    .ad724_mode(color_mode),
    .ad724_enable_gencolorclk(enable_gencolorclk)
    );

  zxtres_wrapper #(.CLKVIDEO(28)) cosas_del_zxtres (
  .clkvideo(sysclk),                      // reloj de pixel de la señal de video original (generada por el core)
  .enclkvideo(clk14en),                   // si el reloj anterior es mayor que el reloj de pixel, y se necesita un clock enable
  .clkpalntsc(clkpalntsc),                // Reloj de 100 MHz para la generacion del reloj de color PAL o NTSC
  .reset_n(reset_core_n),                   // Reset de todo el módulo
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  .video_output_sel(vga_enable),          // 0: RGB 15kHz + DP   1: VGA + DP
  .disable_scanlines(~scanlines_enable),  // 0: emular scanlines (cuidado con el policía del retro!)  1: sin scanlines
  .monochrome_sel(monochrome_switcher),   // 0 : RGB, 1: fósforo verde, 2: fósforo ámbar, 3: escala de grises
  .interlace_mode(interlace_mode),
  .field(campo_imagen),
  .interlaced_image(interlaced_image),
  .ad724_modo(color_mode),                // Modo de video para el reloj de color. 0 : PAL, 1: NTSC
  .ad724_clken(enable_gencolorclk),       // Habilita el uso del generador interno de CLK de color
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .ri({ri,ri,ri[2:1]}),            // RGB de 24 bits aunque  
  .gi({gi,gi,gi[2:1]}),            // después haya que guardar 
  .bi({bi,bi,bi[2:1]}),            // menos bits (dep. de la BRAM usada)
  .hsync_ext_n(hsync_pal),  // Sincronismo horizontal y vertical separados. Los necesito separados para poder, dentro del módulo
  .vsync_ext_n(vsync_pal),  // medir cuándo comienza y termina un scan y un frame, y así centrar la imagen en el framebuffer
  .csync_ext_n(csync_pal),  // entrada de sincronismo compuesto de la señal original
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .ula_mode(ula_mode),     // Señales específicas para el uso de este
  .ula_hcont(ula_hcont),   // core de ZX Spectrum. Estas señales son las
  .ula_vcont(ula_vcont),   // que sincronizan la ULA con el framescaler
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////    
  .audio_l(audio_left),
  .audio_r(audio_right),
  .i2s_bclk(i2s_bclk),
  .i2s_lrclk(i2s_lrclk),
  .i2s_dout(i2s_dout),
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .ro(vga_r),         // Salida RGB de VGA 
  .go(vga_g),         // o de 15 kHz, según el valor
  .bo(vga_b),         // de video_output_sel
  .hsync(vga_hs),     // Para RGB 15 kHz, aqui estará el sincronismo compuesto
  .vsync(vga_vs),     // Para RGB 15 kHz, de momento se queda al valor 1, pero aquí luego irá el reloj de color x4
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .sd_audio_l(audio_out_left),
  .sd_audio_r(audio_out_right),
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .joy_data(joy_data),
  .joy_latch_megadrive(1'b1),
  .joy_clk(joy_clk),
  .joy_load_n(joy_load_n),
  .joy1up(joy1up),
  .joy1down(joy1down),
  .joy1left(joy1left),
  .joy1right(joy1right),
  .joy1fire1(joy1fire1),
  .joy1fire2(joy1fire2),
  .joy1fire3(joy1fire3),
  .joy1start(),
  .joy2up(joy2up),
  .joy2down(joy2down),
  .joy2left(joy2left),
  .joy2right(joy2right),
  .joy2fire1(joy2fire1),
  .joy2fire2(joy2fire2),
  .joy2fire3(),
  .joy2start(),    
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .dp_tx_lane_p(dp_tx_lane_p),          // De los dos lanes de la Artix 7, solo uso uno.
  .dp_tx_lane_n(dp_tx_lane_n),          // Cada lane es una señal diferencial. Esta es la parte negativa.
  .dp_refclk_p(dp_refclk_p),            // Reloj de referencia para los GPT. Siempre es de 135 MHz
  .dp_refclk_n(dp_refclk_n),            // El reloj también es una señal diferencial.
  .dp_tx_hp_detect(dp_tx_hp_detect),    // Indica que se ha conectado un monitor DP. Arranca todo el proceso de entrenamiento
  .dp_tx_auxch_tx_p(dp_tx_auxch_tx_p),  // Señal LVDS de salida (transmisión)
  .dp_tx_auxch_tx_n(dp_tx_auxch_tx_n),  // del canal AUX. En alta impedancia durante la recepción
  .dp_tx_auxch_rx_p(dp_tx_auxch_rx_p),  // Señal LVDS de entrada (recepción)
  .dp_tx_auxch_rx_n(dp_tx_auxch_rx_n),   // del canal AUX. Siempre en alta impedancia ya que por aquí no se transmite nada.
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .dp_ready(),
  .dp_heartbeat()
  );

  assign testled = ~(sd_cs_n & flash_cs_n);
  assign testled2 = interlaced_image;
   
  assign flash_wp = 1'b1;
  assign flash_hold = 1'b1;
   
  assign uart_reset = 1'b1;
  assign uart_gpio0 = 1'b1;   
endmodule
