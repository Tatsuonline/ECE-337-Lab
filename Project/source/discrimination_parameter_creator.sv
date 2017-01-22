// $Id: $mg68, $mg69
// File name:   discrimination_parameter_creator.sv
// Created:     Unknown
// Author:      Tatsu, CrocKim
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: The discrimination_parameter_creator block takes in each pulse and performs
// a calculation on the data to create a discrimination parameter- which is a vital part of the SDCC algorithm.

module discrimination_parameter_creator
(
	input wire clk,
	input wire nrst,
	input wire [19:0] data_input,
	input wire [19:0] baseline_value,
	
	output wire [19:0] discrimination_parameter
);

parameter shortIntegralStart = 188;
parameter shortIntegralEnd = 500;
reg [19:0] currentVoltageValue;
reg [19:0] temporaryAmplitude;
reg [25:0] discPar;
reg [19:0] baseline;

flex_counter #(shortIntegralStart) FIRSTCOUNT (.clk(clk), .n_rst(n_rst), .count_enable(count_enable1), .rollover_val(rollover_val1), .rollover_flag(rollover_flag1));
flex_counter #(shortIntegralEnd) SECONDCOUNT (.clk(clk), .n_rst(n_rst), .count_enable(count_enable2), .rollover_val(rollover_val2), .rollover_flag(rollover_flag2));

// Use flex counter to count to shortIntegralStart
// From shortIntegralStart to shortIntegralEnd, do:
// temporaryAmplitude = currentVoltageValue - baseline
// discPar = discPar + temporaryAmplitude**2

// reg clear1;
// reg clear2;
reg count_enable1;
reg count_enable2;
reg rollover_val1;
reg rollover_val2;
// reg count_out1;
// reg count_out2;
reg rollover_flag1;
reg rollover_flag2;

always @ (posedge clk, negedge nrst) begin
	
	if (nrst == 1'b0) begin
		currentVoltageValue = 20'b00000000000000000000;
		temporaryAmplitude = 20'b00000000000000000000;
		discPar = 25'b0000000000000000000000000;
		baseline = 20'b00000000000000000000;
		count_enable1 = 1'b1;
		count_enable2 = 1'b1;
		rollover_val1 = shortIntegralStart;
		rollover_val2 = shortIntegralEnd;
	end else begin
		currentVoltageValue = data_input;
		baseline = baseline_value;
		if (rollover_flag1 == 1'b1 && rollover_flag2 == 1'b0) begin
			temporaryAmplitude = currentVoltageValue - baseline;
			discPar = discPar + temporaryAmplitude**2
		end else begin
			currentVoltageValue = currentVoltageValue;
			baseline = baseline;
		end
	end

end

if (rollover_flag2 == 1'b1) begin
	assign discrimination_parameter = discPar;
end

endmodule
