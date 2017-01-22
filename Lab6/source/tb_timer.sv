`timescale 1ns / 10ps

module tb_timer();
  
  // Define parameters
	parameter CLK_PERIOD				= 10;
	parameter SCL_PERIOD    = 300;
	parameter sclwait       = 300;
  
  reg tb_clk;
  reg tb_n_rst;
  reg tb_scl;
  reg tb_sda_in;
	reg tb_stop_found;
	reg tb_start_found;
	reg tb_rising_edge_found;
	reg tb_falling_edge_found;
	
	reg tb_byte_received;
	reg tb_ack_prep;
	reg tb_check_ack;
	reg tb_ack_done;

	timer DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.rising_edge_found(tb_rising_edge_found),
		.falling_edge_found(tb_falling_edge_found),
		.stop_found(tb_stop_found),
		.start_found(tb_start_found),
		.byte_received(tb_byte_received),
		.ack_prep(tb_ack_prep),
		.check_ack(tb_check_ack),
		.ack_done(tb_ack_done)		
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
	  tb_start_found = 0;
    tb_stop_found = 0;    
    tb_rising_edge_found =0;
    tb_falling_edge_found =0;
	  @(posedge tb_clk);
    tb_n_rst = 1'b1;
 
    
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk); 
    
    
    //tb_start_found = 1'b1;
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk); 
    //tb_start_found = 1'b0;
    
    @(posedge tb_scl);
		@(posedge tb_clk);
		tb_rising_edge_found=1;
		tb_falling_edge_found =0;
		@(posedge tb_clk);
		tb_start_found = 1'b1;
			
		@(posedge tb_clk); 
		tb_rising_edge_found=0;
		tb_falling_edge_found =0;
		tb_start_found = 1'b0;
				
		@(negedge tb_scl);
		@(posedge tb_clk);
		tb_rising_edge_found=0;
		tb_falling_edge_found =1;
				
		@(posedge tb_clk); 
		tb_rising_edge_found=0;
		tb_falling_edge_found =0;
    
    
    
    repeat (27) begin 
      @(posedge tb_scl);
      @(posedge tb_clk);
      tb_rising_edge_found=1;
      tb_falling_edge_found =0;
  
      @(posedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    
      @(negedge tb_scl);
      @(posedge tb_clk);
      tb_rising_edge_found=0;
      tb_falling_edge_found =1;
    
      @(posedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    end
    
    @(posedge tb_scl);
    tb_rising_edge_found=1;
    tb_falling_edge_found =0;
    tb_stop_found =1;
    
    @(negedge tb_clk); 
    tb_rising_edge_found=0;
    tb_falling_edge_found =0;
    
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    
    tb_stop_found =0;
    
    @(negedge tb_scl);
    tb_rising_edge_found=0;
    tb_falling_edge_found =1;
    
    @(negedge tb_clk); 
    tb_rising_edge_found=0;
    tb_falling_edge_found =0;
    
    repeat (13) begin 
      @(posedge tb_scl);
      tb_rising_edge_found=1;
      tb_falling_edge_found =0;
    
      @(negedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    
      @(negedge tb_scl);
      tb_rising_edge_found=0;
      tb_falling_edge_found =1;
    
      @(negedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    end
    
    tb_start_found = 1'b1;
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk);
    @(posedge tb_clk); 
    tb_start_found = 1'b0;
     
    repeat (27) begin 
      @(posedge tb_scl);
      tb_rising_edge_found=1;
      tb_falling_edge_found =0;
    
      @(posedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    
      @(negedge tb_scl);
      tb_rising_edge_found=0;
      tb_falling_edge_found =1;
    
      @(posedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    end
    
    tb_start_found = 1'b1;
    @(posedge tb_clk);
    @(posedge tb_clk);
    tb_start_found = 1'b0;
     
    repeat (27) begin 
      @(posedge tb_scl);
      tb_rising_edge_found=1;
      tb_falling_edge_found =0;
    
      @(posedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    
      @(negedge tb_scl);
      tb_rising_edge_found=0;
      tb_falling_edge_found =1;
    
      @(posedge tb_clk); 
      tb_rising_edge_found=0;
      tb_falling_edge_found =0;
    end
    
	end 
endmodule