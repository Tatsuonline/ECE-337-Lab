// $Id: $mg68
// File name:   discrimination_parameter_creator.sv
// Created:     11/23/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Finds the discrimination parameter!

module discrimination_parameter_creator
(
	input wire clk,
	input wire nrst,
	input wire [19:0] data_input,
	input wire [19:0] baseline_value,
	
	output wire [25:0] discrimination_parameter
);

reg [7:0]shortIntegralStart = 188;
reg [8:0]shortIntegralEnd = 500;
reg [19:0] currentVoltageValue;
reg [19:0] temporaryAmplitude;
reg [25:0] discPar;
reg [19:0] baseline;

reg [25:0]tdp=0;
reg count_enable1;
reg count_enable2;

reg rollover_flag1;
reg rollover_flag2;
reg temp_flag1=0;
reg temp_cnt1_en=1;   
reg temp_cnt2_en=1;

flex_counter #(8) FIRSTCOUNT (.clk(clk), .n_rst(nrst), .count_enable(count_enable1), .rollover_val(shortIntegralStart), .rollover_flag(rollover_flag1));
flex_counter #(9) SECONDCOUNT (.clk(clk), .n_rst(nrst), .count_enable(count_enable2), .rollover_val(shortIntegralEnd), .rollover_flag(rollover_flag2));

always @ (posedge clk, negedge nrst) begin
	
	if (nrst == 1'b0) begin
		currentVoltageValue = 20'b00000000000000000000;
		temporaryAmplitude = 20'b00000000000000000000;
		discPar = 25'b0000000000000000000000000;
		baseline = 20'b00000000000000000000;
		count_enable1 = 1'b1;
		count_enable2 = 1'b1;
	end 
	else begin
		currentVoltageValue = data_input;
		baseline = baseline_value;
		if (rollover_flag1==1) begin
		  temp_flag1=1;
		end
		if (temp_flag1 == 1'b1 && rollover_flag2 == 1'b0) begin	   
			temporaryAmplitude = currentVoltageValue - baseline;
			discPar = discPar + temporaryAmplitude**2;
		end
		else begin
			currentVoltageValue = currentVoltageValue;
			baseline = baseline;
		end
		if (rollover_flag2 ==1) begin
		    temp_cnt1_en=0;		   
		    temp_cnt2_en=0;
        	    temp_flag1 = 0;		   
		    tdp=discPar;
		end
	   count_enable1=temp_cnt1_en;	   
	   count_enable2=temp_cnt2_en;	   
	end

end

	   assign discrimination_parameter = tdp;



endmodule
