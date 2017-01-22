`timescale 1ns / 100 ps

module tb_flex_counter();

      localparam CLK_PERIOD = 5;
      //400Mhz.................
      wire tb_clk;
      wire tb_rst;
      wire tb_count_enable;
      wire [3:0] tb_count_out;
      wire [3:0] tb_value;    
      wire tb_flag;
      wire tb_clear;

      reg ntb_clk;
      reg ntb_rst;
      reg ntb_count_enable;
      reg [3:0] ntb_count_out;
      reg [3:0] ntb_value;    
      reg ntb_flag;
      reg ntb_clear;
      

flex_counter dut(.clk(tb_clk), .n_rst(tb_rst), .count_enable(tb_count_enable), .clear(tb_clear), .rollover_val(tb_value), .count_out(tb_count_out), .rollover_flag(tb_flag));

      always
      begin : CLK_GEN
        ntb_clk = 1'b0;
        #(CLK_PERIOD/2);
        ntb_clk = 1'b1;
        #(CLK_PERIOD/2);
      end


	assign tb_clk=ntb_clk;
	assign tb_rst=ntb_rst;
	assign tb_count_enable=ntb_count_enable;
	assign tb_count_out=ntb_count_out;
	assign tb_value=ntb_value;
	assign tb_flag=ntb_flag;
	assign tb_clear=ntb_clear;

initial
	begin
	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b0100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0100; ntb_clear=0; #10;

	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b0101; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0101; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0101; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0101; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0101; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0101; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0101; ntb_clear=0; #10;

	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b0111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0111; ntb_clear=0; #10;

	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b1100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1100; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1100; ntb_clear=0; #10;

	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b0110; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0110; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0110; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0110; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0110; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0110; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0110; ntb_clear=0; #10;

	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b1111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1111; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1111; ntb_clear=0; #10;

	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b0000; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0000; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0000; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0000; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0000; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0000; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b0000; ntb_clear=0; #10;

	  ntb_rst = 1'b0; ntb_count_enable =1'b1; ntb_value = 4'b1001; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1001; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1001; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1001; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1001; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1001; ntb_clear=0; #10;
	  ntb_rst = 1'b1; ntb_count_enable =1'b1; ntb_value = 4'b1001; ntb_clear=0; #10;

  end

endmodule