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

	output wire baseline_done,
	output wire [0:19] baseline_value
);

	reg [0:19] addition_register_0;
	reg [0:19] addition_register_1;
	reg [0:19] addition_register_2;
	reg [0:19] addition_register_3;
	reg [0:19] addition_register_4;
	reg [0:19] addition_register_5;
	reg [0:19] addition_register_6;
	reg [0:19] addition_register_7;
	reg [0:19] addition_register_8;
	reg [0:19] addition_register_9;

	reg base_done;
	reg [0:19] base_val;
	

always @ (posedge clk, negedge nrst) begin
	
	if (nrst == 1'b0) begin
		base_done = 1'b0;
		base_val = 20'b00000000000000000000;

		addition_register_0 = 20'b00000000000000000000;
		addition_register_1 = 20'b00000000000000000000;
		addition_register_2 = 20'b00000000000000000000;
		addition_register_3 = 20'b00000000000000000000;
		addition_register_4 = 20'b00000000000000000000;
		addition_register_5 = 20'b00000000000000000000;
		addition_register_6 = 20'b00000000000000000000;
		addition_register_7 = 20'b00000000000000000000;
		addition_register_8 = 20'b00000000000000000000;
		addition_register_9 = 20'b00000000000000000000;

	end else if (baseline_enable == 1'b1) begin

	addition_register_0 = data_to_average_0 + data_to_average_1;
	addition_register_0 = addition_register_0 >> 1;
	addition_register_0[19] = 1'b0;
	addition_register_1 = data_to_average_2 + data_to_average_3;
	addition_register_1 = addition_register_1 >> 1;
	addition_register_1[19] = 1'b0;
	addition_register_2 = data_to_average_4 + data_to_average_5;
	addition_register_2 = addition_register_2 >> 1;
	addition_register_2[19] = 1'b0;
	addition_register_3 = data_to_average_6 + data_to_average_7;
	addition_register_3 = addition_register_3 >> 1;
	addition_register_3[19] = 1'b0;
	addition_register_4 = data_to_average_8 + data_to_average_9;
	addition_register_4 = addition_register_4 >> 1;
	addition_register_4[19] = 1'b0;
	addition_register_5 = data_to_average_10 + data_to_average_11;
	addition_register_5 = addition_register_5 >> 1;
	addition_register_5[19] = 1'b0;
	addition_register_6 = data_to_average_12 + data_to_average_13;
	addition_register_6 = addition_register_6 >> 1;
	addition_register_6[19] = 1'b0;
	addition_register_7 = data_to_average_14 + data_to_average_15;
	addition_register_7 = addition_register_7 >> 1;
	addition_register_7[19] = 1'b0;
	addition_register_8 = data_to_average_16 + data_to_average_17;
	addition_register_8 = addition_register_8 >> 1;
	addition_register_8[19] = 1'b0;
	addition_register_9 = data_to_average_18 + data_to_average_19;
	addition_register_9 = addition_register_9 >> 1;
	addition_register_9[19] = 1'b0;

	addition_register_0 = addition_register_0 + addition_register_1;
	addition_register_0 = addition_register_0 >> 1;
	addition_register_0[19] = 1'b0;
	addition_register_2 = addition_register_2 + addition_register_3;
	addition_register_2 = addition_register_2 >> 1;
	addition_register_2[19] = 1'b0;
	addition_register_4 = addition_register_4 + addition_register_5;
	addition_register_4 = addition_register_4 >> 1;
	addition_register_4[19] = 1'b0;
	addition_register_6 = addition_register_6 + addition_register_7;
	addition_register_6 = addition_register_6 >> 1;
	addition_register_6[19] = 1'b0;
	addition_register_8 = addition_register_8 + addition_register_9;
	addition_register_8 = addition_register_8 >> 1;
	addition_register_8[19] = 1'b0;

	addition_register_0 = addition_register_0 + addition_register_2;
	addition_register_0 = addition_register_0 >> 1;
	addition_register_0[19] = 1'b0;
	addition_register_4 = addition_register_4 + addition_register_6;
	addition_register_4 = addition_register_4 >> 1;
	addition_register_4[19] = 1'b0;

	addition_register_0 = addition_register_0 + addition_register_4;
	addition_register_0 = addition_register_0 >> 1; 
	addition_register_0[19] = 1'b0;
	addition_register_0 = addition_register_0 + addition_register_8;
	addition_register_0 = addition_register_0 >> 1;

	//addition_register_0 = addition_register_0 / 20;

	base_done = 1'b1;
	base_val = addition_register_0;

	end else begin

	base_done = 1'b0;
	base_val = 20'b00000000000000000000;

	end

end

assign baseline_done = base_done;
assign baseline_value = base_val;

endmodule
