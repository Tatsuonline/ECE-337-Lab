// $Id: $mg68
// File name:   rx_sr.sv
// Created:     10/9/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Serial to Parallel Shift Register

`timescale 1ns / 10ps

module tb_i2c_slave();
  
 	parameter CLK_PERIOD				= 10;
	parameter SCL_PERIOD    = 300;
  
  reg tb_clk;
  reg tb_n_rst;
  
  reg [7:0] tb_write_data;
  reg tb_fifo_empty;
  reg tb_fifo_full;
  reg tb_write_enable;

  reg tb_scl_slave_in;
  reg tb_scl_master_in;
  reg tb_scl_master_out;
  reg tb_sda_slave_out;
  reg tb_sda_master_in;
  reg tb_sda_slave_in;
  reg tb_sda_master_out;


  reg idle;
  
  
  i2c_slave DUT(
  		.clk(tb_clk),
  		.n_rst(tb_n_rst),
  		.scl(tb_scl_slave_in),
  		.sda_in(tb_sda_slave_in),
  		.sda_out(tb_sda_slave_out),
  		.write_enable(tb_write_enable),
  		.write_data(tb_write_data),
  		.fifo_empty(tb_fifo_empty),
  		.fifo_full(tb_fifo_full)
	);
	  
  
  i2c_bus BUS(
  		.scl_read({tb_scl_slave_in, tb_scl_master_in}),
		.scl_write({'z, tb_scl_master_out}),
		.sda_read({tb_sda_slave_in, tb_sda_master_in}),
		.sda_write({tb_sda_slave_out, tb_sda_master_out})
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
	    tb_scl_master_out = (1'b0 | idle);
	    #(SCL_PERIOD / 3);
	    tb_scl_master_out = (1'b1);
	    #(SCL_PERIOD / 3); 
	    tb_scl_master_out = (1'b0 | idle);
	    #(SCL_PERIOD / 3);
	end	
	

	

	
	initial
	begin 
	
		idle = 1'b1;
	  tb_n_rst = 1'b0;
	  @(posedge tb_clk)
    tb_n_rst = 1'b1;

    tb_write_data = 8'b10000011;
    tb_write_enable = 1'b1;
    @(posedge tb_clk);
    tb_write_enable = 1'b0;
    
    @(posedge tb_clk);
    @(posedge tb_clk);
    //generate start conditon
    $display("start condition");
    tb_sda_master_out = 1'b1;
    #50;
    tb_sda_master_out = 1'b0; 
    #5;
    idle = 1'b0;
    $display("start sending address");
    //address and RW mode
    #200;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b0;
    $display("done sending address");
  		#2700;
			
		
		tb_sda_master_out = 1'b0;
		tb_write_data = 8'b10000100;
		#10;
    @(negedge tb_clk);
    tb_write_enable = 1'b1;
    @(posedge tb_clk);
    @(negedge tb_clk);
    tb_write_enable = 1'b0;
 
		
		#2700;
		tb_sda_master_out = 1'b0;
		tb_write_data = 8'b10001000;
		@(negedge tb_clk);
    tb_write_enable = 1'b1;
    @(posedge tb_clk);
    @(negedge tb_clk);
    tb_write_enable = 1'b0;
		
		idle=1;
		#100;
		$display("stop condition");
    tb_sda_master_out = 1'b0;
    #50;
    tb_sda_master_out = 1'b1; 
    
    #500;
    
    
		
    //generate start conditon
    $display("start condition");
    tb_sda_master_out = 1'b1;
    #50;
    tb_sda_master_out = 1'b0; 
    #5;
    idle = 1'b0;
    $display("start sending address");
    //address and RW mode
    #200;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b0;
    $display("done sending address");
  		#2700;
			
		
		tb_sda_master_out = 1'b0;
		tb_write_data = 8'b10000100;
		#10;
    @(negedge tb_clk);
    tb_write_enable = 1'b1;
    @(posedge tb_clk);
    @(negedge tb_clk);
    tb_write_enable = 1'b1;
 		$display("NACK");
		

		idle=1;
		#100;
    //generate start conditon
    $display("start condition");
    tb_sda_master_out = 1'b1;
    #50;
    tb_sda_master_out = 1'b0; 
    #5;
    idle = 1'b0;
    $display("start sending address");
    //address and RW mode
    #100;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b0;
    #300;
    tb_sda_master_out = 1'b1;
    #300;
    tb_sda_master_out = 1'b0;
    $display("done sending address");
  		#2700;
		
		
		
		tb_sda_master_out = 1'b0;
		tb_write_data = 8'b10000100;
		#10;
    @(negedge tb_clk);
    tb_write_enable = 1'b1;
    @(posedge tb_clk);
    @(negedge tb_clk);
    tb_write_enable = 1'b0;
 
		
		#2700;
		tb_sda_master_out = 1'b0;
		tb_write_data = 8'b10001000;
		@(negedge tb_clk);
    tb_write_enable = 1'b1;
    @(posedge tb_clk);
    @(negedge tb_clk);
    tb_write_enable = 1'b0;
   	
   		idle=1;
		#100;
		$display("stop condition");
    tb_sda_master_out = 1'b0;
    #50;
    tb_sda_master_out = 1'b1; 
    
    #500;
   	
  end
  

endmodule
