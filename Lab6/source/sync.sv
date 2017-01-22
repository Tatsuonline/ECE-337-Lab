// $Id: $mg68
// File name:   sync.sv
// Created:     9/5/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Synchronizer

module sync (input clk, input n_rst, input async_in, output sync_out);

   reg register1;
   reg register2;
     
   
   always_ff @ (posedge clk, negedge n_rst) begin
      
      if (1'b0 == n_rst) begin
	 register1 <= 1'b0;
	 register2 <= 1'b0;
      end
      else begin
	 register1 <= async_in;
	 register2 <= register1;
      end
      
   end // always_ff @

    assign sync_out = register2;
   
endmodule // sync
