// $Id: $ mg87
// File name:   avg_four.sv
// Created:     2/18/2014
// Author:      Tatsu
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Outputs Average of Last Four Samples

module avg_four(input wire clk, input wire n_reset, input wire [15:0] sample_data, input wire data_ready, output wire one_k_samples, output wire modwait, output wire [15:0] avg_out, output wire err);

	reg dr;
  	reg cnt_up;
  	reg [1:0] op;
  	reg [3:0] src1;
  	reg [3:0] src2;
  	reg [3:0] dest;
  	reg overflow;
  	reg [15:0] aTemporaryOutput;
  
  
  sync SYNC(.clk(clk), .n_rst(n_reset), .async_in(data_ready), .sync_out(dr));
  
  controller CNTRL(.clk(clk), .n_reset(n_reset), .dr(dr), .overflow(overflow), .cnt_up(cnt_up), .modwait(modwait), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err));
    
  counter CNT(.clk(clk), .n_reset(n_reset), .cnt_up(cnt_up), .one_k_samples(one_k_samples));
  
  datapath DPATH(.clk(clk), .n_reset(n_reset), .ext_data(sample_data), .op(op), .src1(src1), .src2(src2), .dest(dest), .overflow(overflow), .outreg_data(aTemporaryOutput));


  assign avg_out = aTemporaryOutput >> 2;
  //assign avg_out = {2'b00,aTemporaryOutput[13:0]};
 
endmodule
