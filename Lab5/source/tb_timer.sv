// $Id: $mg68
// File name:   tb_timer.sv
// Created:     9/26/2014
// Author:      Tatsu
// Lab Section: 2
// Version:     1.0  Initial Design Entry
// Description: A testbench for the Timer Module

`timescale 1ns / 100ps // Time unit of one nanosecond, with a precision of 100ps.

// To get a 400 MHz system clock, do 1x10^9 / 400,000,000 = 2.5. The clock is asserted for 1.25ns and then deasserted for 1.25ns. 


module tb_timer();

	parameter CLK_PERIOD = 2.5;

	reg tb_clk, tb_n_rst, tb_enable_timer; // Inputs as registers.
	wire tb_shift_strobe, tb_packet_done; // Outputs as wires.

	timer DUT (.clk(tb_clk), .n_rst(tb_n_rst), .enable_timer(tb_enable_timer), .shift_strobe(tb_shift_strobe), .packet_done(tb_packet_done)); // .timerPorts(testPorts)

	always 
	begin : CLOCK_GENERATION
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2); // 1.25ns
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2); // 1.25ns
	end

	initial // Testbench time!
	begin : TESTING_SPACETIME

		tb_n_rst = 1'b1; // Initially inactive.
		tb_enable_timer = 1'b0; // Initially inactive.

		#(2 * CLK_PERIOD); // Get away from time = 0.

		/* === Test Case 1 === */

		#(2 * CLK_PERIOD);
		tb_n_rst = 1'b0; // Assert reset.

		if (tb_enable_timer == 1'b0) begin
			$info("The enable_timer reset correctly.");
		end else begin
			$info("ERROR: The enable_timer was not reset correctly!");
		end

		if (tb_shift_strobe == 1'b0) begin
			$info("The shift_strobe reset correctly.");
		end else begin
			$info("ERROR: The shift_strobe was not reset correctly!");
		end

		/*if (tb_packet_done == 1'b0) begin
			$info("The packet_done reset correctly.");
		end else begin
			$info("ERROR: The packet_done was not reset correctly!");
		end */

		#(2 * CLK_PERIOD);

		tb_n_rst = 1'b1; // Deassert reset.

		/* === Test Case 2 === */

		#(2 * CLK_PERIOD);
		tb_enable_timer = 1'b1; // Assert timer.

		#(10 * CLK_PERIOD); // 10 clock cycles.

		if (tb_shift_strobe == 1'b1) begin
			$info("The shift_strobe is working correctly.");
		end else begin
			$info("ERROR: The shift_strobe is not working correctly!");
		end

		#(9 * CLK_PERIOD); // 10 clock cycles.

		if (tb_packet_done == 1'b1) begin
			$info("The packet_done is working correctly.");
		end else begin
			$info("ERROR: The packet_done is not working correctly!");
		end

		#(2 * CLK_PERIOD);

	end

endmodule
