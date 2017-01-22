// $Id: $mg68
// File name:   sda_sel.sv
// Created:     10/4/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Selects the value for sda_out.

module sda_sel
(
	input tx_out,
	input [1:0] sda_mode,

	output sda_out
);

assign sda_out = (sda_mode == 2'b00) ? 1'b1 : ((sda_mode == 2'b01) ? 1'b0 : ((sda_mode == 2'b10) ? 1'b1 : tx_out));

endmodule
