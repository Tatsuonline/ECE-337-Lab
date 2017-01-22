// $Id: $mg68
// File name:   baseline_creator.sv
// Created:     11/23/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Takes the average of the first twenty points!

module baseline_creator
(
	input wire clk,
	input wire nrst,
	input wire baseline_enable,
	input wire [0:19] data_to_average_0,
	input wire [0:19] data_to_average_1,
	input wire [0:19] data_to_average_2,
	input wire [0:19] data_to_average_3,
	input wire [0:19] data_to_average_4,
	input wire [0:19] data_to_average_5,
	input wire [0:19] data_to_average_6,
	input wire [0:19] data_to_average_7,
	input wire [0:19] data_to_average_8,
	input wire [0:19] data_to_average_9,
	input wire [0:19] data_to_average_10,
	input wire [0:19] data_to_average_11,
	input wire [0:19] data_to_average_12,
	input wire [0:19] data_to_average_13,
	input wire [0:19] data_to_average_14,
	input wire [0:19] data_to_average_15,
	input wire [0:19] data_to_average_16,
	input wire [0:19] data_to_average_17,
	input wire [0:19] data_to_average_18,
	input wire [0:19] data_to_average_19,

	//output reg baseline_done, <-- Not necessary, I think.
	output wire [0:20] baseline_value
)

	reg [0:25] temporaryRegister;

always @ (posedge clk, negedge nrst) begin
	
	if (nrst == 1'b0) begin

		temporaryRegister = 25'b0000000000000000000000000;

	end else if (baseline_enable == 1'b1) begin

		temporaryRegister = (data_to_average_0 + data_to_average_1 + data_to_average_2
		+ data_to_average_3 + data_to_average_4 + data_to_average_5 + data_to_average_6
		+ data_to_average_7 + data_to_average_8 + data_to_average_9 + data_to_average_10
		+ data_to_average_11 + data_to_average_12 + data_to_average_13 + data_to_average_14
		+ data_to_average_15 + data_to_average_16 + data_to_average_17 + data_to_average_18
		+ data_to_average_19);

		temporaryRegister = temporaryRegister / (5'b10100);

	end else begin

		temporaryRegister = 25'b0000000000000000000000000;

	end

end

assign baseline_value = {0,20} temporaryRegister; // Ask Tim about truncation.

endmodule
