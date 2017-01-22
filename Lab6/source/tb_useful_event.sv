// $Id: $mg68
// File name:   tb_useful_event.sv
// Created:     23/11/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Finds whether the event is useful!

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

	useful_event DUT 
	(
		.clk (tb_clk),
		.nrst (tb_nrst),
	 	.useful_event_enable (tb_useful_event_enable),
	 	.baseline_value (tb_baseline_value),
	 	.current_maximum_value (tb_current_maximum_value),
	 	.useful_event_out (tb_useful_event_out)
	); // Device Under Test

	always 
	begin : CLOCK_GENERATION
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2); // 5ns
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2); // 5ns
	end

	initial // Testbench time!
	begin : TESTING_THE_USEFUL_EVENT

		assign tb_nrst = 1'b1; // Default value.
		assign tb_useful_event_enable = 1'b0; // Default value.
		assign tb_baseline_value = 0; // Default value.
		assign tb_current_maximum_value = 0; // Default value.

		#(2 * CLK_PERIOD); // Get away from time = 0.

		assign tb_nrst = 1'b0; // Reset!

		#(2 * CLK_PERIOD);

		assign tb_nrst = 1'b1; // Default value.

		/* === Test Case 1 === */

		assign tb_useful_event_enable = 1'b1;
		assign tb_baseline_value = 12500;
		assign tb_current_maximum_value = 12501;

		#(2 * CLK_PERIOD);

		if (tb_useful_event_out == 1'b0) begin
			$info("Test case 1 passed!");
		end else begin
			$info("Test case 1 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 2 === */

		assign tb_baseline_value = 12500;
		assign tb_current_maximum_value = 22500;

		#(CLK_PERIOD);

		if (tb_useful_event_out == 1'b1) begin
			$info("Test case 2 passed!");
		end else begin
			$info("Test case 2 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 3 === */

		assign tb_baseline_value = 12500;
		assign tb_current_maximum_value = 12000;

		#(CLK_PERIOD);

		if (tb_useful_event_out == 1'b0) begin
			$info("Test case 3 passed!");
		end else begin
			$info("Test case 3 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 4 === */ //Multiple Tests at once! 

		assign tb_current_maximum_value = 22000;
		#(2 * CLK_PERIOD);
		assign tb_current_maximum_value = 32000;
		#(2 * CLK_PERIOD);
		assign tb_current_maximum_value = 10000;
		#(2 * CLK_PERIOD);
		assign tb_current_maximum_value = 45000;
		#(2 * CLK_PERIOD);
		assign tb_current_maximum_value = 62300;
		#(2 * CLK_PERIOD);
		assign tb_current_maximum_value = 12040;
		#(2 * CLK_PERIOD);
		assign tb_current_maximum_value = 34050;
		#(2 * CLK_PERIOD);
		assign tb_current_maximum_value = 12160;
		#(2 * CLK_PERIOD);

	end

endmodule
