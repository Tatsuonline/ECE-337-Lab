// $Id: $mg68
// File name:   scl_edge.sv
// Created:     10/4/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Detects both the rising and falling edges of the SCL line.

module scl_edge 
(
	input wire clk,
	input wire n_rst,
	input wire scl,

	output wire rising_edge_found,
	output wire falling_edge_found
);

reg temporaryRegister1;
reg temporaryRegister2;

always @ (posedge clk, negedge n_rst)
begin

	if (n_rst == 1'b0) begin
		temporaryRegister1 <= 1'b0;
		temporaryRegister2 <= 1'b0;
	end else begin
		temporaryRegister1 <= scl;
		temporaryRegister2 <= temporaryRegister1;
	end

end

assign falling_edge_found = (~temporaryRegister1 && temporaryRegister2 == 1'b1) ? 1'b1 : 1'b0;
assign rising_edge_found = (temporaryRegister1 && ~temporaryRegister2 == 1'b1) ? 1'b1 : 1'b0;

endmodule
