// $Id: $mg68
// File name:   tb_scl_edge.sv
// Created:     10/4/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for the SCL Edge Detection Block

`timescale 1ns / 100ps // Time unit of one nanosecond, with a precision of 100ps.

module tb_scl_edge ();

	parameter CLK_PERIOD = 10; // 100 MHz input.
	parameter S_CLK_PERIOD = 300; // High speed mode.

	// Inputs as registers.
	reg tb_clk;
	reg tb_n_rst;
	reg tb_scl;

	// Outputs as wires.
	wire tb_rising_edge_found;
	wire tb_falling_edge_found;

	scl_edge DUT (.clk (tb_clk), .n_rst (tb_n_rst), .scl (tb_scl), .rising_edge_found (tb_rising_edge_found), .falling_edge_found (tb_falling_edge_found)); // Device Under Test

	always 
	begin : CLOCK_GENERATION
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2); // 5ns
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2); // 5ns
	end

	always 
	begin : S_CLOCK_GENERATION
		tb_scl = 1'b0;
		#(S_CLK_PERIOD / 3); // For 33.3% duty cycle.
		#(S_CLK_PERIOD / 3); // For 33.3% duty cycle.
		tb_scl = 1'b1;
		#(S_CLK_PERIOD / 3); // For 33.3% duty cycle.
	end

	initial // Testbench time!
	begin : TESTING_AT_THE_EDGE

		tb_n_rst = 1'b1; // Initially inactive.
		#(2 * CLK_PERIOD); // Get away from time = 0.


		/* === Test Case 1 === */

		#(2 * CLK_PERIOD); // @ 40 ns
		tb_n_rst = 1'b0; // Assert reset.

		if (tb_rising_edge_found == 1'b0 && tb_falling_edge_found == 1'b0) begin
			$info("Everthing reset correctly!");
		end else begin
			$info("ERROR: Things were not reset correctly!");
		end

		#(2 * CLK_PERIOD); // @ 60 ns

		tb_n_rst = 1'b1; // Deassert reset.

		/* === Test Case 2 === */

		#(14 * CLK_PERIOD); // @ 300 ns

		#(CLK_PERIOD); // @ 310 ns

		if (tb_rising_edge_found == 1'b1) begin
			$info("The rising edge was found correctly!");
		end else begin
			$info("ERROR: The rising edge was not detected!");
		end

		/* === Test Case 3 === */

		#(9 * CLK_PERIOD); // @ 400 ns

		#(CLK_PERIOD); // @ 410 ns

		if (tb_falling_edge_found == 1'b1) begin
			$info("The falling edge was found correctly!");
		end else begin
			$info("ERROR: The falling edge was not detected!");
		end

		#(CLK_PERIOD); // @ 420 ns

		/* === Test Case 4 === */

		#(3 * CLK_PERIOD); // @ 450 ns

		if (tb_rising_edge_found == 1'b0) begin
			$info("The rising edge works correctly!");
		end else begin
			$info("ERROR: The rising edge does not work!");
		end

		#(CLK_PERIOD); // @ 460 ns

		/* === Test Case 5 === */

		#(3 * CLK_PERIOD); // @ 490 ns

		if (tb_falling_edge_found == 1'b0) begin
			$info("The falling edge works correctly!");
		end else begin
			$info("ERROR: The falling edge does not work!");
		end

		#(CLK_PERIOD); // @ 500 ns
	end

endmodule
