// $Id: $mg68
// File name:   tb_decode.sv
// Created:     10/5/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Testbench for Decode

`timescale 1ns / 10ps

module tb_decode();

	parameter CLK_PERIOD	= 10;
	parameter SCL_PERIOD = 300;
	parameter sclwait = 300;
	
	reg tb_clk;
	reg tb_n_rst;
	reg tb_scl;
	reg tb_sda_in;
	reg [7:0] tb_starting_byte;
	reg tb_rw_mode;
	reg tb_address_match;
	reg tb_stop_found;
	reg tb_start_found;
	
	decode DUT
	(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.scl(tb_scl),
	.sda_in(tb_sda_in),
	.starting_byte(tb_starting_byte),
	.rw_mode(tb_rw_mode),
	.address_match(tb_address_match),
	.stop_found(tb_stop_found),
	.start_found(tb_start_found)
	);
	
	always
		begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end

	always
		begin : SCL_GEN
		tb_scl = 1'b0;
		#(SCL_PERIOD / 3);
		tb_scl = 1'b1;
		#(SCL_PERIOD / 3);
		tb_scl = 1'b0;
		#(SCL_PERIOD / 3);
	end

	initial
	begin
		tb_n_rst = 1'b0;
		#1
		tb_sda_in = 1'b1;
		tb_n_rst = 1'b1;
		#120;

		//test start found
		tb_sda_in = 1'b0;
		#30
		tb_sda_in = 1'b1;
		#500
		
		//test address
		tb_sda_in = 1'b1;
		tb_starting_byte = 8'b10000000;
		#(sclwait );
		tb_sda_in = 1'b1;
		tb_starting_byte = 8'b11000000;
		#(sclwait );
		tb_sda_in = 1'b1;
		tb_starting_byte = 8'b11100000;
		#(sclwait );
		tb_sda_in = 1'b1;
		tb_starting_byte = 8'b11110000;
		#(sclwait );
		tb_sda_in = 1'b0;
		tb_starting_byte = 8'b11110000;
		#(sclwait );
		tb_sda_in = 1'b0;
		tb_starting_byte = 8'b11110000;
		#(sclwait );
		tb_sda_in = 1'b0;
		tb_starting_byte = 8'b11110000;
		#(sclwait );
		tb_sda_in = 1'b1;
		tb_starting_byte = 8'b11110001;
		#(sclwait );
		tb_sda_in = 1'b0;
		tb_n_rst = 1'b0;
		#1
		tb_sda_in = 1'b1;
		tb_n_rst = 1'b1;
		tb_starting_byte = 8'b00000000;
	end
endmodule
