// $Id: $mg68
// File name:   rcu.sv
// Created:     9/25/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Receiver Control Unit

module rcu (

input wire clk,
input wire n_rst,
input wire start_bit_detected,
input wire packet_done,
input wire framing_error,

output reg sbc_clear,
output reg sbc_enable, 
output reg load_buffer, 
output reg enable_timer

);
  
  typedef enum bit [2:0] {framing_error_check, data_accept, stop_bit_check,/* eidle, */load_data, idle} state_type;
   state_type state;
   state_type nextstate;
  
/*   reg clearTheSBC;
   reg enableTheSBC;
   reg loadTheBuffer;
   reg enableTheTimer; */

   always @ (posedge clk, negedge n_rst) begin : Reset_Logic
      
     if(n_rst == 1'b0) begin
       state <= idle;
      end else begin
       state <= nextstate;
    /*   sbc_clear <= clearTheSBC;
       sbc_enable <= enableTheSBC;
       load_buffer <= loadTheBuffer;
       enable_timer <= enableTheTimer; */
     end
      
  end

  always_comb begin : State_Logic
    nextstate = state;
     
    case(state)
      
      idle: begin
         if (start_bit_detected == 1'b0) begin
            nextstate = idle;
         end else begin
            nextstate = data_accept;
         end
	   end

     framing_error_check: begin
      if (framing_error == 1'b0) begin
            nextstate = load_data;
         end else begin
            nextstate = idle;
         end

      end
      
      data_accept: begin
      	 if (packet_done == 1'b0) begin
      	    nextstate = data_accept;
      	 end else begin
      	    nextstate = stop_bit_check;
      	 end
      end
      	       
      stop_bit_check: begin
      	 nextstate = framing_error_check;
     end

      load_data: begin
            nextstate = idle;
      end
            
/*      eidle: begin
         if (framing_error == 1'b0) begin
            nextstate = idle;
         end else begin
            nextstate = eidle;
         end
      end
  */                  
  endcase
end
  
   always @ (state) begin : Register_Logic
    
      case(state)
       
	idle: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b0;
	end

  framing_error_check: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b1;
  end
      
	data_accept: begin 
           sbc_clear = 1'b1; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b1;
  end

  stop_bit_check: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b1;
           load_buffer = 1'b0; enable_timer = 1'b1;
  end

  load_data: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b1; enable_timer = 1'b0;
  end

  /*eidle: begin 
           sbc_clear = 1'b1; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b0;
  end */

	default: begin
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b0;
	end

      endcase
   end
   
endmodule
