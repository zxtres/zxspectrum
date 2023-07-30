`timescale 1ns / 1ps
`default_nettype none

//    This file is part of the ZXUNO Spectrum core. 
//    Creation date is 01:12:01 2022-10-23 by Miguel Angel Rodriguez Jodar
//    (c)2014-2022 ZXUNO association.
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

module i2c_master (
    input wire clk,
    input wire rst_n,
    input wire [7:0] zxuno_addr,
    input wire zxuno_regrd,
    input wire zxuno_regwr,
    input wire [7:0] din,
    output reg [7:0] dout,
    output reg oe,
    output wire sck,
    inout wire sda
    );
    
    `include "../config/config.vh"
    
    reg rsck = 1'b1;
    reg rsda = 1'b1;
    
    assign sck = (rsck == 1'b1)? 1'bz : 1'b0;
    assign sda = (rsda == 1'b1)? 1'bz : 1'b0;
    
    always @(posedge clk) begin
      if (rst_n == 1'b0) begin
        rsck <= 1'b1;
        rsda <= 1'b1;
      end
      else if (zxuno_addr == I2CREG && zxuno_regwr == 1'b1)
        {rsck, rsda} <= din[1:0];
    end
    
    always @* begin
      dout = {sda, 7'b0000000};  // at bit 7, to be easily detectable with JP P / JP M
      if (zxuno_addr == I2CREG && zxuno_regrd == 1'b1)
        oe = 1'b1;
      else
        oe = 1'b0;
    end
endmodule
