// $Id: $mg68
// File name:   adder_16bit.sv
// Created:     9/9/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 16-Bit Adder

`timescale 1ns / 100ps

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

	// STUDENT: Fill in the correct port map with parameter override syntax for using your n-bit ripple carry adder design to be an 8-bit ripple carry adder design

    always @ (a)
	  begin
	     assert((a == 1'b1) || (a == 1'b0))
	       else $error("Input 'a' of component is not a digital logic value");
	  end

    always @ (b)
	  begin
	     assert((b == 1'b1) || (b == 1'b0))
	       else $error("Input 'b' of component is not a digital logic value");
	  end

    always @ (carry_in)
	  begin
	     assert((carry_in == 1'b1) || (carry_in == 1'b0))
	       else $error("Input 'carry_in' of component is not a digital logic value");
	  end

   always @ (a, b, carry_in)
     begin
	#(2) assert(((a + b + carry_in) % 65536) == sum)
	  else $error("Output 's' of first 1 bit adder is not correct");
     end

   always @ (a, b, carry_in)
     begin
	#(2) assert(((a + b + carry_in) / 65536) == overflow)
	  else $error("Output 'o' of first 1 bit adder is not correct");
     end

   	adder_nbit #(16) DUT(.a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));
   
endmodule
