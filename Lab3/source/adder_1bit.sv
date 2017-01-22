// $Id: $mg68
// File name:   adder_1bit.sv
// Created:     9/5/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 1-bit Full Adder Design

`timescale 1ns / 100ps

module adder_1bit
(
 input wire a,
 input wire b,
 input wire carry_in,
 output wire sum,
 output wire carry_out
 );

/*   wire aXorB;
   wire bOrA;
   wire carryAdded;
   wire bAndA;
   wire cInBA;
   

   xor firstXor (aXorB, a, b); // a xor b
   xor secondXor (sum, carry_in, aXorB); // carry_in xor aXorB
   or firstOr (bOrA, b, a); // a or b
   and firstAnd (carryAdded, carry_in, bOrA); // carry_in and bOrA
   and secondAnd (bAndA, b, a); // b and a
   and thirdAnd (cInBA, bAndA, !carry_in); // !carry_in and bAndA
   or secondOr (carry_out, cInBA, carryAdded);
   
*/

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
	       else $error("Input 'a' of component is not a digital logic value");
	  end

/* Not necessary, apparently.   
 
 always @ (a, b, carry_in)
     begin
	#(2) assert(((a + b + carry_in) % 2) == sum)
	  else $error("Output 's' of first 1 bit adder is not correct");
	end
*/
   assign sum = carry_in ^ (a ^ b);
   assign carry_out = ((!carry_in) && b && a) || (carry_in && (b || a));
 
   
endmodule // adder_1bit
