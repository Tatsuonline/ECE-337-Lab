// $Id: $mg68
// File name:   tb_baseline_creator.sv
// Created:     23/11/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Takes the average of the first twenty points!

`timescale 1ns / 100ps // Time unit of one nanosecond, with a precision of 100ps.

module tb_baseline_creator();

	parameter CLK_PERIOD = 10; // 100 MHz input.

	// Inputs as registers.
	reg tb_clk;
	reg tb_nrst;
	reg tb_baseline_enable;
	reg [0:19] tb_data_to_average_0;
	reg [0:19] tb_data_to_average_1;
	reg [0:19] tb_data_to_average_2;
	reg [0:19] tb_data_to_average_3;
	reg [0:19] tb_data_to_average_4;
	reg [0:19] tb_data_to_average_5;
	reg [0:19] tb_data_to_average_6;
	reg [0:19] tb_data_to_average_7;
	reg [0:19] tb_data_to_average_8;
	reg [0:19] tb_data_to_average_9;
	reg [0:19] tb_data_to_average_10;
	reg [0:19] tb_data_to_average_11;
	reg [0:19] tb_data_to_average_12;
	reg [0:19] tb_data_to_average_13;
	reg [0:19] tb_data_to_average_14;
	reg [0:19] tb_data_to_average_15;
	reg [0:19] tb_data_to_average_16;
	reg [0:19] tb_data_to_average_17;
	reg [0:19] tb_data_to_average_18;
	reg [0:19] tb_data_to_average_19;

	// Outputs as wires.
	wire tb_baseline_done;
	wire [0:19] tb_baseline_value;

	baseline_creator DUT 
	(
		.clk (tb_clk),
		.nrst (tb_nrst),
	 	.baseline_enable (tb_baseline_enable),
	 	.data_to_average_0 (tb_data_to_average_0),
		.data_to_average_1 (tb_data_to_average_1),
		.data_to_average_2 (tb_data_to_average_2),
		.data_to_average_3 (tb_data_to_average_3),
		.data_to_average_4 (tb_data_to_average_4),
		.data_to_average_5 (tb_data_to_average_5),
		.data_to_average_6 (tb_data_to_average_6),
		.data_to_average_7 (tb_data_to_average_7),
		.data_to_average_8 (tb_data_to_average_8),
		.data_to_average_9 (tb_data_to_average_9),
		.data_to_average_10 (tb_data_to_average_10),
		.data_to_average_11 (tb_data_to_average_11),
		.data_to_average_12 (tb_data_to_average_12),
		.data_to_average_13 (tb_data_to_average_13),
		.data_to_average_14 (tb_data_to_average_14),
		.data_to_average_15 (tb_data_to_average_15),
		.data_to_average_16 (tb_data_to_average_16),
		.data_to_average_17 (tb_data_to_average_17),
	 	.data_to_average_18 (tb_data_to_average_18),
		.data_to_average_19 (tb_data_to_average_19),
		.baseline_done (tb_baseline_done),
		.baseline_value (tb_baseline_value)
	); // Device Under Test

	always 
	begin : CLOCK_GENERATION
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2); // 5ns
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2); // 5ns
	end

	initial // Testbench time!
	begin : TESTING_THE_BASELINE

		assign tb_baseline_enable = 1'b0; // Default value.
		assign tb_nrst = 1'b1; // Default value.
		assign tb_data_to_average_0 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_1 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_2 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_3 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_4 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_5 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_6 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_7 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_8 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_9 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_10 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_11 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_12 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_13 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_14 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_15 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_16 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_17 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_18 = 20'b00000000000000000000; // Default value.
		assign tb_data_to_average_19 = 20'b00000000000000000000; // Default value.

		#(2 * CLK_PERIOD); // Get away from time = 0.

		assign tb_nrst = 1'b0; // Reset!

		#(2 * CLK_PERIOD); // Get away from time = 0.

		assign tb_nrst = 1'b1; // Default value.

		/* === Test Case 1 === */

		assign tb_baseline_enable = 1'b1; // Baseline_creator has been enabled!
		assign tb_data_to_average_0 = 12500;
		assign tb_data_to_average_1 = 12500;
		assign tb_data_to_average_2 = 12500;
		assign tb_data_to_average_3 = 12500;
		assign tb_data_to_average_4 = 12500;
		assign tb_data_to_average_5 = 12500;
		assign tb_data_to_average_6 = 12500;
		assign tb_data_to_average_7 = 12500;
		assign tb_data_to_average_8 = 12500;
		assign tb_data_to_average_9 = 12500;
		assign tb_data_to_average_10 = 12500;
		assign tb_data_to_average_11 = 12500;
		assign tb_data_to_average_12 = 12500;
		assign tb_data_to_average_13 = 12500;
		assign tb_data_to_average_14 = 12500;
		assign tb_data_to_average_15 = 12500;
		assign tb_data_to_average_16 = 12500;
		assign tb_data_to_average_17 = 12500;
		assign tb_data_to_average_18 = 12500;
		assign tb_data_to_average_19 = 12500;

		#(CLK_PERIOD);

		if (tb_baseline_done == 1'b1 && tb_baseline_value == 12500) begin
			$info("Test case 1 passed!");
		end else begin
			$info("Test case 1 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Leave a gap.

		/* === Test Case 2 === */

		assign tb_data_to_average_0 = 500002;
		assign tb_data_to_average_1 = 500003;
		assign tb_data_to_average_2 = 500004;
		assign tb_data_to_average_3 = 500005;
		assign tb_data_to_average_4 = 500006;
		assign tb_data_to_average_5 = 500007;
		assign tb_data_to_average_6 = 500008;
		assign tb_data_to_average_7 = 500009;
		assign tb_data_to_average_8 = 500010;
		assign tb_data_to_average_9 = 500011;
		assign tb_data_to_average_10 = 500012;
		assign tb_data_to_average_11 = 500013;
		assign tb_data_to_average_12 = 500014;
		assign tb_data_to_average_13 = 500015;
		assign tb_data_to_average_14 = 500016;
		assign tb_data_to_average_15 = 500017;
		assign tb_data_to_average_16 = 500018;
		assign tb_data_to_average_17 = 500019;
		assign tb_data_to_average_18 = 500020;
		assign tb_data_to_average_19 = 500021;

		#(2 * CLK_PERIOD); // Leave a gap.

		assign tb_data_to_average_0 = 4000;
		assign tb_data_to_average_1 = 5000;
		assign tb_data_to_average_2 = 30004;
		assign tb_data_to_average_3 = 39005;
		assign tb_data_to_average_4 = 50294;
		assign tb_data_to_average_5 = 50427;
		assign tb_data_to_average_6 = 23808;
		assign tb_data_to_average_7 = 12509;
		assign tb_data_to_average_8 = 92710;
		assign tb_data_to_average_9 = 33011;
		assign tb_data_to_average_10 = 21012;
		assign tb_data_to_average_11 = 793013;
		assign tb_data_to_average_12 = 235014;
		assign tb_data_to_average_13 = 732015;
		assign tb_data_to_average_14 = 639016;
		assign tb_data_to_average_15 = 4017;
		assign tb_data_to_average_16 = 82318;
		assign tb_data_to_average_17 = 53019;
		assign tb_data_to_average_18 = 504520;
		assign tb_data_to_average_19 = 502421;

		#(2 * CLK_PERIOD); // Leave a gap.

		assign tb_data_to_average_0 = 100;
		assign tb_data_to_average_1 = 200;
		assign tb_data_to_average_2 = 300;
		assign tb_data_to_average_3 = 400;
		assign tb_data_to_average_4 = 500;
		assign tb_data_to_average_5 = 600;
		assign tb_data_to_average_6 = 700;
		assign tb_data_to_average_7 = 800;
		assign tb_data_to_average_8 = 900;
		assign tb_data_to_average_9 = 1000;
		assign tb_data_to_average_10 = 2000;
		assign tb_data_to_average_11 = 3000;
		assign tb_data_to_average_12 = 4000;
		assign tb_data_to_average_13 = 5000;
		assign tb_data_to_average_14 = 6000;
		assign tb_data_to_average_15 = 7000;
		assign tb_data_to_average_16 = 8000;
		assign tb_data_to_average_17 = 9000;
		assign tb_data_to_average_18 = 10000;
		assign tb_data_to_average_19 = 20000;

		/*

		assign tb_tx_out = 1'b0;
		assign tb_sda_mode = 2'b01;

		#(CLK_PERIOD);

		if (tb_sda_out == 1'b0) begin
			$info("Test case 2 passed!");
		end else begin
			$info("Test case 2 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Leave a gap.

		/* === Test Case 3 === 

		assign tb_tx_out = 1'b0;
		assign tb_sda_mode = 2'b10;

		#(CLK_PERIOD);

		if (tb_sda_out == 1'b1) begin
			$info("Test case 3 passed!");
		end else begin
			$info("Test case 3 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Leave a gap. */

	end

endmodule
