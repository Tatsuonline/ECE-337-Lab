// $Id: $mg68
// File name:   adder_4bit.sv
// Created:     9/7/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 8-Bit Ripple Carry Adder

module adder_8bit
(
	input wire [7:0] a,
	input wire [7:0] b,
	input wire carry_in,
	output wire [7:0] sum,
	output wire overflow
);


   	adder_nbit #(8) DUT(.a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));
   
endmodule
