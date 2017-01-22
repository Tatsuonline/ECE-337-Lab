module timer
(
	input reg clk,
	input reg n_rst,
	input reg rising_edge_found,
	input reg falling_edge_found,
	input reg stop_found,
	input reg start_found,

	output wire byte_received,
	output wire ack_prep,
	output wire check_ack,
	output wire ack_done
);

typedef enum bit [2:0] {RisingCnt, ByteReceived, Falling1, Rising, Falling2, Idle} state;
state cur;
state next;

reg tbyte_received, tack_prep, tcheck_ack, tack_done;
   
reg [2:0] value = 7;
reg enable;
reg reset;
reg full_byte;
reg [2:0] cout;

flex_counter #(3) DUT (.clk(clk), .n_rst(n_rst), .clear(reset), .count_enable(rising_edge_found&&enable), .rollover_val(value), .rollover_flag(full_byte), .count_out(cout));
  
always @ (posedge clk, negedge n_rst) begin
	
	if (n_rst == 1'b0) begin
		cur = Idle;
	       
	end else begin
	   cur = next;
	   value=7;	   	   
	end

end

always_comb
begin
	next = cur;
   
	case (cur)
	Idle : 
	  begin
		if (start_found == 1) begin
			next = RisingCnt;
		end 
		else begin
			next = Idle;
		end
		if (stop_found == 1) begin
			next = Idle;
		end
	end

	RisingCnt : begin
		if (full_byte == 1) begin
			next = ByteReceived;
		end else begin
			next = RisingCnt;
		end

		if (stop_found == 1'b1) begin
			next = Idle;
		end
	end

	ByteReceived : begin
		if (falling_edge_found == 1'b1) begin
			next = Falling1;
		end else begin
			next = ByteReceived;
		end

		if (stop_found == 1'b1) begin
			next = Idle;
		end
	end

	Falling1 : begin
		if (rising_edge_found == 1'b1) begin
			next = Rising;
		end else begin
			next = Falling1;
		end

		if (stop_found == 1'b1) begin
			next = Idle;
		end
	end

	Rising : begin
		if (falling_edge_found == 1'b1) begin
			next = Falling2;
		end else begin
			next = Rising;
		end

		if (stop_found == 1'b1) begin
			next = Idle;
		end
	end

	Falling2 : begin
		next = Idle;
	end

	endcase
end

always @ (cur) 
begin
	case (cur)

	Idle : begin
		tbyte_received = 1'b0; tack_prep = 1'b0; 
		tcheck_ack = 1'b0; tack_done = 1'b0;reset=0;
	end

	RisingCnt : begin
		tbyte_received = 1'b0; tack_prep = 1'b0; 
	   tcheck_ack = 1'b0; tack_done = 1'b0; enable=1;reset=0;	   
	end

	ByteReceived : begin
		tbyte_received = 1'b1; tack_prep = 1'b0; 
	   tcheck_ack = 1'b0; tack_done = 1'b0; enable=0; reset=1;	   
	end

	Falling1 : begin
		tbyte_received = 1'b0; tack_prep = 1'b1; 
		tcheck_ack = 1'b0; tack_done = 1'b0;reset=0;
	end

	Rising : begin
		tbyte_received = 1'b0; tack_prep = 1'b0; 
		tcheck_ack = 1'b1; tack_done = 1'b0;reset=0;
	end

	Falling2 : begin
		tbyte_received = 1'b0; tack_prep = 1'b0; 
		tcheck_ack = 1'b0; tack_done = 1'b1;reset=0;
	end

	endcase
end // always @ (cur)
   
  assign byte_received = tbyte_received;   
  assign ack_prep = tack_prep;   
  assign check_ack = tcheck_ack;   
  assign ack_done = tack_done;
   

   
endmodule