`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:50:06 22/05/2021 
// Design Name: 
// Module Name:    monochrome
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

module monochrome6b (
  input wire [1:0] monochrome_selection,
  input wire [2:0] ri,
  input wire [2:0] gi,
  input wire [2:0] bi,
  output reg [5:0] ro,
  output reg [5:0] go,
  output reg [5:0] bo  
  );

  wire [5:0] r6b = {ri,ri};
  wire [5:0] g6b = {gi,gi};
  wire [5:0] b6b = {bi,bi};
  
  wire [12:0] grisp = r6b*7'd38 + g6b*7'd75 + b6b * 7'd15;
  wire [5:0] gris = grisp[12:7];
  always @* begin
    case (monochrome_selection)
      2'b00:
        begin
          ro = r6b;
          go = g6b;
          bo = b6b;
        end 
      2'b01:
        begin
          ro = 6'h00;
          go = gris;
          bo = 6'h00;
        end
      2'b10:
        begin
          ro = gris;
          go = {1'b0,gris[5:1]};
          bo = 6'h00;
        end
      2'b11:
        begin
          ro = gris;
          go = gris;
          bo = gris;
        end
      default:
        begin
          ro = r6b;
          go = g6b;
          bo = b6b;
        end 
    endcase
  end  
endmodule
