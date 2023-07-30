`timescale 1ns / 1ps
`default_nettype none

//    This file is part of the ZXUNO Spectrum core. 
//    Creation date is 21:14:58 2023-05-01 by Miguel Angel Rodriguez Jodar
//    (c)2014-2020 ZXUNO association.
//    ZXUNO official repository: http://svn.zxuno.com/svn/zxuno
//    Username: guest   Password: zxuno
//    Github repository for this core: https://github.com/mcleod-ideafix/zxuno_spectrum_core
//
//    ZXUNO Spectrum core is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    ZXUNO Spectrum core is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with the ZXUNO Spectrum core.  If not, see <https://www.gnu.org/licenses/>.
//
//    Any distributed copy of this file must keep this notice intact.

module tld (
  input  wire clk50mhz,
  //////////////////////////////////////////
  input  wire clkps2,
  input  wire dataps2,
  //////////////////////////////////////////  
  output wire audio_out_left,
  output wire audio_out_right,  
  output wire [1:0] led,
  //////////////////////////////////////////
  output wire i2s_bclk,
  output wire i2s_lrclk,
  output wire i2s_dout,  
  //////////////////////////////////////////
  output wire [5:0] vga_r,
  output wire [5:0] vga_g,
  output wire [5:0] vga_b,
  output wire vga_hs,
  output wire vga_vs,
  //////////////////////////////////////////
  output wire dp_tx_lane_p,
  output wire dp_tx_lane_n,
  input  wire dp_refclk_p,
  input  wire dp_refclk_n,
  input  wire dp_tx_hp_detect,
  inout  wire dp_tx_auxch_tx_p,
  inout  wire dp_tx_auxch_tx_n,
  inout  wire dp_tx_auxch_rx_p,
  inout  wire dp_tx_auxch_rx_n
  );
  
  wire clkvideo, clkpalntsc;
  wire video_r, video_g, video_b;  // para este ejemplo usaré RGB de 1 bit
  wire video_cs, video_hs, video_vs;
  
  relojes_mmcm relojes (
    .CLK_IN1(clk50mhz),
    .CLK_OUT1(clkvideo),
    .CLK_OUT2(clkpalntsc),
    .reset(1'b0),
    .locked()
  );
  
  wire [15:0] audio_l, audio_r;
  audio_source #(.CLKMHZ(14)) pitido (clkvideo, audio_l, audio_r); 
  
  ///////////////////////////////////////////////////
  // Manejo del core por teclado
  ///////////////////////////////////////////////////
  wire       new_key;
  wire [7:0] scancode;
  wire       key_released, key_extended;

  reg        video_output_sel = 1;
  reg        disable_scanlines = 1;
  reg [1:0] monochrome_sel = 0;
  
  ps2_port el_teclado (
      .clk(clkvideo),  // se recomienda 1 MHz <= clk <= 600 MHz
      .enable_rcv(1'b1),  // habilitar la maquina de estados de recepcion
      .kb_or_mouse(1'b0),  // 0: kb, 1: mouse
      .ps2clk_ext(clkps2),
      .ps2data_ext(dataps2),
      .kb_interrupt(new_key),  // a 1 durante 1 clk para indicar nueva tecla recibida
      .scancode(scancode), // make o breakcode de la tecla
      .released(key_released),  // soltada=1, pulsada=0
      .extended(key_extended)  // extendida=1, no extendida=0
      );
  
  always @(posedge clkvideo) begin
    if (new_key == 1'b1 && key_released == 1'b0 && key_extended == 1'b0) begin
      case (scancode)
        'h16: video_output_sel <= ~video_output_sel;    // tecla 1
        'h1E: disable_scanlines <= ~disable_scanlines;  // tecla 2 
        'h26: monochrome_sel <= (monochrome_sel == 3)? 0 : monochrome_sel + 1;  // tecla 3
      endcase
    end
  end
  
  video_704x288_3bpp_50hz_pal video_original (
    .clk(clkvideo),
    .r(video_r),
    .g(video_g),
    .b(video_b),
    .hsync_n(video_hs),
    .vsync_n(video_vs),
    .csync_n(video_cs)
  );
  
  vga_dp_framescaler #(.HSTART(113), .VSTART(43), .CLKVIDEO(14)) scaler (
  .clkvideo(clkvideo),                    // reloj de pixel de la señal de video original (generada por el core)
  .enclkvideo(1'b1),                      // si el reloj anterior es mayor que el reloj de pixel, y se necesita un clock enable
  .clkpalntsc(clkpalntsc),                // Reloj de 100 MHz para la generacion del reloj de color PAL o NTSC
  .reset(1'b0),                           // Reset de todo el módulo (reset a nivel alto)
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  .video_output_sel(video_output_sel),    // 0: RGB 15kHz + DP   1: VGA + DP pantalla azul
  .disable_scaneffect(disable_scanlines), // 0: emular scanlines (cuidado con el policía del retro!)  1: sin scanlines
  .monochrome_sel(monochrome_sel),        // 0 : RGB, 1: fósforo verde, 2: fósforo ámbar, 3: escala de grises
  .encoder_sel(1'b0),                     // Reloj de color. 0 : PAL, 1: NTSC
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .ri(video_r),            // el numero de bits de cada una de estas señales depende del generador de video de entrada. 
  .gi(video_g),            // Podria no ser siquiera RGB, sino una entrada de paleta a un color fijo (Commodore, Spectrum).
  .bi(video_b),            // Si es paleta programable (Amstrad, SAM Coupé, ULAplus...), entonces sí que usaremos RGB
  .hsync_ext_n(video_hs),  // Sincronismo horizontal y vertical separados. Los necesito separados para poder, dentro del módulo
  .vsync_ext_n(video_vs),  // medir cuándo comienza y termina un scan y un frame, y así centrar la imagen en el framebuffer
  .csync_ext_n(video_cs),  // entrada de sincronismo compuesto de la señal original
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  .audio_l(audio_l),
  .audio_r(audio_r),
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
  .dp_ready(led[0]),
  .dp_heartbeat(led[1])
  );
endmodule

`default_nettype wire