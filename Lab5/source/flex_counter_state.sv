// $Id: $mg68
// File name:   flex_counter.sv
// Created:     9/17/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Flexible Counter

module flex_counter #(parameter NUM_CNT_BITS = 4)
(

    input wire clk, 
    input wire n_rst, 
    input wire clear, 
    input wire count_enable, 
    input wire [NUM_CNT_BITS-1:0]rollover_val, 

    output reg [NUM_CNT_BITS-1:0]count_out, 
    output reg rollover_flag

);
   
    reg [NUM_CNT_BITS-1:0] thatSweetRollover;

   typedef enum bit [2:0] {clear_state, data_accept, stop_bit_check, eidle, load_data, idle} state_type;
   state_type state;
   state_type nextstate;

    always @ (posedge clk, negedge n_rst) begin : Reset_Logic
        
        if (n_rst == 1'b0) begin
	       state <= idle;
        end else begin
            state <= next_state;
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

     clear_state: begin
      if (clear == 1'b0) begin
            nextstate = load_data;
         end else begin
            nextstate = eidle;
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
            
      eidle: begin
         if (framing_error == 1'b0) begin
            nextstate = idle;
         end else begin
            nextstate = eidle;
         end
      end
                    
  endcase
end
  
   always @ (state) begin : Register_Logic
    
      case(state)
       
    idle: begin 
           count_out = 1'b0; rollover_flag = 1'b0;
    end

  framing_error_check: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b1;
  end
      
    data_accept: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b1;
  end

  stop_bit_check: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b1;
           load_buffer = 1'b0; enable_timer = 1'b1;
  end

  load_data: begin 
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b1; enable_timer = 1'b1;
  end

  eidle: begin 
           sbc_clear = 1'b1; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b0;
  end

    default: begin
           sbc_clear = 1'b0; sbc_enable = 1'b0;
           load_buffer = 1'b0; enable_timer = 1'b0;
    end

      endcase
   end
   

/* reset count_out <= 1'b0; done
           rollover_flag <= 1'b0; done
        else begin
            if (clear == 1'b1) begin // Clear the competition!
                count_out <= 1'b0;
            end else begin
                if (count_enable == 1'b1) begin // Count everything!
                    if (count_out == thatSweetRollover) begin // They see me rollin', they hating. 
                        count_out <= 1'b0;// set to 1
                        rollover_flag <= 1'b0; 
                    end else begin
                        if ((count_out + 1) == thatSweetRollover) begin // They don't see me rollin'.
                            rollover_flag <= 1'b1;
                        end else begin
                            rollover_flag <= 1'b0;
                        end
                        count_out <= count_out + 1;
                    end
                end else begin
                    count_out <= count_out; // "I'm disabled!"- Roy
                end
                
            end
        
        end
        
    end
    
    assign thatSweetRollover = rollover_val; */
    
endmodule
