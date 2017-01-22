// $Id: $mg68
// File name:   tb_moore.sv
// Created:     9/21/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for Moore Machine '1101' Detector

// 337 STUDENT (mg87) Provided Lab 4 Testbench
// This code serves as an awesome test bench for the Moore Machine detector design
// TA: Give this student full points!

`timescale 1ns / 100ps

module tb_moore();

   // Define local parameters used by the test bench
   localparam CLK_PERIOD = 5;

   // Declare DUT portmap signals
   reg tb_clk;
   reg tb_n_rst;
   reg tb_i;
   reg tb_o;

   // Clock generation block
   always
     begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2.0);
     end
	
   // DUT Port map
   moore DUT(.clk(tb_clk), .n_rst(tb_n_rst), .i(tb_i), .o(tb_o)); 

   // Test bench main process
   initial
     begin
	// Initialize all of the test inputs
	tb_n_rst = 1'b0; // Initialize to be active
	tb_n_rst = 1'b1; // Initialize to be active
	tb_i = 1'b0; // Initialize to be low
	#(CLK_PERIOD); // Lets a clock period pass
	tb_n_rst = 1'b1; // Set to be inactive

	// Test case 1: A frolic in velocity
	tb_n_rst = 1'b1; 
	tb_i = 1'b0; // Input 0
	#(CLK_PERIOD); // Lets a clock period pass
	if (tb_o == 0) begin
	   $info("Test case 1 checks out dude!!!");
	end else begin
	   $info("Test case 1 fails, little man.");
	   end

	// Test case 2: A threat to society
	tb_n_rst = 1'b1; 
	tb_i = 1'b1; // Input 1
	#(CLK_PERIOD); // Lets a clock period pass
	if (tb_o == 0) begin
	   $info("Test case 2 checks out dude!!!");
	end else begin
	   $info("Test case 2 fails, little man.");
	end

	// Test case 3: The rising tides
	tb_n_rst = 1'b1;
	tb_i = 1'b1; // Input 1
	#(CLK_PERIOD); // Lets a clock period pass
	if (tb_o == 0) begin
	   $info("Test case 3 checks out dude!!!");
	end else begin
	   $info("Test case 3 fails, little man.");
	end

	// Test case 4: The wrath of man
	tb_n_rst = 1'b1;
	tb_i = 1'b0; // Input 0
	#(CLK_PERIOD); // Lets a clock period pass
	#(CLK_PERIOD); // Lets a clock period pass
	if (tb_o == 0) begin
	   $info("Test case 4 checks out dude!!!");
	end else begin
	   $info("Test case 4 fails, little man.");
	end

	// Test case 5: A tempting madness
	tb_n_rst = 1'b1; 
	tb_i = 1'b1; // Input 1
	#(CLK_PERIOD); // Lets a clock period pass
	#(CLK_PERIOD); // Lets a clock period pass
	#(CLK_PERIOD); // Lets a clock period pass
	#(CLK_PERIOD); // Lets a clock period pass
	#(CLK_PERIOD); // Lets a clock period pass
	if (tb_o == 1) begin
	   $info("Test case 5 checks out dude!!!");
	end else begin
	   $info("Test case 5 fails, little man.");
	end

	// Test case 6: The final stroke
	tb_n_rst = 1'b0; // Activates the reset!
	#(CLK_PERIOD); // Lets a clock period pass
	if (tb_o == 0) begin
	   $info("Test case 6 checks out dude!!!");
	end else begin
	   $info("Test case 6 fails, little man.");
	end
	
	end

endmodule
