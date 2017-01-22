// $Id: $mg68
// File name:   adder_4bit.sv
// Created:     9/7/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 4-Bit Ripple Carry Adder

module adder_4bit
(

 input wire [3:0]a,
 input wire [3:0]b,
 input wire carry_in,
 output wire [3:0]sum,
 output wire overflow

);

   /* adder_1bit I00 (.a(a[0]), .b(b[0]), .carry_in(carry_in), .sum(sum[0]), .carry_out(carrys[0]));
      adder_1bit I01 (.a(a[1]), .b(b[1]), .carry_in(carrys[0]), .sum(sum[1]), .carry_out(carrys[1]));
      adder_1bit I02 (.a(a[2]), .b(b[2]), .carry_in(carrys[1]), .sum(sum[2]), .carry_out(carrys[2])); */	  

    wire [4:0] carrys;
    genvar i;

    assign carrys[0] = carry_in;
    generate
       for (i = 0; i <= 3; i = i + 1)
	 begin
	    adder_1bit DUT (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
	 end
    endgenerate
    assign overflow = carrys[4];
   
		      
endmodule // adder_4bit
