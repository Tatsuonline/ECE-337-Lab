// $Id: $mg69
// File name:   ptp20_sr
// Created:     someday
// Author:      
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: N-bit
//change to State machine form

module ptp20_sr
(
input wire clk, 
input wire n_rst, 
input wire clear, //clear signal, rollover flag from counter(20)
input wire shift_enable, 
input wire [19:0] serial_in, 
output wire [399:0] parallel_out
);
   reg [19:0] buff1, buff2, buff3, buff4, buff5, buff6;
   reg [19:0] buff7, buff8, buff9, buff10, buff11, buff12;
   reg [19:0] buff13, buff14, buff15, buff16, buff17, buff18;
   reg [19:0] buff19, buff20;            
   
   always@(posedge clk or negedge n_rst) begin
      if (n_rst == 0) begin	 
	 buff1<={'0}; buff2<={'0};
	 buff3<={'0}; buff4<={'0};
	 buff5<={'0}; buff6<={'0};
	 buff7<={'0}; buff8<={'0};
	 buff9<={'0}; buff10<={'0};
	 buff11<={'0}; buff12<={'0};
	 buff13<={'0}; buff14<={'0};
	 buff15<={'0}; buff16<={'0};
	 buff17<={'0}; buff18<={'0};
	 buff19<={'0}; buff20<={'0};
      end
      else if (clear == 1) begin	 
	 buff1<={'0}; buff2<={'0};
	 buff3<={'0}; buff4<={'0};
	 buff5<={'0}; buff6<={'0};
	 buff7<={'0}; buff8<={'0};
	 buff9<={'0}; buff10<={'0};
	 buff11<={'0}; buff12<={'0};
	 buff13<={'0}; buff14<={'0};
	 buff15<={'0}; buff16<={'0};
	 buff17<={'0}; buff18<={'0};
	 buff19<={'0}; buff20<={'0};
	end
      else begin	 
	 if (shift_enable == 1'b1) begin
	   buff20 = buff19;
	   buff19 = buff18;
	   buff18 = buff17;
	   buff17 = buff16;
	   buff16 = buff15;
	   buff15 = buff14;
	   buff14 = buff13;
	   buff13 = buff12;
	   buff12 = buff11;
	   buff11 = buff10;
	   buff10 = buff9;
	   buff9 = buff8;	   
	   buff8 = buff7;
	   buff7 = buff6;
	   buff6 = buff5;
	   buff5 = buff4;
	   buff4 = buff3;
	   buff3 = buff2;
	   buff2 = buff1;	   
	   buff1=serial_in;	 	    
	 end 
	 else begin
	   // buff1 = buff1;
	 end		
     end
   end
           
   assign parallel_out[19:0]=buff1;
   assign parallel_out[39:20]=buff2;
   assign parallel_out[59:40]=buff3;
   assign parallel_out[79:60]=buff4;
   assign parallel_out[99:80]=buff5;
   assign parallel_out[119:100]=buff6;
   assign parallel_out[139:120]=buff7;
   assign parallel_out[159:140]=buff8;
   assign parallel_out[179:160]=buff9;
   assign parallel_out[199:180]=buff10;
   assign parallel_out[219:200]=buff11;
   assign parallel_out[239:220]=buff12;
   assign parallel_out[259:240]=buff13;
   assign parallel_out[279:260]=buff14;
   assign parallel_out[299:280]=buff15;
   assign parallel_out[319:300]=buff16;
   assign parallel_out[339:320]=buff17;
   assign parallel_out[359:340]=buff18;
   assign parallel_out[379:360]=buff19;
   assign parallel_out[399:380]=buff20;
   
       
endmodule
