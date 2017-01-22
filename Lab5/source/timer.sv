// $Id: $mg68
// File name:   timer.sv
// Created:     9/25/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Timing Controller

`timescale 1ns / 100ps

module timer(input wire clk, input wire n_rst, input wire enable_timer, output reg shift_strobe, output reg packet_done);

//reg shift_strobe_register;
//reg packet_done_register;

reg [3:0] rollover_val_ten;
reg [3:0] count_out_ten;
reg [3:0] rollover_val_nine;
reg [3:0] count_out_nine;
reg clear;

assign rollover_val_ten = 4'b1010;
assign rollover_val_nine = 4'b1001;

flex_counter #(4) CNT10 (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(enable_timer), .rollover_val(rollover_val_ten), .count_out(count_out_ten), .rollover_flag(shift_strobe));
flex_counter #(4) CNT9 (.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(shift_strobe), .rollover_val(rollover_val_nine), .count_out(count_out_nine), .rollover_flag(packet_done));

/*always @ (posedge clk, negedge n_rst) begin

	if (n_rst == 1'b0) begin
		shift_strobe_register <= 0;
		packet_done_register <= 0;
	end else begin
		shift_strobe <= shift_strobe_register;
		packet_done <= packet_done_register;
	end

end */

endmodule
