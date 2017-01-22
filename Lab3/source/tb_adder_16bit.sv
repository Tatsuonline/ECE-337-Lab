`timescale 1ns / 1ns

module tb_adder_16bit();

       wire [15:0] tb_a;
       wire [15:0] tb_b;
       wire tb_carry_in;
       wire [15:0] tb_sum;
       wire tb_overflow;	
       wire no_match;

		reg [15:0] new_a;
		reg [15:0] new_b;
		reg new_carry_in;
		reg [15:0] new_sum;
		reg new_overflow;
		reg new_no_match;

	   adder_16bit DUT(.a(tb_a), .b(tb_b), .carry_in(tb_carry_in), .sum(tb_sum), .overflow(tb_overflow));

		assign tb_a = new_a;
		assign tb_b = new_b;
		assign tb_carry_in = new_carry_in;
		assign no_match = new_no_match;

initial
	begin
		new_a = 16'h0000;
		new_b = 16'h0000;
		new_carry_in = 1'b0;
		#50;
		new_sum = 16'h00;
		new_overflow = 1'b0;
		assert(tb_sum == new_sum && tb_overflow == new_overflow) begin
		  $display("test case 1 passed!");
		  new_no_match = 0;
    end else begin
      $error("test case 1 failed");
      new_no_match = 1;
    end		  
   
    new_a = 16'hFFFD; // Large number
		new_b = 16'h0001; // Small number
		new_carry_in = 1'b0;
		#50;
		new_sum = 16'hfffe;
		new_overflow = 1'b0;
		assert(tb_sum == new_sum && tb_overflow == new_overflow) begin
		  $display("test case 2 passed!");
		  new_no_match = 0;
    end else begin
      $error("test case 2 failed");
      new_no_match = 1;
    end	
    
    new_a = 16'h0002; // Small number
		new_b = 16'hFFFa; // Large number
		new_carry_in = 1'b0;
		#50;
		new_sum = 16'hfffc;
		new_overflow = 1'b0;
		assert(tb_sum == new_sum && tb_overflow == new_overflow) begin
		  $display("test case 3 passed!");
		  new_no_match = 0;
    end else begin
      $error("test case 3 failed");
      new_no_match = 1;
    end

	    new_a = 16'hFFFF; // Large number
		new_b = 16'hFFFF; // Large number
		new_carry_in = 1'b0;
		#50;
		new_sum = 16'h1fffe;
		new_overflow = 1'b1;
		assert(tb_sum == new_sum && tb_overflow == new_overflow) begin
		  $display("test case 4 passed!");
		  new_no_match = 0;
    end else begin
      $error("test case 4 failed");
      new_no_match = 1;
    end

	    new_a = 16'h0002; // Small number
		new_b = 16'h0002; // Small number
		new_carry_in = 1'b0;
		#50;
		new_sum = 16'h0004;
		new_overflow = 1'b0;
		assert(tb_sum == new_sum && tb_overflow == new_overflow) begin
		  $display("test case 5 passed!");
		  new_no_match = 0;
    end else begin
      $error("test case 5 failed");
      new_no_match = 1;
    end	
    
 end  
 endmodule
