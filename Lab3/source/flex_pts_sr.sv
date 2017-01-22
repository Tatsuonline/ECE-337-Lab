// $Id: $mg68
// File name:   flex_pts_sr.sv
// Created:     9/14/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: N-bit Parallel to Serial Shift Register Design

module flex_pts_sr #(parameter NUM_BITS = 4, parameter SHIFT_MSB = 1)(input wire clk, input wire n_rst, input wire shift_enable, output wire serial_out, input wire [NUM_BITS-1:0]parallel_in, input wire load_enable);
   
   reg [NUM_BITS-1:0] buffer;

   always@(posedge clk or negedge n_rst) begin
     if (n_rst == 1'b0) begin
	// All registers and flip-flops must be reset to original values
	buffer[NUM_BITS-1:0] <= {NUM_BITS{1'b1}}; // Repetitive concatenation. The buffer is filled with 1s.
     end else begin
     
     if (load_enable == 1'b1) begin
	buffer[NUM_BITS-1:0] <= parallel_in[NUM_BITS-1:0];
	end else begin
 
     if (shift_enable == 1'b1 && SHIFT_MSB == 1'b1) begin
	buffer[NUM_BITS-1:0] <= {buffer[NUM_BITS-2:0], 1'b1};
     end else begin
	
     if (shift_enable == 1'b1 && SHIFT_MSB == 1'b0) begin
	buffer[NUM_BITS-1:0] <= {1'b1, buffer[NUM_BITS-1:1]};
     end else begin
	buffer <= buffer;
     end
	
	
     end // else: !if(shift_enable == 1'b1 && SHIFT_MSB == 1'b1)
	   
	end // else: !if(load_enable == 1'b1)

end // else: !if(n_rst == 1'b0)

end // always@ (posedge clk or negedge n_rst)

   if (SHIFT_MSB == 1) begin
      assign serial_out = (buffer[NUM_BITS-1]);
   end else if (SHIFT_MSB == 0) begin
      assign serial_out = (buffer[0]);
      end
	

endmodule // flex_pts_sr
