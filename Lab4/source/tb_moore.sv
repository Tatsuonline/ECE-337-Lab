`timescale 1ns / 100ps
module tb_moore(
//#####################WHEN SUBMIT, GET RID OF NEXT_S AND CUR_S FROM DUT #################
input wire clk,
input wire n_rst,
input wire i,
output reg o
);
   reg tb_clk;
   reg tb_rst;
   reg tb_i;
   reg tb_o;
//   reg ns;
//   reg [2:0] cs;
   
   
   moore DUT(.clk(tb_clk), .n_rst(tb_rst), .i(tb_i), .o(tb_o));
//, .next_s(ns), .cur_s(cs));
   
    always
      begin
        tb_clk = 1'b0;
        #(1);
        tb_clk = 1'b1;
        #(1);
      end

   
   assign clk = tb_clk;
   assign n_rst = tb_rst;
   assign i=tb_i;
   assign o=tb_o;
      
   initial
     begin
	tb_rst=0; //reset
    tb_i = 0;   
	
	#(2);
	/////////////////////////////////////
tb_rst=1; tb_i=0;
	#(2);
tb_rst=1;	tb_i=0;
	#(2);
tb_rst=1;	tb_i=0;
	#(2);	
tb_rst=1;	tb_i=0;
	#(2);
	//////////////////////0001//////////////////////
	tb_rst=1; tb_i=0;	#(2);tb_rst=1;tb_i=0;#(2);tb_rst=1;tb_i=0;#(2); tb_rst=1;tb_i=1;#(2);
	//////////////////////0010//////////////////////
tb_rst=1;	tb_i=0;	#(2);tb_rst=1;tb_i=0;#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1; tb_i=0;#(2);
	//////////////////////0011//////////////////////
	tb_rst=1;tb_i=0;	#(2);tb_rst=1;tb_i=0;#(2);tb_rst=1;tb_i=1;#(2); tb_rst=1;tb_i=1;#(2);
	//////////////////////0100//////////////////////
	tb_rst=1;tb_i=0;	#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1;tb_i=0;#(2); tb_rst=1;tb_i=0;#(2);
	//////////////////////0101//////////////////////
tb_rst=1;	tb_i=0;	#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1;tb_i=0;#(2);tb_rst=1; tb_i=1;#(2);
	//////////////////////0110//////////////////////
tb_rst=1;	tb_i=0;	#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1; tb_i=0;#(2);
	//////////////////////0111//////////////////////
tb_rst=1;	tb_i=0;	#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1; tb_i=1;#(2); tb_rst=1;tb_i=1;#(2);
	//////////////////////1111//////////////////////
tb_rst=1;	tb_i=1;	#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1;tb_i=1;#(2);tb_rst=1; tb_i=1;#(2);	
	////////////////// 1101  works//////////////////
	tb_rst=1;
	tb_i=1;
	#(2);
	tb_rst=1;
	tb_i=1;
	#(2);
	tb_rst=1;
	tb_i=0;
	#(2);	
	tb_rst=1;
	tb_i=1;
	#(2);
	//////////////////////101 after above works/////////////
	tb_rst=1;
	tb_i=1;
	#(2);
	tb_rst=1;
	tb_i=0;
	#(2);	
	tb_rst=1;
	tb_i=1;
	#(2);
	/* 10 */
	tb_rst=1;
	tb_i=1;
	#(2);
	tb_rst=0;
	tb_i=0;
	#(2);
	
	tb_rst=1;
	#(2);
	


	///////////////////////////////////////////
     end // initial begin
   endmodule
