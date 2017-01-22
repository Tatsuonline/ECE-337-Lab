// $Id: $mg68
// File name:   maximum_value.sv
// Created:     11/23/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Finds the largest value!

module maximum_value
(
	input wire clk,
	input wire nrst,
	input wire maximum_value_enable,
	input wire [19:0] baseline_value,
	input wire [19:0] countout,
	input wire rollover_flag,
	input wire [19:0] data_input,

	output wire [19:0] output1,
	output wire [19:0] output2,
	output wire [19:0] current_maximum_value,
	output wire count_enable,
	output wire [19:0] rollover_value
)

reg [19:0] current_max;
reg [19:0] baseline;

always @ (posedge clk, negedge nrst) begin
	
	if (nrst == 1'b0) begin
		current_max = 20'b00000000000000000000;
		baseline = 20'b00000000000000000000;
	end else begin
		if (maximum_value_enable == 1'b1 && rollover_flag == 1'b1) begin
			if (data_input > current_max) begin
				current_max = data_input;
			end else begin
				current_max = current_max;
			end
		end else begin
			current_max = current_max;
		end
		baseline = baseline_value;
	end

end

assign current_maximum_value = current_max;
assign output1 = current_maximum_value - baseline;
assign output2 = 


endmodule
