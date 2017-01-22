// $Id: $mg68, $mg69
// File name:   baseline_creator.sv
// Created:     Unknown
// Author:      Tatsu, CrocKim
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: The baseline_creator takes the average of the first twenty values and sets this as the baseline.

module baseline_creator
(
	input wire clk,
	input wire nrst,
	input wire clear,
	input wire baseline_enable,
	input wire [399:0] data_in,


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
		base_done = 0;
		base_val = 0;

		addition_register_0 = 0;
		addition_register_1 = 0;
		addition_register_2 = 0;
		addition_register_3 = 0;
		addition_register_4 = 0;
		addition_register_5 = 0;
		addition_register_6 = 0;
		addition_register_7 = 0;
		addition_register_8 = 0;
		addition_register_9 = 0;
	end 
	else if (clear == 1) begin
		base_done = 0;
		base_val = 0;

		addition_register_0 = 0;
		addition_register_1 = 0;
		addition_register_2 = 0;
		addition_register_3 = 0;
		addition_register_4 = 0;
		addition_register_5 = 0;
		addition_register_6 = 0;
		addition_register_7 = 0;
		addition_register_8 = 0;
		addition_register_9 = 0;
	end

	else if (baseline_enable == 1'b1) begin

	addition_register_0 = data_in[399:380] + data_in[379:360];
	addition_register_0 = addition_register_0 >> 1;
	addition_register_0[19] = 1'b0;
	addition_register_1 = data_in[359:340] + data_in[339:320];
	addition_register_1 = addition_register_1 >> 1;
	addition_register_1[19] = 1'b0;
	addition_register_2 = data_in[319:300] + data_in[299:280];
	addition_register_2 = addition_register_2 >> 1;
	addition_register_2[19] = 1'b0;
	addition_register_3 = data_in[279:260] + data_in[259:240];
	addition_register_3 = addition_register_3 >> 1;
	addition_register_3[19] = 1'b0;
	addition_register_4 = data_in[239:220] + data_in[219:200];
	addition_register_4 = addition_register_4 >> 1;
	addition_register_4[19] = 1'b0;
	addition_register_5 = data_in[199:180] + data_in[179:160];
	addition_register_5 = addition_register_5 >> 1;
	addition_register_5[19] = 1'b0;
	addition_register_6 = data_in[159:140] + data_in[139:120];
	addition_register_6 = addition_register_6 >> 1;
	addition_register_6[19] = 1'b0;
	addition_register_7 = data_in[119:100] + data_in[99:80];
	addition_register_7 = addition_register_7 >> 1;
	addition_register_7[19] = 1'b0;
	addition_register_8 = data_in[79:60] + data_in[56:40];
	addition_register_8 = addition_register_8 >> 1;
	addition_register_8[19] = 1'b0;
	addition_register_9 = data_in[39:20] + data_in[19:0];
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
