// $Id: $mg68
// File name:   decode.sv
// Created:     10/5/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Detects START and STOP conditions, plus device address.

module decode
(
	input wire clk,
	input wire n_rst,
	input wire scl,
	input wire sda_in,
	input wire [7:0] starting_byte,

	output reg rw_mode,
	output reg address_match,
	output reg stop_found,
	output reg start_found
);

	reg sclRegister1;
	reg sclRegister2;
	reg sdaRegister1;
	reg sdaRegister2;

	reg rw_mode_reg;
	reg address_match_reg;
	reg stop_found_reg;
	reg start_found_reg;

	always @ (posedge clk, negedge n_rst) 
	begin

		if (n_rst == 1'b0) begin
			sclRegister1 <= 1'b0;
			sclRegister2 <= 1'b0;
			sdaRegister1 <= 1'b0;
			sdaRegister2 <= 1'b0;
			rw_mode_reg <= 1'b0;
			address_match_reg <= 1'b0;
			start_found_reg <= 1'b0;
			stop_found_reg <= 1'b0;
		end else begin
			sclRegister1 <= scl;
			sclRegister2 <= sclRegister1;
			sdaRegister1 <= sda_in;
			sdaRegister2 <= sdaRegister1;
			rw_mode_reg <= starting_byte[0];
			address_match_reg <= (starting_byte[7:1] == 7'b1111000) ? 1'b1 : 1'b0;
			start_found_reg <= (sclRegister1 && sclRegister2 && !sdaRegister1 && sdaRegister2) ? 1'b1 : 1'b0;
			stop_found_reg <= (sclRegister1 && sclRegister2 && sdaRegister1 && !sdaRegister2) ? 1'b1 : 1'b0;
		end
		
	end

	assign rw_mode = rw_mode_reg;
	assign address_match = address_match_reg;
	assign start_found = start_found_reg;
	assign stop_found = stop_found_reg;

endmodule
