// $Id: $mg68
// File name:   timer.sv
// Created:     9/25/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 9-bit Shift Register

module sr_9bit
(
	input wire clk, 
	input wire n_rst, 
	input wire shift_strobe, 
	input wire serial_in, 

	output wire [7:0] packet_data, 
	output wire stop_bit

);

	reg [8:0] packet_data_register;

flex_stp_sr #(9,0) NINEBIT (.clk(clk), .n_rst(n_rst), .shift_enable(shift_strobe), .serial_in(serial_in), .parallel_out(packet_data_register)); 

/*always @ (posedge clk, negedge n_rst) begin

	if (n_rst == 1'b0) begin
		packet_data_register <= 9'b000000000;
	end else begin
		packet_data <= packet_data_register[7:0];
		stop_bit <= packet_data_register[8];
	end

end 8*/

assign packet_data = packet_data_register[7:0];
assign stop_bit = packet_data_register[8];

endmodule
