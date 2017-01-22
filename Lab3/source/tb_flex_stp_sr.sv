// $Id: $
// File name:   tb_flex_stp_sr.sv
// Created:     9/2/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Flexible Serial to Parallel Shift register test bench

`timescale 1ns / 10ps

module tb_flex_stp_sr ();

	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD	= 2.5;
	localparam	CHECK_DELAY = 1; // Check 1ns after the rising edge to allow for propagation delay
	
	// Shared Test Variables
	reg tb_clk;
	
	// Default Config Test Variables & constants
	localparam DEFAULT_SIZE = 4;
	localparam DEFAULT_MAX_BIT = (DEFAULT_SIZE - 1);
	localparam DEFAULT_MSB = 1;
	
	integer tb_default_test_num;
	integer tb_default_i;
	integer tb_default_fail_cnt;
	reg tb_default_n_reset;
	reg [DEFAULT_MAX_BIT:0] tb_default_parallel_out;
	reg tb_default_shift_en;
	reg tb_default_serial_in;
	reg [DEFAULT_MAX_BIT:0] tb_default_test_data;
	reg [DEFAULT_MAX_BIT:0] tb_default_expected_out;
	
	// Config 1 Test Variables & constants
	localparam CONFIG1_SIZE = 8;
	localparam CONFIG1_MAX_BIT = (CONFIG1_SIZE - 1);
	localparam CONFIG1_MSB = 1;
	
	integer tb_config1_test_num;
	integer tb_config1_i;
	integer tb_config1_fail_cnt;
	reg tb_config1_n_reset;
	reg [CONFIG1_MAX_BIT:0] tb_config1_parallel_out;
	reg tb_config1_shift_en;
	reg tb_config1_serial_in;
	reg [CONFIG1_MAX_BIT:0] tb_config1_test_data;
	reg [CONFIG1_MAX_BIT:0] tb_config1_expected_out;
	
	// Config 2 Test Variables & constants
	localparam CONFIG2_SIZE = 4;
	localparam CONFIG2_MAX_BIT = (CONFIG2_SIZE - 1);
	localparam CONFIG2_MSB = 0;
	
	integer tb_config2_test_num;
	integer tb_config2_i;
	integer tb_config2_fail_cnt;
	reg tb_config2_n_reset;
	reg [CONFIG2_MAX_BIT:0] tb_config2_parallel_out;
	reg tb_config2_shift_en;
	reg tb_config2_serial_in;
	reg [CONFIG2_MAX_BIT:0] tb_config2_test_data;
	reg [CONFIG2_MAX_BIT:0] tb_config2_expected_out;
	
	
	// DUT portmaps
	flex_stp_sr DEFAULT
	(
		.clk(tb_clk),
		.n_rst(tb_default_n_reset),
		.serial_in(tb_default_serial_in),
		.shift_enable(tb_default_shift_en),
		.parallel_out(tb_default_parallel_out)
	);
	
	stp_sr_8_msb CONFIG1
	(
		.clk(tb_clk),
		.n_rst(tb_config1_n_reset),
		.serial_in(tb_config1_serial_in),
		.shift_enable(tb_config1_shift_en),
		.parallel_out(tb_config1_parallel_out)
	);
	
	stp_sr_4_lsb CONFIG2
	(
		.clk(tb_clk),
		.n_rst(tb_config2_n_reset),
		.serial_in(tb_config2_serial_in),
		.shift_enable(tb_config2_shift_en),
		.parallel_out(tb_config2_parallel_out)
	);
	
	// Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
	// Default Configuration Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_default_n_reset		= 1'b1;		// Initialize to be inactive
		tb_default_serial_in	= 1'b1;		// Initialize to be idle
		tb_default_shift_en		= 1'b0;		// Initialize to be inactive
		tb_default_test_num 	= 0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b1;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b1;
		end
		
		// Power-on Reset of the DUT
		#(0.1);
		tb_default_n_reset	= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
		#(CLK_PERIOD * 2.25);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1; 	// Deactivate the chip reset
		
		// Wait for a while to see normal operation
		#(CLK_PERIOD);
		
		// Test 1: Check for Proper Reset w/ Idle input
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_n_reset = 1'b0;
		tb_default_serial_in = 1'b1;
		tb_default_shift_en = 1'b0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b1;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b1;
		end
		#(CHECK_DELAY);
		if (tb_default_test_data == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 2: Check for Proper Reset w/ Active inputs
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_n_reset = 1'b0;
		tb_default_serial_in = 1'b0;
		tb_default_shift_en = 1'b1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b1;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b1;
		end
		@(posedge tb_clk);
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_default_test_data == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 3: Check for Proper Shift Enable Control w/ enable off
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 1'b1;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_default_serial_in = 1'b0;
		tb_default_shift_en = 1'b0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b1;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b1;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_default_test_data == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 4: Check for Proper Shift Enable Control w/ enable on for one shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 1'b1;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_default_serial_in = 1'b0;
		tb_default_shift_en = 1'b1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			if(DEFAULT_MAX_BIT == tb_default_i) // MSB -> Most significant bit is the fireset one sent
				tb_default_test_data[tb_default_i] = 1'b0;
			else
				tb_default_test_data[tb_default_i] = 1'b1;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b1;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		tb_default_expected_out = {tb_default_expected_out[(DEFAULT_MAX_BIT - 1):0], tb_default_serial_in}; // Shift test data
		if (tb_default_expected_out == tb_default_parallel_out)
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		
		// Test 5: Check for Proper Shift Enable Control w/ enable on for full value shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 1'b1;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_default_shift_en = 1'b1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_test_data[tb_default_i] = 1'b0;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b1;
		end
		// Shift through the full value and track failure(s)
		tb_default_fail_cnt = 0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			// Assign the new serial input value
			tb_default_serial_in = tb_default_test_data[(DEFAULT_MAX_BIT - tb_default_i)]; 
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_default_expected_out = {tb_default_expected_out[(DEFAULT_MAX_BIT - 1):0], tb_default_serial_in}; 
			// Compare expected output with actual and track failure(s)
			if (tb_default_expected_out != tb_default_parallel_out)
			begin
				// Current shift failed
				tb_default_fail_cnt = tb_default_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_default_fail_cnt)
		begin
			// Test failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		end
		else
		begin
			// Test passed
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		end
		
		// Test 6: Check for Proper Shift Enable Control w/ enable on and mixed values
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_serial_in = 1'b1;
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_default_shift_en = 1'b1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			if(0 == (tb_default_i % 2)) // Even bit
				tb_default_test_data[tb_default_i] = 1'b1;
			else // Odd bit
				tb_default_test_data[tb_default_i] = 1'b0;
		end
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_expected_out[tb_default_i] = 1'b1;
		end
		// Shift through the full value and track failure(s)
		tb_default_fail_cnt = 0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			// Assign the new serial input value
			tb_default_serial_in = tb_default_test_data[(DEFAULT_MAX_BIT - tb_default_i)]; 
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_default_expected_out = {tb_default_expected_out[(DEFAULT_MAX_BIT - 1):0], tb_default_serial_in}; 
			// Compare expected output with actual and track failure(s)
			if (tb_default_expected_out != tb_default_parallel_out)
			begin
				// Current shift failed
				tb_default_fail_cnt = tb_default_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_default_fail_cnt)
		begin
			// Test failed
			$error("Default Case %0d:: FAILED", tb_default_test_num);
		end
		else
		begin
			// Test passed
			$info("Default Case %0d:: PASSED", tb_default_test_num);
		end
	end
	
	// Config 1 Configuration (8-bit MSB) Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_config1_n_reset		= 1'b1;		// Initialize to be inactive
		tb_config1_serial_in	= 1'b1;		// Initialize to be idle
		tb_config1_shift_en		= 1'b0;		// Initialize to be inactive
		tb_config1_test_num 	= 0;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_test_data[tb_config1_i] = 1'b1;
		end
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_expected_out[tb_config1_i] = 1'b1;
		end
		
		// Power-on Reset of the DUT
		#(0.1);
		tb_config1_n_reset	= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
		#(CLK_PERIOD * 2.25);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1; 	// Deactivate the chip reset
		
		// Wait for a while to see normal operation
		#(CLK_PERIOD);
		
		// Test 1: Check for Proper Reset w/ Idle input
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		tb_config1_n_reset = 1'b0;
		tb_config1_serial_in = 1'b1;
		tb_config1_shift_en = 1'b0;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_test_data[tb_config1_i] = 1'b1;
		end
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_expected_out[tb_config1_i] = 1'b1;
		end
		#(CHECK_DELAY);
		if (tb_config1_test_data == tb_config1_parallel_out)
			$info("Scaled Size Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Case %0d:: FAILED", tb_config1_test_num);
		
		// Test 2: Check for Proper Reset w/ Active inputs
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		tb_config1_n_reset = 1'b0;
		tb_config1_serial_in = 1'b0;
		tb_config1_shift_en = 1'b1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_test_data[tb_config1_i] = 1'b1;
		end
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_expected_out[tb_config1_i] = 1'b1;
		end
		@(posedge tb_clk);
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config1_test_data == tb_config1_parallel_out)
			$info("Scaled Size Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Case %0d:: FAILED", tb_config1_test_num);
		
		// Test 3: Check for Proper Shift Enable Control w/ enable off
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		tb_config1_serial_in = 1'b1;
		tb_config1_shift_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_config1_serial_in = 1'b0;
		tb_config1_shift_en = 1'b0;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_test_data[tb_config1_i] = 1'b1;
		end
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_expected_out[tb_config1_i] = 1'b1;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config1_test_data == tb_config1_parallel_out)
			$info("Scaled Size Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Case %0d:: FAILED", tb_config1_test_num);
		
		// Test 4: Check for Proper Shift Enable Control w/ enable on for one shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		tb_config1_serial_in = 1'b1;
		tb_config1_shift_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_config1_serial_in = 1'b0;
		tb_config1_shift_en = 1'b1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			if(CONFIG1_MAX_BIT == tb_config1_i) // MSB -> Most significant bit is the fireset one sent
				tb_config1_test_data[tb_config1_i] = 1'b0;
			else
				tb_config1_test_data[tb_config1_i] = 1'b1;
		end
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_expected_out[tb_config1_i] = 1'b1;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		tb_config1_expected_out = {tb_config1_expected_out[(CONFIG1_MAX_BIT - 1):0], tb_config1_serial_in}; // Shift test data
		if (tb_config1_expected_out == tb_config1_parallel_out)
			$info("Scaled Size Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Case %0d:: FAILED", tb_config1_test_num);
		
		// Test 5: Check for Proper Shift Enable Control w/ enable on for full value shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		tb_config1_serial_in = 1'b1;
		tb_config1_shift_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_config1_shift_en = 1'b1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_test_data[tb_config1_i] = 1'b0;
		end
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_expected_out[tb_config1_i] = 1'b1;
		end
		// Shift through the full value and track failure(s)
		tb_config1_fail_cnt = 0;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			// Assign the new serial input value
			tb_config1_serial_in = tb_config1_test_data[(CONFIG1_MAX_BIT - tb_config1_i)]; 
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_config1_expected_out = {tb_config1_expected_out[(CONFIG1_MAX_BIT - 1):0], tb_config1_serial_in}; 
			// Compare expected output with actual and track failure(s)
			if (tb_config1_expected_out != tb_config1_parallel_out)
			begin
				// Current shift failed
				tb_config1_fail_cnt = tb_config1_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_config1_fail_cnt)
		begin
			// Test failed
			$error("Scaled Size Case %0d:: FAILED", tb_config1_test_num);
		end
		else
		begin
			// Test passed
			$info("Scaled Size Case %0d:: PASSED", tb_config1_test_num);
		end
		
		// Test 6: Check for Proper Shift Enable Control w/ enable on and mixed values
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		tb_config1_serial_in = 1'b1;
		tb_config1_shift_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_config1_shift_en = 1'b1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			if(0 == (tb_config1_i % 2)) // Even bit
				tb_config1_test_data[tb_config1_i] = 1'b1;
			else // Odd bit
				tb_config1_test_data[tb_config1_i] = 1'b0;
		end
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_expected_out[tb_config1_i] = 1'b1;
		end
		// Shift through the full value and track failure(s)
		tb_config1_fail_cnt = 0;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			// Assign the new serial input value
			tb_config1_serial_in = tb_config1_test_data[(CONFIG1_MAX_BIT - tb_config1_i)]; 
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_config1_expected_out = {tb_config1_expected_out[(CONFIG1_MAX_BIT - 1):0], tb_config1_serial_in}; 
			// Compare expected output with actual and track failure(s)
			if (tb_config1_expected_out != tb_config1_parallel_out)
			begin
				// Current shift failed
				tb_config1_fail_cnt = tb_config1_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_config1_fail_cnt)
		begin
			// Test failed
			$error("Scaled Size Case %0d:: FAILED", tb_config1_test_num);
		end
		else
		begin
			// Test passed
			$info("Scaled Size Case %0d:: PASSED", tb_config1_test_num);
		end
	end
	
	// LSB Configuration (4-bit LSB) Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_config2_n_reset		= 1'b1;		// Initialize to be inactive
		tb_config2_serial_in	= 1'b1;		// Initialize to be idle
		tb_config2_shift_en		= 1'b0;		// Initialize to be inactive
		tb_config2_test_num 	= 0;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_test_data[tb_config2_i] = 1'b1;
		end
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_expected_out[tb_config2_i] = 1'b1;
		end
		
		// Power-on Reset of the DUT
		#(0.1);
		tb_config2_n_reset	= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
		#(CLK_PERIOD * 2.25);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1; 	// Deactivate the chip reset
		
		// Wait for a while to see normal operation
		#(CLK_PERIOD);
		
		// Test 1: Check for Proper Reset w/ Idle input
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		tb_config2_n_reset = 1'b0;
		tb_config2_serial_in = 1'b1;
		tb_config2_shift_en = 1'b0;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_test_data[tb_config2_i] = 1'b1;
		end
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_expected_out[tb_config2_i] = 1'b1;
		end
		#(CHECK_DELAY);
		if (tb_config2_test_data == tb_config2_parallel_out)
			$info("LSB Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Case %0d:: FAILED", tb_config2_test_num);
		
		// Test 2: Check for Proper Reset w/ Active inputs
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		tb_config2_n_reset = 1'b0;
		tb_config2_serial_in = 1'b0;
		tb_config2_shift_en = 1'b1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_test_data[tb_config2_i] = 1'b1;
		end
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_expected_out[tb_config2_i] = 1'b1;
		end
		@(posedge tb_clk);
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config2_test_data == tb_config2_parallel_out)
			$info("LSB Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Case %0d:: FAILED", tb_config2_test_num);
		
		// Test 3: Check for Proper Shift Enable Control w/ enable off
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		tb_config2_serial_in = 1'b1;
		tb_config2_shift_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_config2_serial_in = 1'b0;
		tb_config2_shift_en = 1'b0;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_test_data[tb_config2_i] = 1'b1;
		end
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_expected_out[tb_config2_i] = 1'b1;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config2_test_data == tb_config2_parallel_out)
			$info("LSB Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Case %0d:: FAILED", tb_config2_test_num);
		
		// Test 4: Check for Proper Shift Enable Control w/ enable on for one shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		tb_config2_serial_in = 1'b1;
		tb_config2_shift_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		tb_config2_serial_in = 1'b0;
		tb_config2_shift_en = 1'b1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			if(0 == tb_config2_i) // LSB -> Least significant bit is the fireset one sent
				tb_config2_test_data[tb_config2_i] = 1'b0;
			else
				tb_config2_test_data[tb_config2_i] = 1'b1;
		end
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_expected_out[tb_config2_i] = 1'b1;
		end
		@(posedge tb_clk);
		#(CHECK_DELAY);
		tb_config2_expected_out = {tb_config2_serial_in, tb_config2_expected_out[CONFIG2_MAX_BIT:1]}; // Shift test data LSB
		if (tb_config2_expected_out == tb_config2_parallel_out)
			$info("LSB Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Case %0d:: FAILED", tb_config2_test_num);
		
		// Test 5: Check for Proper Shift Enable Control w/ enable on for full value shift
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		tb_config2_serial_in = 1'b1;
		tb_config2_shift_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_config2_shift_en = 1'b1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_test_data[tb_config2_i] = 1'b0;
		end
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_expected_out[tb_config2_i] = 1'b1;
		end
		// Shift through the full value and track failure(s)
		tb_config2_fail_cnt = 0;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			// Assign the new serial input value
			tb_config2_serial_in = tb_config2_test_data[tb_config2_i]; // LSB -> Least significant sent fireset
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_config2_expected_out = {tb_config2_serial_in, tb_config2_expected_out[CONFIG2_MAX_BIT:1]}; // Shift test data LSB
			// Compare expected output with actual and track failure(s)
			if (tb_config2_expected_out != tb_config2_parallel_out)
			begin
				// Current shift failed
				tb_config2_fail_cnt = tb_config2_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_config2_fail_cnt)
		begin
			// Test failed
			$error("LSB Case %0d:: FAILED", tb_config2_test_num);
		end
		else
		begin
			// Test passed
			$info("LSB Case %0d:: PASSED", tb_config2_test_num);
		end
		
		// Test 6: Check for Proper Shift Enable Control w/ enable on and mixed values
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		tb_config2_serial_in = 1'b1;
		tb_config2_shift_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Prep for shifting
		tb_config2_shift_en = 1'b1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			if(0 == (tb_config2_i % 2)) // Even bit
				tb_config2_test_data[tb_config2_i] = 1'b1;
			else // Odd bit
				tb_config2_test_data[tb_config2_i] = 1'b0;
		end
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_expected_out[tb_config2_i] = 1'b1;
		end
		// Shift through the full value and track failure(s)
		tb_config2_fail_cnt = 0;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			// Assign the new serial input value
			tb_config2_serial_in = tb_config2_test_data[tb_config2_i]; // LSB -> Least significant sent fireset
			// Perform shift
			@(posedge tb_clk);
			#(CHECK_DELAY);
			// Updated expected output calculation
			tb_config2_expected_out = {tb_config2_serial_in, tb_config2_expected_out[CONFIG2_MAX_BIT:1]}; // Shift test data LSB
			// Compare expected output with actual and track failure(s)
			if (tb_config2_expected_out != tb_config2_parallel_out)
			begin
				// Current shift failed
				tb_config2_fail_cnt = tb_config2_fail_cnt + 1;
			end
		end
		// Check for failure(s)
		if(0 < tb_config2_fail_cnt)
		begin
			// Test failed
			$error("LSB Case %0d:: FAILED", tb_config2_test_num);
		end
		else
		begin
			// Test passed
			$info("LSB Case %0d:: PASSED", tb_config2_test_num);
		end
	end
	
endmodule
