// $Id: $ mg68
// File name:   counter.sv
// Created:     2/18/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Counts

module counter(input wire clk, input wire n_reset, input wire cnt_up, output wire one_k_samples);
  
  reg [9:0] counter;
  reg temporaryRegister;

  assign one_k_samples = temporaryRegister;

  always @ (posedge clk, negedge n_reset) begin
    
    if (n_reset==0) begin
      counter <= 10'b0; 
      temporaryRegister <= 1'b0;
    end else begin
    
     if (cnt_up) begin	
      counter <= counter + 1'b1;
	
  if(counter[9:0] == 10'b1111101000) begin
		temporaryRegister <= 1'b1;
		counter[9:0] <= 10'b0000000000;
	end else begin
		temporaryRegister <= 1'b0;
	end
     end else begin
      counter <= counter;
     end
      
		end

	end

endmodule
