`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: AZXUNO
// Engineer: Miguel Angel Rodriguez Jodar
// 
// Create Date:    19:12:34 03/16/2017 
// Design Name:    
// Module Name:    config_retriever
// Project Name:   Modulo para extraer la configuracion inicial RGB-VGA de la SRAM
// Target Devices: ZXUNO Spartan 6
// Additional Comments: all rights reserved for now
//
//////////////////////////////////////////////////////////////////////////////////

module config_retriever (
  input  wire        clk,
  input  wire [20:0] sram_addr_in,
  input  wire        sram_we_n_in,
  output wire [20:0] sram_addr_out,
  output wire        sram_we_n_out,
  input  wire [7:0]  din,
  output wire        pwon_reset,
  output wire        vga_on,
  output wire        scanlines_on
  );
  
  reg [7:0] videoconfig = 8'h00;
  reg [31:0] shift_master_reset = 32'hFFFFFFFF;
  
  always @(posedge clk) begin
    shift_master_reset <= {shift_master_reset[30:0], 1'b0};
    if (shift_master_reset[16:15] == 2'b10)
      videoconfig <= din;
  end
  assign pwon_reset = shift_master_reset[63];
  
  assign sram_addr_out = (pwon_reset == 1'b1)? 21'h008FD5 : sram_addr_in;
  assign sram_we_n_out = (pwon_reset == 1'b1)? 1'b1       : sram_we_n_in;
  assign vga_on = videoconfig[0];
  assign scanlines_on = videoconfig[1];
endmodule
