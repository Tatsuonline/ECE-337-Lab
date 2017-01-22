
//10 for 1000, 5 for 24
module max_value
(
	input wire clk,
	input wire n_rst,
	input wire clear,
	input wire maximum_value_enable,
	input wire [19:0] baseline_value,
	input wire [19:0] data_input,

	output wire [19:0] output1,
	output wire [19:0] output2,
	output wire [19:0] max_out
);
// For sdcc tempAmp = datain - baseline
reg [19:0] temp_out1;
reg [19:0] temp_out2;
reg [19:0] current_max;
reg [19:0] baseline;
reg [19:0] val_24th;
reg [9:0] rollval1 = 1000;
reg [4:0] rollval2 = 22;

reg cnt1_enable=0;
reg cnt2_enable=0;
reg cnt1_clear=0;
reg cnt2_clear=0;
reg cnt1_rollover;
reg cnt2_rollover;
reg [19:0]sync1;
//reg sync2;

flex_counter #(10) cnt1000(.clk(clk),.n_rst(n_rst), .clear(cnt1_clear), .count_enable(cnt1_enable), .rollover_val(rollval1), .rollover_flag(cnt1_rollover));
flex_counter #(5) cnt24(.clk(clk),.n_rst(n_rst), .clear(cnt2_clear), .count_enable(cnt2_enable), .rollover_val(rollval2), .rollover_flag(cnt2_rollover));

always @ (posedge clk, negedge n_rst) begin
	
	if (n_rst == 1'b0) begin
		baseline = {20{1'b0}};
		cnt1_enable=0;
		cnt2_enable=0;
		temp_out1 = 0;
		temp_out2 = 0;
		cnt1_clear=0;
		cnt2_clear=0;
		sync1 <= 0;
		 current_max <= sync1;
	end 
	else if (clear== 1) begin
		baseline = {20{1'b0}};
		cnt1_enable=0;
		cnt2_enable=0;
		temp_out1 = 0;
		temp_out2 = 0;
		cnt1_clear=0;
		cnt2_clear=0;
		sync1 <= 0;
		 current_max <= sync1;
	end
	else begin
		if (maximum_value_enable == 1) begin
		cnt1_enable=1; cnt2_clear=0;
			if (data_input > sync1) begin
				 sync1 <= data_input;
				 current_max <= sync1;
				cnt2_enable=1;				
				cnt2_clear=1;
			end 
			else if (cnt2_rollover==1) begin
				val_24th = data_input;
				cnt2_enable=0;
			end
			if (cnt1_rollover ==1) begin
				temp_out1 = current_max - baseline;
				temp_out1 = val_24th - baseline;
				cnt1_clear=1;
				cnt2_clear=1;
				cnt2_enable=0;
			end 
			else begin
				 current_max <= sync1;
				cnt1_clear=0;
				temp_out1 = temp_out1;
				temp_out2 = temp_out2;
			end
		end 
		else begin
			current_max <= sync1;;
		end
		baseline = baseline_value;
	end

end

/*always @ (posedge clk) begin
	if (cnt1_rollover ==1) begin
		temp_out1 = current_max - baseline;
		temp_out1 = val_24th - baseline;
		cnt1_clear=1;
		cnt2_clear=1;
		cnt2_enable=0;
	end 
else begin
	temp_out1 = temp_out1;
	temp_out2 = temp_out2;
end 
end*/

assign max_out = current_max;
assign output1 = temp_out1;
assign output2 = temp_out2;

endmodule
