// $Id: $mg68
// File name:   tb_sda_sel.sv
// Created:     10/5/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: 2-bit Control Bus from Controller

`timescale 1ns / 100ps // Time unit of one nanosecond, with a precision of 100ps.

module tb_sda_sel();

	parameter CLK_PERIOD = 10; // 100 MHz input.

	// Inputs as registers.
	reg tb_tx_out;
	reg [1:0]tb_sda_mode;

	// Outputs as wires.
	wire tb_sda_out;

	sda_sel DUT (.tx_out (tb_tx_out), .sda_mode (tb_sda_mode), .sda_out (tb_sda_out)); // Device Under Test

	initial // Testbench time!
	begin : TESTING_THE_SDA

		assign tb_tx_out = 1'b0; // Default value.
		assign tb_sda_mode = 2'b00; // Default value.

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 1 === */

		assign tb_tx_out = 1'b0;
		assign tb_sda_mode = 2'b00;

		#(CLK_PERIOD);

		if (tb_sda_out == 1'b1) begin
			$info("Test case 1 passed!");
		end else begin
			$info("Test case 1 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 2 === */

		assign tb_tx_out = 1'b0;
		assign tb_sda_mode = 2'b01;

		#(CLK_PERIOD);

		if (tb_sda_out == 1'b0) begin
			$info("Test case 2 passed!");
		end else begin
			$info("Test case 2 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 3 === */

		assign tb_tx_out = 1'b0;
		assign tb_sda_mode = 2'b10;

		#(CLK_PERIOD);

		if (tb_sda_out == 1'b1) begin
			$info("Test case 3 passed!");
		end else begin
			$info("Test case 3 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 4 === */

		assign tb_tx_out = 1'b0;
		assign tb_sda_mode = 2'b11;

		#(CLK_PERIOD);

		if (tb_sda_out == tb_tx_out) begin
			$info("Test case 4 passed!");
		end else begin
			$info("Test case 4 failed, bro.");
		end

		#(2 * CLK_PERIOD); // Get away from time = 0.

	end

endmodule
