// $Id: $mg87
// File name:   flex_stp_sr.sv
// Created:     2/12/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: N-bit Serial to Parallel Shift Register Design

module flex_stp_sr #(parameter NUM_BITS = 4, parameter SHIFT_MSB = 1)(input wire clk, input wire n_rst, input wire shift_enable, input wire serial_in, output wire [NUM_BITS-1:0]parallel_out);
   
   reg [NUM_BITS-1:0] buffer;

   always@(posedge clk or negedge n_rst) begin
     if (n_rst == 1'b0) begin
	// All registers and flip-flops must be reset to original values
	buffer[NUM_BITS-1:0] <= {NUM_BITS{1'b1}};
     end else begin
      
     if (shift_enable == 1'b1 && SHIFT_MSB == 1'b1) begin
	buffer[NUM_BITS-1:0] <= {buffer[NUM_BITS-2:0], serial_in};
     end else begin
	
     if (shift_enable == 1'b1 && SHIFT_MSB == 1'b0) begin
	buffer[NUM_BITS-1:0] <= {serial_in, buffer[NUM_BITS-1:1]};
     end else begin
	buffer[NUM_BITS-1:0] <= buffer[NUM_BITS-1:0];
     end
	
	
     end // else: !if(shift_enable == 1'b1 && SHIFT_MSB == 1'b1)
       
    end // else: !if(n_rst == 1'b0)

   end // always@ (posedge clk or negedge n_rst)

   assign parallel_out[NUM_BITS-1:0] = (buffer[NUM_BITS-1:0]);
   
	

endmodule // flex_pts_sr
