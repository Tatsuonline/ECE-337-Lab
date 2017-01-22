// $Id: $mg68
// File name:   controller.sv
// Created:     9/30/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Controls stuff. Obviously.

module controller
(
	input reg clk,
	input reg n_rst,
	input reg stop_found,
	input reg start_found,
	input reg byte_received,
	input reg ack_prep,
	input reg check_ack,
	input reg ack_done,
	input reg rw_mode,
	input reg address_match,
	input reg sda_in,

	output wire rx_enable,
	output wire tx_enable,
	output wire read_enable,
	output wire [1:0] sda_mode,
	output wire load_data
);

typedef enum bit [5:0] {check_address_state, rx_enable_state, /*wait_address_state, */ack, nack, load_data_state, send_data, stop, check_ack_1, check_ack_2, /*ack_again_1, ack_again_2, */idle} state_type;
state_type state;
state_type nextstate;
  
reg rx_enable_reg;
reg tx_enable_reg;
reg read_enable_reg;
reg [1:0] sda_mode_reg;
reg load_data_reg;
   
always_ff @ (posedge clk, negedge n_rst) begin
      
	if(n_rst == 1'b0) begin
		state <= idle;     	 
    end	else begin
		state <= nextstate;
    end      

end
 
always_comb begin : State_Logic
	
	nextstate = state; // Default.

	case (state)

	idle : begin
		if(start_found == 1'b1) begin
	    	//nextstate = check_address_state;
	    	nextstate = rx_enable_state;
	    end else begin
	        nextstate = idle;
	    end
	end
	
	rx_enable_state : begin // new
		if (byte_received == 1'b1) begin
			nextstate = check_address_state;
		end else begin
			nextstate = rx_enable_state;
		end
	end

	check_address_state : begin
	    //if(ack_prep == 1'b1) begin
	    if (address_match == 1'b1) begin
	        //nextstate = wait_address_state;
	        nextstate = ack;
	    end else begin
	        //nextstate = check_address_state;
	        nextstate = nack;
	    end
	end
	
	/*wait_address_state : begin
	    if((address_match == 1) && (rw_mode == 1)) begin
	        nextstate = ack;
	    end else begin
	        nextstate = nack;
	    end
	end */
	
	ack : begin
	    if(ack_done == 1'b1) begin
	        nextstate = load_data_state;
	    end else begin
	        nextstate = ack;
	    end
	end

	nack : begin
		if(ack_done == 1'b1) begin
	    	nextstate = idle;
    	end else begin
  	    	nextstate = nack;
	    end
	end	     	   
	
	load_data_state : begin
	    nextstate = send_data;	      
	end
	
	send_data : begin
	    //if(byte_received == 1'b1) begin
	        //nextstate = stop;
	    if (ack_prep == 1'b1) begin
	      	nextstate = stop;
	    end else begin
	        nextstate = send_data;
	    end
	end
	
	stop : begin
	    //if(ack_prep == 1'b1) begin
	        //nextstate = check_ack_1;
	    if (check_ack == 1'b1) begin
	    	if (check_ack == 1'b1 && sda_in == 1'b1) begin
	    		nextstate = idle;
	    	end else if (check_ack == 1'b1 && sda_in == 1'b0) begin
	        	nextstate = check_ack_1;
	    	end else begin
	    	nextstate = stop;
	    	end
	    end
	end
	
	check_ack_1 : begin
	    //if((check_ack == 1'b1) && (sda_in == 1'b1)) begin 
	        //nextstate = check_ack_2;
	    if (ack_done == 1'b1) begin
	    	nextstate = check_ack_2;
	    //end else if ((check_ack == 1'b1) && (sda_in == 1'b0)) begin
	        //nextstate = ack_again_1;
	    end else begin
			//nextstate = check_ack_1;
			nextstate = check_ack_1;
	    end	      
	end

	check_ack_2 : begin
	    /*if(stop_found == 1'b1) begin
			nextstate = check_address_state;
	    end else begin
	        nextstate = idle;		 
	    end */
	    nextstate = load_data_state;
	end
	   
	/*ack_again_1 : begin
	    nextstate = ack_again_2;
	end
	
	ack_again_2 : begin
	    if (ack_done == 1) begin
	    	nextstate = load_data_state;
	    end else begin
	    	nextstate = ack_again_2;
	    end
	end	*/   
	 
	

	endcase 
end
      
always @ (state) begin : Register_Logic

	case (state)

	idle : begin	 
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;  
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end

	rx_enable_state : begin // new
		rx_enable_reg = 1'b1; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;  
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end
	
	check_address_state : begin
		//rx_enable_reg = 1'b1; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end	
	
/*	wait_address_state : begin
	 	rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
	 	sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end */
	
    ack : begin	
  		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
  		sda_mode_reg = 2'b01; load_data_reg = 1'b0;
	end

	nack : begin
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b10; load_data_reg = 1'b0;
		end
	
	load_data_state : begin
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b00; load_data_reg = 1'b1;
	end
	
	send_data : begin
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b1; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b11; load_data_reg = 1'b0; 
	end
	
	stop : begin
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end
	
	check_ack_1 : begin
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b00; load_data_reg = 1'b0; 
	end
	
	check_ack_2 : begin
		//rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b1;
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end
	
/*	ack_again_1 : begin
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b1;
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end
	
	ack_again_2 : begin
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end */
	
	

	
	default : begin // Default values
		rx_enable_reg = 1'b0; tx_enable_reg = 1'b0; read_enable_reg = 1'b0;
		sda_mode_reg = 2'b00; load_data_reg = 1'b0;
	end
	  
    endcase
end

assign rx_enable = rx_enable_reg;
assign tx_enable = tx_enable_reg;
assign read_enable = read_enable_reg;
assign sda_mode = sda_mode_reg;
assign load_data = load_data_reg;

endmodule
