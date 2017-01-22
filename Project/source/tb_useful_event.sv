// $Id: $mg68, $mg69
// File name:   tb_useful_event.sv
// Created:     Unknown
// Author:      Tatsu, CrocKim
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: The useful_event block rejects any pulse or event where 
// the data after the maximum value does not go below the baseline.

`timescale 1ns / 100ps // Time unit of one nanosecond, with a precision of 100ps.

module tb_useful_event();

	parameter CLK_PERIOD = 10; // 100 MHz input.

	// Inputs as registers.
	reg tb_clk;
	reg tb_nrst;
	reg tb_useful_event_enable;
	reg [19:0] tb_baseline_value;
	reg [19:0] tb_current_maximum_value;

	// Outputs as wires.
	wire tb_useful_event_out;

	baseline_creator DUT 
	(
		.clk (tb_clk),
		.nrst (tb_nrst),
	 	.useful_event_enable (tb_useful_event_enable),
	 	.baseline_value (tb_baseline_value),
	 	.current_maximum_value (tb_current_maximum_value),
	 	.useful_event_out (tb_useful_event_out)
	); // Device Under Test

	initial // Testbench time!
	begin : TESTING_THE_USEFUL_EVENT

		assign tb_nrst = 1'b1; // Default value.
		assign tb_useful_event_enable = 1'b0; // Default value.
		assign tb_baseline_value = 0; // Default value.
		assign tb_current_maximum_value = 0; // Default value.

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 1 === */

		assign tb_useful_event_enable = 1'b1;
		assign tb_baseline_value = 12500;
		assign tb_current_maximum_value = 12501;

		#(CLK_PERIOD);

		if (tb_useful_event == 1'b0) begin
			$info("Test case 1 passed!");
		end else begin
			$info("Test case 1 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 2 === */

		assign tb_useful_event_enable = 1'b1;
		assign tb_baseline_value = 12500;
		assign tb_current_maximum_value = 22500;

		#(CLK_PERIOD);

		if (tb_useful_event == 1'b0) begin
			$info("Test case 2 passed!");
		end else begin
			$info("Test case 2 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 3 === */

		assign tb_useful_event_enable = 1'b1;
		assign tb_baseline_value = 12500;
		assign tb_current_maximum_value = 12000;

		#(CLK_PERIOD);

		if (tb_useful_event == 1'b1) begin
			$info("Test case 3 passed!");
		end else begin
			$info("Test case 3 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 4 === 

		assign tb_tx_out = 1'b0;
		assign tb_sda_mode = 2'b11;

		#(CLK_PERIOD);

		if (tb_sda_out == tb_tx_out) begin
			$info("Test case 4 passed!");
		end else begin
			$info("Test case 4 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0. */

	end

endmodule
