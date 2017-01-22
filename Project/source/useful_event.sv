// $Id: $mg68, $mg69
// File name:   useful_event.sv
// Created:     Unknown
// Author:      Tatsu, CrocKim
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: The useful_event block rejects any pulse or event where 
// the data after the maximum value does not go below the baseline.

module useful_event
(
	input wire clk,
	input wire nrst,
	input wire useful_event_enable,
	input wire [19:0] baseline_value,
	input wire [19:0] current_maximum_value,

	output wire useful_event_out
)

reg [19:0] baseline, curr_max;
reg useful;

always @ (posedge clk, negedge nrst) begin

	if (nrst == 1'b0) begin
		baseline = 20'b00000000000000000000;
		curr_max = 20'b00000000000000000000;
		useful = 1'b0;
	end else begin
		if (useful_event_enable == 1'b1) begin
			if (baseline < curr_max) begin
				useful = 1'b0;
			end else begin
				baseline = baseline_value;
				curr_max = current_maximum_value;
				useful = 1'b1;
			end
		end else begin
			baseline = baseline;
			curr_max = curr_max;
		end
	end
end

assign useful_event_out = useful;

endmodule
