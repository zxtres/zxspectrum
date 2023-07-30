`timescale 1ns / 1ps
`default_nettype none

//    This file is part of the ZXUNO Spectrum core. 
//    Creation date is 04:04:00 2012-04-01 by Miguel Angel Rodriguez Jodar
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

/*
The sound mix is controlled by port #F7 (sets the mix for the
currently selected PSG). There are two channels for the beeper.
When one channel is active the beeper is at the same volume level as
a single PSG channel at full volume. When both are active and have
the same pan it is then double the volume of a single PSG channel.
This approximates the relative loudness of the beeper on 128K
machines.

D6-7:	channel A
D4-5:	channel B
D3-2:	channel C 
D1-0:	channel D (beeper)

Panning is limited to switching a channel on or off for a given
speaker. The bits are decoded as follows:

00 = mute
10 = left
01 = right
11 = both

The default port value on reset is zero (all channels off).


Port #BB : control which devices should go on channel D
Bit position (when 1)
0 : beeper
1 : specdrum
2 : midi
3 : saa
4-7: reserved (should be 0)
*/

module panner_and_mixer (
  input wire clk,
  input wire mrst_n,
  input wire [7:0] a,
  input wire iorq_n,
  input wire rd_n,
  input wire wr_n,
  input wire [7:0] din,
  output reg [7:0] dout,
  output reg oe,
  //--- SOUND SOURCES ---
  input wire mic,
  input wire ear,
  input wire spk,
  input wire [7:0] ay1_cha,
  input wire [7:0] ay1_chb,
  input wire [7:0] ay1_chc,
  input wire [7:0] ay2_cha,
  input wire [7:0] ay2_chb,
  input wire [7:0] ay2_chc,
  input wire [8:0] specdrum_left,
  input wire [8:0] specdrum_right,
  input wire [15:0] midi_left,
  input wire [15:0] midi_right,
  input wire [ 7:0] saa_left,
  input wire [ 7:0] saa_right,
 
  // --- OUTPUTs ---
  output wire [15:0] output_left,
  output wire [15:0] output_right
  );

`include "../config/config.vh"

  // Register accepts data from CPU
  reg [7:0] mixer = 8'b10_01_11_11; // ACB mode, Specdrum and beeper on both channels
  reg [7:0] chan_d = 8'b0000_1111; // all devices for channel D present
  
  always @(posedge clk) begin
    if (mrst_n == 1'b0)
      mixer <= 8'b10_01_11_11;
    else if (a == AUDIOMIXER && iorq_n == 1'b0 && wr_n == 1'b0)
      mixer <= din;
    else if (a == AUDIODEVSD && iorq_n == 1'b0 && wr_n == 1'b0)
      chan_d <= din;
  end
   
  // CPU reads register
  always @* begin
    oe = 1'b0;
    dout = 8'hFF;    
    if (iorq_n == 1'b0 && rd_n == 1'b0) begin
      if (a == AUDIOMIXER) begin
        oe = 1'b1;
        dout = mixer;
      end
      else if (a == AUDIODEVSD) begin
        oe = 1'b1;
        dout = chan_d;
      end
    end
  end
   
  // Mixer for EAR, MIC and SPK
  reg [7:0] beeper;
  always @(posedge clk) begin
    case ({ear,spk,mic})
      3'b000: beeper <= 8'd0;
      3'b001: beeper <= 8'd36;
      3'b010: beeper <= 8'd184;
      3'b011: beeper <= 8'd192;
      3'b100: beeper <= 8'd64;
      3'b101: beeper <= 8'd100;
      3'b110: beeper <= 8'd248;
      3'b111: beeper <= 8'd255;      
    endcase
  end
  
  reg [15:0] mixleft = 16'h0000;
  reg [15:0] mixright = 16'h0000;
  reg [8:0] left, right;

  reg [15:0] ay1_cha_signed, ay1_chb_signed, ay1_chc_signed;
  reg [15:0] ay2_cha_signed, ay2_chb_signed, ay2_chc_signed;
  reg [15:0] ay_cha_signed, ay_chb_signed, ay_chc_signed; 
  reg [15:0] beeper_signed, specdrum_left_signed, specdrum_right_signed;
  reg [15:0] midi_left_signed, midi_right_signed;
  reg [15:0] saa_left_signed, saa_right_signed;
  always @(posedge clk) begin
    // extender a 16 bits con signo
    ay1_cha_signed  <= {{5{~ay1_cha[7]}}, ay1_cha[6:0], 4'b0000};
    ay2_cha_signed  <= {{5{~ay2_cha[7]}}, ay2_cha[6:0], 4'b0000};

    ay1_chb_signed  <= {{5{~ay1_chb[7]}}, ay1_chb[6:0], 4'b0000};
    ay2_chb_signed  <= {{5{~ay2_chb[7]}}, ay2_chb[6:0], 4'b0000};

    ay1_chc_signed  <= {{5{~ay1_chc[7]}}, ay1_chc[6:0], 4'b0000};
    ay2_chc_signed  <= {{5{~ay2_chc[7]}}, ay2_chc[6:0], 4'b0000};
    
    ay_cha_signed <= ay1_cha_signed + ay2_cha_signed;
    ay_chb_signed <= ay1_chb_signed + ay2_chb_signed;
    ay_chc_signed <= ay1_chc_signed + ay2_chc_signed;
    
    beeper_signed   <= {{5{~beeper[7]}}, beeper[6:0], 4'b0000};
    
    specdrum_left_signed  <= {{3{specdrum_left[8]}}, specdrum_left, 4'b0000};   // Ya viene 
    specdrum_right_signed <= {{3{specdrum_right[8]}}, specdrum_right, 4'b0000}; // con signo
    
    midi_left_signed <= midi_left;   // Ya viene
    midi_right_signed <= midi_right; // con signo
    
    saa_left_signed  <= {{3{~saa_left[7]}}, saa_left[6:0], 6'b000000};
    saa_right_signed <= {{3{~saa_right[7]}}, saa_right[6:0], 6'b000000};
    
    mixleft  <= ((mixer[7])? ay_cha_signed : 16'h0000 ) +
                ((mixer[5])? ay_chb_signed : 16'h0000 ) +
                ((mixer[3])? ay_chc_signed : 16'h0000 ) +
                ((mixer[1])? beeper_signed + midi_left_signed + specdrum_left_signed + saa_left_signed: 16'h0000 );
    mixright <= ((mixer[6])? ay_cha_signed : 16'h0000 ) +
                ((mixer[4])? ay_chb_signed : 16'h0000 ) +
                ((mixer[2])? ay_chc_signed : 16'h0000 ) +
                ((mixer[0])? beeper_signed + midi_right_signed + specdrum_right_signed + saa_right_signed: 16'h0000 );
  end

  assign output_left = mixleft;
  assign output_right = mixright;

endmodule

`default_nettype wire