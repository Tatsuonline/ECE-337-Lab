// $Id: $
// File name:   tb_flex_pts_sr.sv
// Created:     9/2/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Flexible Parallel to Serial shift register test bench

`timescale 1ns / 10ps

module tb_flex_pts_sr ();

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
	reg [DEFAULT_MAX_BIT:0] tb_default_parallel_in;
	reg tb_default_shift_en;
	reg tb_default_load_en;
	reg tb_default_serial_out;
	
	// Config 1 Test Variables & constants
	localparam CONFIG1_SIZE = 8;
	localparam CONFIG1_MAX_BIT = (CONFIG1_SIZE - 1);
	localparam CONFIG1_MSB = 1;
	
	integer tb_config1_test_num;
	integer tb_config1_i;
	integer tb_config1_fail_cnt;
	reg tb_config1_n_reset;
	reg [CONFIG1_MAX_BIT:0] tb_config1_parallel_in;
	reg tb_config1_shift_en;
	reg tb_config1_load_en;
	reg tb_config1_serial_out;
	
	// Config 2 Test Variables & constants
	localparam CONFIG2_SIZE = 4;
	localparam CONFIG2_MAX_BIT = (CONFIG2_SIZE - 1);
	localparam CONFIG2_MSB = 0;
	
	integer tb_config2_test_num;
	integer tb_config2_i;
	integer tb_config2_fail_cnt;
	reg tb_config2_n_reset;
	reg [CONFIG2_MAX_BIT:0] tb_config2_parallel_in;
	reg tb_config2_shift_en;
	reg tb_config2_load_en;
	reg tb_config2_serial_out;
	
	
	// DUT portmaps
	flex_pts_sr DEFAULT
	(
		.clk(tb_clk),
		.n_rst(tb_default_n_reset),
		.parallel_in(tb_default_parallel_in),
		.shift_enable(tb_default_shift_en),
		.load_enable(tb_default_load_en),
		.serial_out(tb_default_serial_out)
	);
	
	pts_sr_8_msb CONFIG1
	(
		.clk(tb_clk),
		.n_rst(tb_config1_n_reset),
		.parallel_in(tb_config1_parallel_in),
		.shift_enable(tb_config1_shift_en),
		.load_enable(tb_config1_load_en),
		.serial_out(tb_config1_serial_out)
	);
	
	pts_sr_4_lsb CONFIG2
	(
		.clk(tb_clk),
		.n_rst(tb_config2_n_reset),
		.parallel_in(tb_config2_parallel_in),
		.shift_enable(tb_config2_shift_en),
		.load_enable(tb_config2_load_en),
		.serial_out(tb_config2_serial_out)
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
		tb_default_n_reset		= 1'b1;				// Initialize to be inactive
		// Initialize parallel in to be idle values
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en		= 1'b0;				// Initialize to be inactive
		tb_default_load_en		= 1'b0;				// Initialize to be inactive
		tb_default_test_num 	= 0;
		
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
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en = 1'b0;
		#(CHECK_DELAY);
		if (1'b1 == tb_default_serial_out)
			$info("Default Test Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Test Case %0d:: FAILED", tb_default_test_num);
		
		// Test 2: Check for Proper Reset w/ Active inputs
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		tb_default_n_reset = 1'b0;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b0;
		end
		tb_default_load_en = 1'b1;
		tb_default_shift_en = 1'b1;
		@(posedge tb_clk);
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_default_serial_out)
			$info("Default Test Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Test Case %0d:: FAILED", tb_default_test_num);
			
		// Test 3: Check for Proper Load Enable Control w/ load enable off and shift enable off
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en = 1'b0;
		tb_default_load_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b0;
		end
		tb_default_shift_en = 1'b0;
		tb_default_load_en = 1'b0;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_default_serial_out)
			$info("Default Test Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Test Case %0d:: FAILED", tb_default_test_num);
			
		// Test 4: Check for Proper Load Enable Control w/ load enable off and shift enable on
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en = 1'b0;
		tb_default_load_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b0;
		end
		tb_default_shift_en = 1'b1;
		tb_default_load_en = 1'b0;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_default_serial_out)
			$info("Default Test Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Test Case %0d:: FAILED", tb_default_test_num);
			
		// Test 5: Check for Proper Load Enable Control w/ enable on and shift enable on
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b0;
		end
		tb_default_shift_en = 1'b1;
		tb_default_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_default_parallel_in[DEFAULT_MAX_BIT] == tb_default_serial_out)
			$info("Default Test Case %0d:: PASSED", tb_default_test_num);
		else // Test case failed
			$error("Default Test Case %0d:: FAILED", tb_default_test_num);
			
		// Test 6: Check for Proper Load Enable Control w/ enable on for one cycle and shift enable off for at least one
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		// Perform load
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			if(DEFAULT_MAX_BIT == tb_default_i)
				tb_default_parallel_in[tb_default_i] = 1'b0;
			else
				tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en = 1'b0;
		tb_default_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_default_parallel_in[DEFAULT_MAX_BIT] == tb_default_serial_out)
		begin
			// Check that value stays loaded and unshifted with both are off
			tb_default_shift_en = 1'b0;
			tb_default_load_en = 1'b0;
			@(posedge tb_clk);
			#(CHECK_DELAY);
			if (tb_default_parallel_in[DEFAULT_MAX_BIT] == tb_default_serial_out)
				$info("Default Test Case %0d:: PASSED", tb_default_test_num);
			else // Test case failed
				$error("Default Test Case %0d:: FAILED", tb_default_test_num);
		end
		else // Test case failed
			$error("Default Test Case %0d:: FAILED", tb_default_test_num);
			
		// Test 7: Check for Normal operation (load then shift)
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_default_test_num = tb_default_test_num + 1;
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			tb_default_parallel_in[tb_default_i] = 1'b1;
		end
		tb_default_shift_en = 1'b0;
		tb_default_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_default_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		// Perform load
		for(tb_default_i = 0; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
		begin
			if(0 == (tb_default_i % 2)) // Even bit
				tb_default_parallel_in[tb_default_i] = 1'b1;
			else // Odd bit
				tb_default_parallel_in[tb_default_i] = 1'b0;
		end
		tb_default_shift_en = 1'b0;
		tb_default_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_default_parallel_in[DEFAULT_MAX_BIT] == tb_default_serial_out)
		begin
			// Start shifting and track failures
			tb_default_shift_en = 1'b1;
			#(100ps)
			tb_default_load_en = 1'b0;
			tb_default_fail_cnt = 0;
			for(tb_default_i = 1; tb_default_i < DEFAULT_SIZE; tb_default_i = tb_default_i + 1)
			begin
				@(posedge tb_clk);
				#(CHECK_DELAY);
				if (tb_default_parallel_in[(DEFAULT_MAX_BIT - tb_default_i)] != tb_default_serial_out)
				begin
					// Current shift test failed
					tb_default_fail_cnt = tb_default_fail_cnt + 1;
				end
			end
			
			// Check if a failure occured
			if(0 < tb_default_fail_cnt)
			begin
				// Test failed
				$error("Default Test Case %0d:: FAILED", tb_default_test_num);
			end
			else // Test case passed
			begin
				$info("Default Test Case %0d:: PASSED", tb_default_test_num);
			end
		end
		else // Test case failed
			$error("Default Test Case %0d:: FAILED", tb_default_test_num);
	end
	
	// Config 1 Configuration (8-bit MSB) Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_config1_n_reset		= 1'b1;				// Initialize to be inactive
		// Initialize parallel in to be idle values
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en		= 1'b0;				// Initialize to be inactive
		tb_config1_load_en		= 1'b0;				// Initialize to be inactive
		tb_config1_test_num 	= 0;
		
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
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en = 1'b0;
		#(CHECK_DELAY);
		if (1'b1 == tb_config1_serial_out)
			$info("Scaled Size Test Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
		
		// Test 2: Check for Proper Reset w/ Active inputs
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		tb_config1_n_reset = 1'b0;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b0;
		end
		tb_config1_load_en = 1'b1;
		tb_config1_shift_en = 1'b1;
		@(posedge tb_clk);
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_config1_serial_out)
			$info("Scaled Size Test Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
			
		// Test 3: Check for Proper Load Enable Control w/ load enable off and shift enable off
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_load_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b0;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_load_en = 1'b0;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_config1_serial_out)
			$info("Scaled Size Test Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
			
		// Test 4: Check for Proper Load Enable Control w/ load enable off and shift enable on
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_load_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b0;
		end
		tb_config1_shift_en = 1'b1;
		tb_config1_load_en = 1'b0;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_config1_serial_out)
			$info("Scaled Size Test Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
			
		// Test 5: Check for Proper Load Enable Control w/ enable on and shift enable on
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b0;
		end
		tb_config1_shift_en = 1'b1;
		tb_config1_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config1_parallel_in[CONFIG1_MAX_BIT] == tb_config1_serial_out)
			$info("Scaled Size Test Case %0d:: PASSED", tb_config1_test_num);
		else // Test case failed
			$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
			
		// Test 6: Check for Proper Load Enable Control w/ enable on for one cycle and shift enable off for at least one
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		// Perform load
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			if(CONFIG1_MAX_BIT == tb_config1_i)
				tb_config1_parallel_in[tb_config1_i] = 1'b0;
			else
				tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config1_parallel_in[CONFIG1_MAX_BIT] == tb_config1_serial_out)
		begin
			// Check that value stays loaded and unshifted with both are off
			tb_config1_shift_en = 1'b0;
			tb_config1_load_en = 1'b0;
			@(posedge tb_clk);
			#(CHECK_DELAY);
			if (tb_config1_parallel_in[CONFIG1_MAX_BIT] == tb_config1_serial_out)
				$info("Scaled Size Test Case %0d:: PASSED", tb_config1_test_num);
			else // Test case failed
				$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
		end
		else // Test case failed
			$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
			
		// Test 7: Check for Normal operation (load then shift)
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config1_test_num = tb_config1_test_num + 1;
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			tb_config1_parallel_in[tb_config1_i] = 1'b1;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config1_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		// Perform load
		for(tb_config1_i = 0; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
		begin
			if(0 == (tb_config1_i % 2)) // Even bit
				tb_config1_parallel_in[tb_config1_i] = 1'b1;
			else // Odd bit
				tb_config1_parallel_in[tb_config1_i] = 1'b0;
		end
		tb_config1_shift_en = 1'b0;
		tb_config1_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config1_parallel_in[CONFIG1_MAX_BIT] == tb_config1_serial_out)
		begin
			// Start shifting and track failures
			tb_config1_shift_en = 1'b1;
			tb_config1_load_en = 1'b0;
			tb_config1_fail_cnt = 0;
			for(tb_config1_i = 1; tb_config1_i < CONFIG1_SIZE; tb_config1_i = tb_config1_i + 1)
			begin
				@(posedge tb_clk);
				#(CHECK_DELAY);
				if (tb_config1_parallel_in[(CONFIG1_MAX_BIT - tb_config1_i)] != tb_config1_serial_out)
				begin
					// Current shift test failed
					tb_config1_fail_cnt = tb_config1_fail_cnt + 1;
				end
			end
			
			// Check if a failure occured
			if(0 < tb_config1_fail_cnt)
			begin
				// Test failed
				$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
			end
			else // Test case passed
			begin
				$info("Scaled Size Test Case %0d:: PASSED", tb_config1_test_num);
			end
		end
		else // Test case failed
			$error("Scaled Size Test Case %0d:: FAILED", tb_config1_test_num);
	end

	// Config 2 Configuration (4-bit LSB) Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_config2_n_reset		= 1'b1;				// Initialize to be inactive
		// Initialize parallel in to be idle values
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en		= 1'b0;				// Initialize to be inactive
		tb_config2_load_en		= 1'b0;				// Initialize to be inactive
		tb_config2_test_num 	= 0;
		
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
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en = 1'b0;
		#(CHECK_DELAY);
		if (1'b1 == tb_config2_serial_out)
			$info("LSB Test Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
		
		// Test 2: Check for Proper Reset w/ Active inputs
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		tb_config2_n_reset = 1'b0;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b0;
		end
		tb_config2_load_en = 1'b1;
		tb_config2_shift_en = 1'b1;
		@(posedge tb_clk);
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_config2_serial_out)
			$info("LSB Test Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
			
		// Test 3: Check for Proper Load Enable Control w/ load enable off and shift enable off
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_load_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b0;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_load_en = 1'b0;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_config2_serial_out)
			$info("LSB Test Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
			
		// Test 4: Check for Proper Load Enable Control w/ load enable off and shift enable on
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_load_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b0;
		end
		tb_config2_shift_en = 1'b1;
		tb_config2_load_en = 1'b0;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (1'b1 == tb_config2_serial_out)
			$info("LSB Test Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
			
		// Test 5: Check for Proper Load Enable Control w/ enable on and shift enable on
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b0;
		end
		tb_config2_shift_en = 1'b1;
		tb_config2_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config2_parallel_in[0] == tb_config2_serial_out) // Need to check against the LSB bit of the parallel in
			$info("LSB Test Case %0d:: PASSED", tb_config2_test_num);
		else // Test case failed
			$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
			
		// Test 6: Check for Proper Load Enable Control w/ enable on for one cycle and shift enable off for at least one
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		// Perform load
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			if(CONFIG2_MAX_BIT == tb_config2_i)
				tb_config2_parallel_in[tb_config2_i] = 1'b0;
			else
				tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config2_parallel_in[0] == tb_config2_serial_out) // Need to check against the LSB bit of the parallel in
		begin
			// Check that value stays loaded and unshifted with both are off
			tb_config2_shift_en = 1'b0;
			tb_config2_load_en = 1'b0;
			@(posedge tb_clk);
			#(CHECK_DELAY);
			if (tb_config2_parallel_in[0] == tb_config2_serial_out) // Need to check against the LSB bit of the parallel in
				$info("LSB Test Case %0d:: PASSED", tb_config2_test_num);
			else // Test case failed
				$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
		end
		else // Test case failed
			$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
			
		// Test 7: Check for Normal operation (load then shift)
		// Power-on Reset of the DUT (Best case conditions)
		@(negedge tb_clk); 
		tb_config2_test_num = tb_config2_test_num + 1;
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			tb_config2_parallel_in[tb_config2_i] = 1'b1;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_n_reset	= 1'b0; 	
		#(CLK_PERIOD * 2);
		@(negedge tb_clk);	// Release the reset away from a clock edge
		tb_config2_n_reset	= 1'b1;	// Deactivate the chip reset
		// Perform test
		// Perform load
		for(tb_config2_i = 0; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
		begin
			if(0 == (tb_config2_i % 2)) // Even bit
				tb_config2_parallel_in[tb_config2_i] = 1'b1;
			else // Odd bit
				tb_config2_parallel_in[tb_config2_i] = 1'b0;
		end
		tb_config2_shift_en = 1'b0;
		tb_config2_load_en = 1'b1;
		@(posedge tb_clk);
		#(CHECK_DELAY);
		if (tb_config2_parallel_in[0] == tb_config2_serial_out) // Need to check against the LSB bit of the parallel in
		begin
			// Start shifting and track failures
			tb_config2_shift_en = 1'b1;
			tb_config2_load_en = 1'b0;
			tb_config2_fail_cnt = 0;
			for(tb_config2_i = 1; tb_config2_i < CONFIG2_SIZE; tb_config2_i = tb_config2_i + 1)
			begin
				@(posedge tb_clk);
				#(CHECK_DELAY);
				if (tb_config2_parallel_in[tb_config2_i] != tb_config2_serial_out)
				begin
					// Current shift test failed
					tb_config2_fail_cnt = tb_config2_fail_cnt + 1;
				end
			end
			
			// Check if a failure occured
			if(0 < tb_config2_fail_cnt)
			begin
				// Test failed
				$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
			end
			else // Test case passed
			begin
				$info("LSB Test Case %0d:: PASSED", tb_config2_test_num);
			end
		end
		else // Test case failed
			$error("LSB Test Case %0d:: FAILED", tb_config2_test_num);
	end
	
endmodule