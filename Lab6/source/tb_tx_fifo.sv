// $Id: $mg68
// File name:   tb_tx_fifo.sv
// Created:     10/5/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for FIFO Module.

`timescale 1ns / 10ps

module tb_tx_fifo();
	

	parameter CLK_PERIOD	= 10;
	
	reg tb_clk;
	reg tb_n_rst;
	reg tb_read_enable;
	reg [7:0] tb_read_data;
	reg tb_fifo_empty;
	reg tb_fifo_full;
	reg tb_write_enable;
	reg [7:0] tb_write_data;
	
	tx_fifo DUT
	(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.read_enable(tb_read_enable),
	.read_data(tb_read_data),
	.fifo_empty(tb_fifo_empty),
	.fifo_full(tb_fifo_full),
	.write_enable(tb_write_enable),
	.write_data(tb_write_data)
	);
	
	always
		begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end
	
	initial
		begin
			tb_n_rst = 1'b0;
			#10
			tb_n_rst = 1'b1;
			tb_write_data = 8'b00000000;
			tb_read_enable = 1'b0;
			tb_write_enable = 1'b0;
			#30;
			
			//load all ones
			//then read all ones
			
			tb_write_data = 8'b00000001;
			tb_write_enable = 1'b1;
			#10;
			tb_write_enable = 1'b0;
			
			// tb_read_enable = 1'b1;
			
			#10;
			
			// tb_read_enable = 1'b0;
			// #10;
			//load all zeros
			//read all zeros
			
			tb_write_data = 8'b00000010;
			tb_write_enable = 1'b1;
			#10
			tb_write_enable = 1'b0;
			
			//tb_read_enable = 1'b1;
			// #10;
			// tb_read_enable = 1'b0;
			
			#10;
			
			//try and read empty buffer
			// tb_read_enable = 1'b1;
			// #10;
			// tb_read_enable = 1'b0;
			// #10;
			//load data twice
			
			tb_write_data = 8'b00000011;
			tb_write_enable = 1'b1;
			#10;
			tb_write_enable = 1'b0;
			#10
			tb_write_data = 8'b00000100;	
			tb_write_enable = 1'b1;
			#10;
			tb_write_enable = 1'b0;
			#10
			tb_read_enable = 1'b1;
			#10;
			tb_read_enable = 1'b0;
			#10;
			tb_read_enable = 1'b1;
			#10;
			tb_read_enable = 1'b0;
			#10;
			tb_read_enable = 1'b1;
			#10;
			tb_read_enable = 1'b0;
			#10;
			tb_n_rst = 1'b0;
			#10;
	end
endmodule
