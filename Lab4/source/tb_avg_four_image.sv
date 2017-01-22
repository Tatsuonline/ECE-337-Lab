// $Id: $
// File name:   tb_avg_four.sv
// Created:     1/25/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: A test bench for the avg_four that feeds grayscale images through the avg_four design

// Time values are specified with default units of 1ns and to a resolution of 100ps
`timescale 1ns / 100ps

module tb_avg_four_image();

	// Define constants
	`define SEEK_START	0
	`define SEEK_CUR		1
	`define SEEK_END		2
	
	// Define parameters
	// basic test bench parameters
	localparam	CLK_PERIOD				= 5;
	localparam	PROCESSING_PERIOD	= 20 * CLK_PERIOD;
	localparam	SAMPLE_PERIOD			= PROCESSING_PERIOD + (5 * CLK_PERIOD);
	localparam	DATA_SIZE 				= 16;
	localparam	OVERFLOW_VAL 			= 2 ** 16;
	localparam	MAX_VAL 					= OVERFLOW_VAL - 1;
	parameter		INPUT_FILENAME		= "./docs/test_1.bmp";
	parameter		RESULT_FILENAME		= "./docs/filtered_1.bmp";

	// Using a tmp file since, verilog can't write binary files except in 4byte chucks or whole files at a time.
	// Hex values (as readible characters) are written to a temp file.
	// Then the temp file is read in and written to the result binary file in 4byte chunks
	parameter		TMP_FILENAME			= "./docs/tmp.txt";
	
	// Bitmap file based parameters
	localparam BMP_HEADER_SIZE_BYTES	= 14;	// The length of the BMP file header field in Bytes
	localparam PIXEL_ARR_PTR_ADDR			= BMP_HEADER_SIZE_BYTES - 4;
	localparam DIB_HEADER_C1_SIZE			= 40; // The length of the expected BITMAPINFOHEADER DIB header
	localparam DIB_HEADER_C2_SIZE			= 12; // The length of the expected BITMAPCOREHEADER DIB header
	localparam NO_COMPRESSION 				= 0;	// The compression mode value should be 0 if no compression is used (normal case)
	
	// Declare connecting wires
	wire tb_r_one_k_samples;
	wire tb_r_modwait;
	wire [15:0] tb_r_avg_out;
	wire tb_r_err;
	wire tb_g_one_k_samples;
	wire tb_g_modwait;
	wire [15:0] tb_g_avg_out;
	wire tb_g_err;
	wire tb_b_one_k_samples;
	wire tb_b_modwait;
	wire [15:0] tb_b_avg_out;
	wire tb_b_err;
	
	// Declare Test Input Variables
	reg tb_clk;
	reg tb_n_reset;
	reg [15:0] tb_r_sample_data;
	reg [15:0] tb_g_sample_data;
	reg [15:0] tb_b_sample_data;
	reg tb_data_ready;
	
	// Declare Test Bench Variables
	integer r;										// Loop variable for working with rows of pixels
	integer p;										// Loop variable for working with pixels in a row
	reg [7:0] tmp_byte;						// temp variable for read/writing bytes from/to files
	integer in_file;							// Input file handle
	integer res_file;							// Result file handle
	integer tmp_file;							// Temp result file handle
	integer num_rows;							// The number of rows of pixels in the image file
	integer num_pixels;						// The number of pixels pwer row in the image file
	integer num_pad_bytes;				// The number of padding bytes at the end of each row
	reg [2:0][7:0] in_pixel_val;	// The raw bytes read from the input file
	reg [2:0][7:0] res_pixel_val;	// The averaged values for the result file
	integer i;										// Loop variable for misc. for loops
	
	// The bitmap file header is 14 Bytes
	reg [(BMP_HEADER_SIZE_BYTES - 1):0][7:0] in_bmp_file_header;
	reg [(BMP_HEADER_SIZE_BYTES - 1):0][7:0] res_bmp_file_header;
	reg [31:0] in_image_data_ptr;		// The starting byte address of the pixel array in the input file
	reg [31:0] res_image_data_ptr;	// The starting byte address of the pixel array in the result file
	// The normal/supported DIB header is 40 Bytes
	reg [(DIB_HEADER_C1_SIZE - 1):0][7:0] dib_header;
	reg [31:0] dib_header_size;	// The dib header size is a 32-bit unsigned integer
	reg [31:0] image_width;			// The image width (pixels) is a 32-bit signed integer
	reg [31:0] image_height;		// The image height (pixels) is a 32-bit signed integer
	reg [15:0] num_pixel_bits;	// The number of pixels per bit (1, 4, 8, 16, 24, 32) is an unsigned integer
	reg [31:0] compression_mode;// The type of compression used (this test bench doesn't support compression)
	// Pixel array stuff
	integer row_size_bytes;	// Used to store the calculated row size for the pixel array
	
	// Red color slice checker variables
	reg [3:0][15:0] tb_r_samples; // Samples array for checkers
	reg [15:0] tb_gold_r_avg_out;	// Gold/expected value for the avg_out port
	reg tb_gold_r_err;						// Gold/expected value for the err port
	reg tb_r_no_match;						// Simple no match signal to help with waveform viewing
	// Green color slice checker variables
	reg [3:0][15:0] tb_g_samples; // Samples array for checkers
	reg [15:0] tb_gold_g_avg_out;	// Gold/expected value for the avg_out port
	reg tb_gold_g_err;						// Gold/expected value for the err port
	reg tb_g_no_match;						// Simple no match signal to help with waveform viewing
	// Blue color slice checker variables
	reg [3:0][15:0] tb_b_samples; // Samples array for checkers
	reg [15:0] tb_gold_b_avg_out;	// Gold/expected value for the avg_out port
	reg tb_gold_b_err;						// Gold/expected value for the err port
	reg tb_b_no_match;						// Simple no match signal to help with waveform viewing
	
	// DUT portmaps
	gold_avg_four R_DUT // Portmap for the Red color slice filter
	(
		.clk(tb_clk),
		.n_reset(tb_n_reset),
		.sample_data(tb_r_sample_data),
		.data_ready(tb_data_ready),
		.one_k_samples(tb_r_one_k_samples),
		.modwait(tb_r_modwait),
		.avg_out(tb_r_avg_out),
		.err(tb_r_err)
	);
	gold_avg_four G_DUT // Portmap for the Green color slice filter
	(
		.clk(tb_clk),
		.n_reset(tb_n_reset),
		.sample_data(tb_g_sample_data),
		.data_ready(tb_data_ready),
		.one_k_samples(tb_g_one_k_samples),
		.modwait(tb_g_modwait),
		.avg_out(tb_g_avg_out),
		.err(tb_g_err)
	);
	gold_avg_four B_DUT // Portmap for the Blue color slice filter
	(
		.clk(tb_clk),
		.n_reset(tb_n_reset),
		.sample_data(tb_b_sample_data),
		.data_ready(tb_data_ready),
		.one_k_samples(tb_b_one_k_samples),
		.modwait(tb_b_modwait),
		.avg_out(tb_b_avg_out),
		.err(tb_b_err)
	);
	
	// Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	// Test bench main process
	initial
	begin
		// Initialize all of the test inputs
		tb_n_reset				= 1'b1;		// Initialize to be active
		tb_r_sample_data	= 16'd0;	// Initialize to a value of 0
		tb_g_sample_data	= 16'd0;	// Initialize to a value of 0
		tb_b_sample_data	= 16'd0;	// Initialize to a value of 0
		tb_data_ready			= 1'b0;		// Initialize to be inactive
		
		// Power-on reset of the DUT
		#(0.1);
		tb_n_reset	= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
		#(CLK_PERIOD * 2.25);	// Release the reset away from a clock edge
		tb_n_reset	= 1'b1; 	// Deactivate the chip reset
		
		// Read in the input image file's header section
		// Open the input file
		in_file = $fopen(INPUT_FILENAME, "rb");
		// Read in the Bitmap file header information (data is stored in little-endian (LSB first) format)
		for(i = 0; i < BMP_HEADER_SIZE_BYTES; i = i + 1) // Read the data in LSB format
		begin
			// Read a byte at a time
			$fscanf(in_file,"%c" , in_bmp_file_header[i]);
		end
		// Extract the pixel array pointer (contains the file byte offset of the first byte of the pixel array)
		in_image_data_ptr[31:0] = in_bmp_file_header[(BMP_HEADER_SIZE_BYTES - 1):PIXEL_ARR_PTR_ADDR]; // The pixel array pointer is a 4 byte unsigned integer at the end of the header
		// Read in the DIB header information (LSB format)
		$fscanf(in_file,"%c" , dib_header[0]);
		$fscanf(in_file,"%c" , dib_header[1]);
		$fscanf(in_file,"%c" , dib_header[2]);
		$fscanf(in_file,"%c" , dib_header[3]);
		dib_header_size = dib_header[3:0];
		if(DIB_HEADER_C1_SIZE == dib_header_size)
		begin
			$display("Input bitmap file uses the BITMAPINFOHEADER type of DIB header");
			for(i = 4; i < dib_header_size; i = i + 1) // Read data in LSB format
			begin
				// Read a byte at a time
				$fscanf(in_file,"%c" , dib_header[i]);
			end
			
			// Exract useful values from the header
			image_width				= dib_header[7:4];		// image width is bytes 4-7
			image_height			= dib_header[11:8];		// image height is bytes 8-11
			num_pixel_bits		= dib_header[15:14];	// number of bits per pixel is bytes 14 & 15
			compression_mode	= dib_header[19:16];	// compression mode is bytes 16-19
			
			if(16'd24 != num_pixel_bits)
				$fatal("This input file is using a pixel size (%0d)that is not supported, only 24bpp is supported", num_pixel_bits);
			
			if(NO_COMPRESSION != compression_mode)
				$fatal("This input file is using compression, this is not supported by this test bench");
			
		end
		else if(DIB_HEADER_C2_SIZE == dib_header_size)
		begin
			$display("Input bitmap file uses the BITMAPCOREHEADER  type of DIB header");
			for(i = 4; i < dib_header_size; i = i + 1) // Read data in LSB format
			begin
				// Read a byte at a time
				$fscanf(in_file,"%c" , dib_header[i]);
			end
			
			// Exract useful values from the header
			image_width			= {16'd0,dib_header[5:4]};	// image width is bytes 4 & 5
			image_height		= {16'd0,dib_header[7:6]};	// image height is bytes 6 & 7
			num_pixel_bits	= dib_header[11:10];				// number of bits per pixel is bytes 10 & 11
			
			if(16'd24 != num_pixel_bits)
				$fatal("This input file is using a pixel size (%0d)that is not supported, only 24bpp is supported", num_pixel_bits);
		end
		else
		begin
			$fatal("Unsupported DIB header size of %0d found in input file", dib_header_size);
		end
		
		// Shouldn't need a color palette -> skip it
		res_image_data_ptr = BMP_HEADER_SIZE_BYTES + dib_header_size;
		
		// Should be at the start of the image data (there shoudln't be a color palette)
		// Skip padding if needed
		if($ftell(in_file) != in_image_data_ptr)
			$fseek(in_file, in_image_data_ptr, `SEEK_START);
		
		// Generate the result image file's header section
		// Open the result file
		res_file = $fopen(RESULT_FILENAME, "wb");
		// Create the bmp file header field (shouldn't change from input file, except for potetinally the image data ptr field)
		res_bmp_file_header = in_bmp_file_header;
		// Correct the image data ptr for discarding the color palette when allowed
		res_bmp_file_header[(BMP_HEADER_SIZE_BYTES - 1):PIXEL_ARR_PTR_ADDR] = res_image_data_ptr;
		// Write the bitmap header field to the result file
		for(i = 0; i < BMP_HEADER_SIZE_BYTES; i = i + 1) // Write data in LSB format
		begin
			// Write a byte at a time
			$fwrite(res_file, "%c", res_bmp_file_header[i]);
		end
		// Create the DIB header for the result file (shouldn't change from input file)
		for(i = 0; i < dib_header_size; i = i + 1) // Write data in LSB format
		begin
			// Write a byte at a time
			$fwrite(res_file, "%c", dib_header[i]);
		end
		
		// Should be at the start of the image data (there shoudln't be a color palette)
		// Skip padding if needed
		if($ftell(res_file) != res_image_data_ptr)
			$fseek(res_file, res_image_data_ptr, `SEEK_START);
		
		// Feed each pixel from the input image file through the DUT and store the result
		// in the result image file
		// Calculate image data row size
		row_size_bytes = (((num_pixel_bits * image_width) + 31) / 32) * 4;
		// Calculate the number of rows in the pixel array
		num_rows = image_height;
		// Calculate the number of pixels per row
		num_pixels = image_width;
		// Calculate the number of padding bytes per row
		num_pad_bytes	= row_size_bytes - (num_pixels * 3);
		for(r = 0; r < num_rows; r = r + 1)
		begin
			for(p = 0; p < num_pixels; p = p + 1)
			begin
				// Get the input pixel value from the file (LSB format)
				$fscanf(in_file, "%c", in_pixel_val[0]);
				$fscanf(in_file, "%c", in_pixel_val[1]);
				$fscanf(in_file, "%c", in_pixel_val[2]);
			
				// Feed color value into corresponding DUT instance (B=LSB,R=MSB as per 24bpp form of 8.8.8.0.0 RGBAX format)
				@(posedge tb_clk);	// Synch up with the rising edge of the clock so it can be avoided
				#0.3; 							// Move safely away from the clock edge to prevent violating hold times
				tb_r_sample_data	= {8'd0,in_pixel_val[2]};
				tb_g_sample_data	= {8'd0,in_pixel_val[1]};
				tb_b_sample_data	= {8'd0,in_pixel_val[0]};
				tb_data_ready			= 1'b1;
				
				// Wait for DUT to start working on it
				fork
				begin : TIMEOUT_1
					#(5 * CLK_PERIOD);
					disable WAIT_MODWAIT_1;
				end
				
				begin : WAIT_MODWAIT_1
					@(posedge tb_r_modwait);
					@(posedge tb_g_modwait);
					@(posedge tb_b_modwait);
					disable TIMEOUT_1;
				end
				join
				
				// Deactivate the data ready after waiting for the load state to finish
				#(2 * CLK_PERIOD);
				tb_data_ready = 1'b0;
				
				// Wait for processing to finish
				fork
				begin : TIMEOUT_2
					#(PROCESSING_PERIOD);
					disable WAIT_MODWAIT_2;
				end
				
				begin : WAIT_MODWAIT_2
					@(negedge tb_r_modwait);
					@(negedge tb_g_modwait);
					@(negedge tb_b_modwait);
					disable TIMEOUT_2;
				end
				join
				
				// Get away from a clock edge
				#(CLK_PERIOD * 0.7);
				
				// Put avg_out values in result file (B=LSB,R=MSB as per 24bpp form of 8.8.8.0.0 RGBAX format)
				res_pixel_val[2] = tb_r_avg_out[7:0];
				res_pixel_val[1] = tb_g_avg_out[7:0];
				res_pixel_val[0] = tb_b_avg_out[7:0];
				
				// Add some spacing between samples
				#(5 * CLK_PERIOD);

				// Done filtering each color portion of the pixel -> store full pixel to the file (LSB Format)
				$fwrite(res_file, "%c", res_pixel_val[0]);
				$fwrite(res_file, "%c", res_pixel_val[1]);
				$fwrite(res_file, "%c", res_pixel_val[2]);
			end
			// Finished a row of pixels
			// Skip past any padding bytes in the input file (get to the next row)
			$fseek(in_file, num_pad_bytes, `SEEK_CUR);
			// Add padding bytes to result file (advance it to the next row)
			$fseek(res_file, num_pad_bytes, `SEEK_CUR);
			// Ready to start working on the next row of pixels
		end
		// Done with pixel array section
		// Done with input file
		$fclose(in_file);
		// Create end of file marker
		$fwrite(res_file, "%c", 8'd0);
		// Done with result file
		$fclose(res_file);
		$display("Done generating filtered file '%s' from input file '%s'", RESULT_FILENAME, INPUT_FILENAME);
	end
	
	// DUT Averaged Result Checker
	always @ (tb_n_reset, tb_r_sample_data, tb_g_sample_data, tb_b_sample_data, tb_data_ready)
	begin
		// Set default value(s)
		tb_r_no_match = 1'b0;
		tb_g_no_match = 1'b0;
		tb_b_no_match = 1'b0;
		
		if(1'b0 == tb_n_reset) // Reset is active
		begin
			tb_r_samples[0]		= 16'd0;
			tb_r_samples[1]		= 16'd0;
			tb_r_samples[2]		= 16'd0;
			tb_r_samples[3]		= 16'd0;
			tb_gold_r_avg_out	= 16'd0;
			tb_gold_r_err			= 1'b0;
			tb_g_samples[0]		= 16'd0;
			tb_g_samples[1]		= 16'd0;
			tb_g_samples[2]		= 16'd0;
			tb_g_samples[3]		= 16'd0;
			tb_gold_g_avg_out	= 16'd0;
			tb_gold_g_err			= 1'b0;
			tb_b_samples[0]		= 16'd0;
			tb_b_samples[1]		= 16'd0;
			tb_b_samples[2]		= 16'd0;
			tb_b_samples[3]		= 16'd0;
			tb_gold_b_avg_out	= 16'd0;
			tb_gold_b_err			= 1'b0;
			
			// Check the results after DUT's should be stable
			#(CLK_PERIOD - 200ps);
			assert(tb_gold_r_avg_out == tb_r_avg_out)
			else
			begin
				tb_r_no_match = 1'b1;
				$error("Red DUT's avg_out port did not match expected value during reset", p);
			end
			assert(tb_gold_r_err == tb_r_err)
			else
			begin
				tb_r_no_match = 1'b1;
				$error("Red DUT's err port did not match expected value during reset", p);
			end
			assert(tb_gold_g_avg_out == tb_g_avg_out)
			else
			begin
				tb_g_no_match = 1'b1;
				$error("Green DUT's avg_out port did not match expected value during reset", p);
			end
			assert(tb_gold_g_err == tb_g_err)
			else
			begin
				tb_g_no_match = 1'b1;
				$error("Green DUT's err port did not match expected value during reset", p);
			end
			assert(tb_gold_b_avg_out == tb_b_avg_out)
			else
			begin
				tb_b_no_match = 1'b1;
				$error("Blue DUT's avg_out port did not match expected value during reset", p);
			end
			assert(tb_gold_b_err == tb_b_err)
			else
			begin
				tb_b_no_match = 1'b1;
				$error("Blue DUT's err port did not match expected value during reset", p);
			end
		end
		else // Reset is not active
		begin
			// Check for data ready and wait for it if it's not ready
			if(1'b0 == tb_data_ready)
				@(posedge tb_data_ready);
			
			// Update the expected value
			// Make sure to be away from the edge since data ready and the data values are set together
			#0.1;
			// Update the red color slice samples
			tb_r_samples[0] = tb_r_samples[1];
			tb_r_samples[1] = tb_r_samples[2];
			tb_r_samples[2] = tb_r_samples[3];
			tb_r_samples[3] = tb_r_sample_data;
			// Update the green color slice samples
			tb_g_samples[0] = tb_g_samples[1];
			tb_g_samples[1] = tb_g_samples[2];
			tb_g_samples[2] = tb_g_samples[3];
			tb_g_samples[3] = tb_g_sample_data;
			// Update the blue color slice samples
			tb_b_samples[0] = tb_b_samples[1];
			tb_b_samples[1] = tb_b_samples[2];
			tb_b_samples[2] = tb_b_samples[3];
			tb_b_samples[3] = tb_b_sample_data;
			
			// Calculate the expected avg_out ports
			tb_gold_r_avg_out = (((tb_r_samples[0] + tb_r_samples[1] + tb_r_samples[2] + tb_r_samples[3]) / 4) % OVERFLOW_VAL);
			tb_gold_g_avg_out = (((tb_g_samples[0] + tb_g_samples[1] + tb_g_samples[2] + tb_g_samples[3]) / 4) % OVERFLOW_VAL);
			tb_gold_b_avg_out = (((tb_b_samples[0] + tb_b_samples[1] + tb_b_samples[2] + tb_b_samples[3]) / 4) % OVERFLOW_VAL);
			
			// Calculate the expected value for the err ports
			if(((tb_r_samples[0] + tb_r_samples[1] + tb_r_samples[2] + tb_r_samples[3]) / OVERFLOW_VAL) >= 1)
				tb_gold_r_err	= 1'b1;
			else
				tb_gold_r_err = 1'b0;
			// Calculate the expected value for the err ports
			if(((tb_g_samples[0] + tb_g_samples[1] + tb_g_samples[2] + tb_g_samples[3]) / OVERFLOW_VAL) >= 1)
				tb_gold_g_err	= 1'b1;
			else
				tb_gold_g_err = 1'b0;
			// Calculate the expected value for the err ports
			if(((tb_b_samples[0] + tb_b_samples[1] + tb_b_samples[2] + tb_b_samples[3]) / OVERFLOW_VAL) >= 1)
				tb_gold_b_err	= 1'b1;
			else
				tb_gold_b_err = 1'b0;
			// Assume only valid data ready pulses
			
			// Wait for DUTs' processing to be finished
			fork
			begin : TIMEOUT_CHK
				#(PROCESSING_PERIOD);
				disable WAIT_MODWAIT_CHK;
			end
			
			begin : WAIT_MODWAIT_CHK
				@(negedge tb_r_modwait);
				if(1'b1 == tb_g_modwait)
					@(negedge tb_g_modwait);
				if(1'b1 == tb_b_modwait)
					@(negedge tb_b_modwait);
				disable TIMEOUT_CHK;
			end
			join
			
			// Get away from the edge
			#(CLK_PERIOD * 0.5);
			
			// DUTs' outputs should be stable now
			assert(tb_gold_r_avg_out == tb_r_avg_out)
			else
			begin
				tb_r_no_match = 1'b1;
				$error("Red DUT's avg_out port did not match expected value for pixel %0d", p);
			end
			assert(tb_gold_r_err == tb_r_err)
			else
			begin
				tb_r_no_match = 1'b1;
				$error("Red DUT's err port did not match expected value for pixel %0d", p);
			end
			assert(tb_gold_g_avg_out == tb_g_avg_out)
			else
			begin
				tb_g_no_match = 1'b1;
				$error("Green DUT's avg_out port did not match expected value for pixel %0d", p);
			end
			assert(tb_gold_g_err == tb_g_err)
			else
			begin
				tb_g_no_match = 1'b1;
				$error("Green DUT's err port did not match expected value for pixel %0d", p);
			end
			assert(tb_gold_b_avg_out == tb_b_avg_out)
			else
			begin
				tb_b_no_match = 1'b1;
				$error("Blue DUT's avg_out port did not match expected value for pixel %0d", p);
			end
			assert(tb_gold_b_err == tb_b_err)
			else
			begin
				tb_b_no_match = 1'b1;
				$error("Blue DUT's err port did not match expected value for pixel %0d", p);
			end
		end
	end

endmodule
