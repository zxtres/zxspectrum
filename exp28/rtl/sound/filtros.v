`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2023 19:57:01
// Design Name: 
// Module Name: paso_baja
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module paso_baja (
  input wire clk,
  input wire clken,
  input wire [15:0] in,
  output reg [15:0] out
  );
  
  reg [15:0] xold = 0;
  wire [16:0] suma = (in + xold);
  always @(posedge clk) begin
    if (clken == 1'b1) begin
      xold <= in;
      out <= {suma[16], suma[16:2]};
    end
  end  
endmodule

module paso_alta (
  input wire clk,
  input wire clken,
  input wire [15:0] in,
  output reg [15:0] out
  );
  
  reg [15:0] xold, yold;
  
  always @(posedge clk) begin
    if (clken == 1'b1) begin
      xold <= in;
      out <= (256*(in - xold) + 253*yold)/256;
      yold <= (256*(in - xold) + 253*yold)/256;
    end
  end  
endmodule

`default_nettype wire
