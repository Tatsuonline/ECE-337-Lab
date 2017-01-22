// $Id: $mg68
// File name:   flex_counter.sv
// Created:     9/17/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Flexible Counter

module flex_counter#(parameter NUM_CNT_BITS = 9)(input wire clk, input wire n_rst, input wire clear, input wire count_enable, input wire [NUM_CNT_BITS-1:0]rollover_val, output reg [NUM_CNT_BITS-1:0]count_out, output reg rollover_flag);
   
    reg [NUM_CNT_BITS-1:0] thatSweetRollover;

    always @ (posedge clk, negedge n_rst) begin
        
        if (n_rst == 1'b0) begin // Resetting the game!
	       count_out <= 1'b0;
           rollover_flag <= 1'b0;
        end else begin
        if (clear == 1'b1) begin // Clear the competition!
            count_out <= 1'b0;
            rollover_flag <= 1'b0;
        end else begin
        if (count_enable == 1'b1) begin // Count everything!
            if (count_out == thatSweetRollover) begin // They see me rollin', they hating. 
                count_out <= 1'b1;
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
    
    assign thatSweetRollover = rollover_val;
    
endmodule
