// $Id: $mg68
// File name:   mealy.sv
// Created:     9/21/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Mealy Machine '1101' Detector Design

module mealy (input wire clk, input wire n_rst, input wire i, output reg o);

   typedef enum bit [3:0] {st_state1, st_state2, st_state3, st_state4} stateType; // Names of the different states.
   stateType state; // Current state.
   stateType nxt_state; // Next state.
   
   
   always_ff @ (negedge n_rst, posedge clk)
     begin : REG_LOGIC // Not sure why?
	if(1'b0 == n_rst)
	  state <= st_state1; // Resets to first state.
	else begin
	  state <= nxt_state; // Otherwise, continues to the next state.  
	end
     end
   
   always_comb
     begin : NXT_LOGIC
	nxt_state = state; // By default.
	o = 1'b0; // Output '0' just to be safe.
	
	case(state)
	  
	  st_state1:
	    begin
	       //o = 1'b0;
	       if (i == 1) begin
		  nxt_state = st_state2;
	       end else begin
		  nxt_state = st_state1;
	       end
	    end
	  
	  st_state2:
	    begin
	       //o = 1'b0;
	       if (i == 1) begin
		  nxt_state = st_state3;
	       end else begin
		  nxt_state = st_state1;
	       end
	    end
	  
	  st_state3:
	    begin
	       //o = 1'b0;
	       if (i == 0) begin
		  nxt_state = st_state4;
	       end else begin
		  nxt_state = st_state3;
	       end
	    end
	  
	  st_state4:
	    begin
	      //o = 1'b0;
	        if (i == 1) begin
		  nxt_state = st_state2;
		  o = 1'b1;
	       end else begin
		  nxt_state = st_state1;
	       end
	    end

/*	   st_state5:
	     begin
	       //o = 1'b1;
		if (i == 1) begin
		   nxt_state = st_state3;
		end else begin
		   nxt_state = st_state1;
		end
	     end
 */	
	endcase // case (state)
     end // block: NXT_LOGIC

  // assign o = (sexyCool == 1'b1) ? 1 : 0;
   
endmodule // moore
