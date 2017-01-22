// $Id: $mg68
// File name:   rx_sr.sv
// Created:     10/9/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Serial to Parallel Shift Register

module rx_sr
(
  input wire clk,
  input wire n_rst,
  input wire sda_in,
  input wire rising_edge_found,
  input wire rx_enable,
  output reg [7:0] rx_data
);

reg rx_shift_enabler;

always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
    rx_shift_enabler <= 1'b0;
  end else begin
    rx_shift_enabler <= rx_enable & rising_edge_found;
  end
end
  
flex_stp_sr #(8,1) STP_SHIFT_REGISTER
(
	.clk(clk),
  	.n_rst(n_rst),
  	.shift_enable(rx_shift_enabler),
  	.serial_in(sda_in),
  	.parallel_out(rx_data)
);
  
endmodule
