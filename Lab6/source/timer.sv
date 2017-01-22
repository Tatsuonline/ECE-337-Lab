// $Id: $mg68
// File name:   timer.sv
// Created:     10/9/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Timer, baby!

module timer
(
	input reg clk,
	input reg n_rst,
	input reg rising_edge_found,
	input reg falling_edge_found,
	input reg stop_found,
	input reg start_found,

	output wire byte_received,
	output wire ack_prep,
	output wire check_ack,
	output wire ack_done
);

typedef enum bit [2:0] {rising_edge_counter_state, idle, byte_received_state, falling_found_1, rising_found_state, falling_found_2} state_type;
state_type state;
state_type nextstate;

reg [3:0] value = 8;
reg enable;
reg reset;
reg [3:0] count_output;
reg full_byte;
reg byte_received_reg;
reg ack_prep_reg;
reg check_ack_reg;
reg ack_done_reg;

flex_counter #(4) DUT (.clk(clk), .n_rst(n_rst), .clear(stop_found || ack_done || start_found), .count_enable(enable && rising_edge_found), .rollover_val(value), .count_out(count_output), .rollover_flag(full_byte));

always @ (posedge clk, negedge n_rst) begin : Reset_Logic
	
	if (n_rst == 1'b0) begin
		state <= idle;
	end else begin
		state <= nextstate;
		value <= 8;
	end

end

always_comb begin : State_Logic

	nextstate = state; // Default.

	case (state)

	idle : begin
		if (start_found == 1'b1) begin
			nextstate = rising_edge_counter_state;
		end else begin
			nextstate = idle;
		end

		if (stop_found == 1'b1) begin
			nextstate = idle;
		end
	end

	rising_edge_counter_state : begin
		if (full_byte == 1'b1) begin
			nextstate = byte_received_state;
		end else begin
			nextstate = rising_edge_counter_state;
		end

		/* if (rising_edge_counter == 8) begin
			nextstate = byte_received_state;
		end else begin
			nextstate = rising_edge_counter_state;
		end

		if (rising_edge_found == 1'b1) begin
			rising_edge_counter = rising_edge_counter + 1;
		end */

		if (stop_found == 1'b1) begin
			nextstate = idle;
		end
	end

	byte_received_state : begin
		if (falling_edge_found == 1'b1) begin
			nextstate = falling_found_1;
		end else begin
			nextstate = byte_received_state;
		end

		if (stop_found == 1'b1) begin
			nextstate = idle;
		end
	end

	falling_found_1 : begin
		if (rising_edge_found == 1'b1) begin
			nextstate = rising_found_state;
		end else begin
			nextstate = falling_found_1;
		end

		if (stop_found == 1'b1) begin
			nextstate = idle;
		end
	end

	rising_found_state : begin
		if (falling_edge_found == 1'b1) begin
			nextstate = falling_found_2;
		end else begin
			nextstate = rising_found_state;
		end

		if (stop_found == 1'b1) begin
			nextstate = idle;
		end
	end

	falling_found_2 : begin
		nextstate = rising_edge_counter_state;
	end

	endcase
end

always @ (state) begin : Register_Logic
	
	byte_received_reg = 1'b0; ack_prep_reg = 1'b0; reset = 1'b0;
	check_ack_reg = 1'b0; ack_done_reg = 1'b0; enable = 1'b0;

	case (state)

	idle : begin
		byte_received_reg = 1'b0; ack_prep_reg = 1'b0; reset = 1'b0;
		check_ack_reg = 1'b0; ack_done_reg = 1'b0; 
	end

	rising_edge_counter_state : begin
		byte_received_reg = 1'b0; ack_prep_reg = 1'b0; enable = 1'b1;
		check_ack_reg = 1'b0; ack_done_reg = 1'b0; reset = 1'b0;
	end

	byte_received_state : begin
		byte_received_reg = 1'b1; ack_prep_reg = 1'b0; enable = 1'b0;
		check_ack_reg = 1'b0; ack_done_reg = 1'b0; reset = 1'b1;
	end

	falling_found_1 : begin
		byte_received_reg = 1'b0; ack_prep_reg = 1'b1; reset = 1'b0;
		check_ack_reg = 1'b0; ack_done_reg = 1'b0;
	end

	rising_found_state : begin
		byte_received_reg = 1'b0; ack_prep_reg = 1'b0; reset = 1'b0;
		check_ack_reg = 1'b1; ack_done_reg = 1'b0;
	end

	falling_found_2 : begin
		byte_received_reg = 1'b0; ack_prep_reg = 1'b0; reset = 1'b0;
		check_ack_reg = 1'b0; ack_done_reg = 1'b1;
	end

	endcase
end

assign byte_received = byte_received_reg;
assign ack_prep = ack_prep_reg;
assign check_ack = check_ack_reg;
assign ack_done = ack_done_reg;

endmodule
