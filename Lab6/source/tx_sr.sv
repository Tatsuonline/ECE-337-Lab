// $Id: $mg68
// File name:   tx_sr.sv
// Created:     10/9/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Transmitting Shift Register

module tx_sr
(
  input wire clk,
  input wire n_rst,
  input wire falling_edge_found,
  input wire tx_enable,
  input wire [7:0] tx_data,
  input wire load_data,
  
  output reg tx_out
);

reg tx_shift_enabler;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    tx_shift_enabler <= 1'b0;
  end else begin
    tx_shift_enabler <= tx_enable & falling_edge_found;
  end
end
   
flex_pts_sr #(8,1) PTS_SHIFT_REGISTER
(
  	.clk(clk),
  	.n_rst(n_rst),
  	.shift_enable(tx_shift_enabler),
  	.load_enable(load_data),
  	.parallel_in(tx_data),
  	.serial_out(tx_out)
);
  
endmodule
