// $Id: $mg68, $mg69
// File name:   controller.sv
// Created:     Unknown
// Author:      Tatsu, CrocKim
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: The controller controls all the individual blocks and makes them run on time.

module controller
  (
   input reg 	    clk, n_rst, clear, baseline_done,
   input reg	    controller_enable,
   input reg        roll20f,
   output reg	    baseline_enable, shift_enable, cnt20_en
   );
   
   typedef enum bit [2:0] {PTP20, BASELINE ,IDLE} state;
   state next_s;
   state cur_s;

   reg shift_en;
   reg baseline_en;

   always_ff @ (posedge clk, negedge n_rst) begin
      if(1'b0 == n_rst) begin
	 cur_s=IDLE;     	 
      end	                
      else begin
	 cur_s=next_s;
      end      
    end      
 
  always_comb 
  begin
	 next_s=cur_s;
	 case(cur_s)
	   IDLE: begin
	      if(controller_enable) begin
	         next_s=PTP20;
	      end
	      else begin
	         next_s=IDLE;
	      end
	   end
	   
	   PTP20 : begin
	      if(roll20f) begin
		 next_s=BASELINE;
	      end
	      else begin
		 next_s=PTP20;
	      end
	   end
   
	   BASELINE: begin
	      if(baseline_done) begin
	         next_s=IDLE;
	      end
	      else begin
	         next_s=BASELINE;	 
	      end
	   end	   
	   ///////////////////////////////////////////
	 endcase 
  end
      
  always @ (cur_s)
    begin 
  case(cur_s)
	IDLE: begin	 
	 baseline_en=0; shift_en=0; cnt20_en=0;
	end
    
	PTP20: begin	 
 	 baseline_en=0; shift_en=1; cnt20_en=1;
	end
    
	BASELINE: begin
	 baseline_en=1; shift_en=0;  cnt20_en=0;
	end				
	
	default: begin
	 baseline_en=0; shift_en=0;  cnt20_en=0;
	  end	  

      endcase
   end

   assign baseline_enable=baseline_en;
   assign shift_enable=shift_en;

   

   


endmodule // controller

