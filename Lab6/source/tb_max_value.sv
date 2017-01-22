`timescale 1 ns / 10 ps
module tb_max_value (); 

   reg   tb_clk, n_rst, tbclear, tb_max_en;
   reg [19:0] tb_basev, tb_cout, tb_datain;
   reg [19:0] tb_out1, tb_out2, tb_maxout; 

max_value Max(.clk(tb_clk), .n_rst(n_rst), .clear(tbclear), .maximum_value_enable(tb_max_en), .baseline_value(tb_basev), .data_input(tb_datain), .output1(tb_out1), .output2(tb_out2), .max_out(tb_maxout));



always begin
tb_clk=0;
#(1.25);
tb_clk=1;
#(1.25);
end

initial begin

n_rst=1;
tbclear=0;
tb_max_en=0;

tb_basev=5;
//-----------------------case 1----------------------------
#(2.5);//start
n_rst=0; tbclear=0; tb_max_en=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=0; tb_datain=0;
#(2.5);//shifting start  1
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=10;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=10;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=15;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=15;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=20;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=25;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=30;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=35;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=20;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=15; //10
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=8;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=7;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=6;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=5;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=4;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=3;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=1;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=0;
#(2.5);
n_rst=1; tbclear=1; tb_max_en=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=0; tb_basev=175;
#(2.5);
//------------case 2 grabbing 24th value------
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=19876;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=8123;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=7123;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=6841;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=6231;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=5752;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=5512;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=5123;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=4763;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=4455;//10
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=4000;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=3500;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=3000;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2500;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2000;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=1700;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=1000;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=500;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=250;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2020; //20
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=1551;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=865;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=501;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2323;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2424;//25
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2525;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2727;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2828; //28
#(2.5);
n_rst=1; tbclear=1; tb_max_en=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=0;
#(2.5);
//-------- case 3 small numbers  -------------
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=1;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=2;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;  tb_datain=3;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=4;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=0;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=5;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=0;//10
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=6;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=1;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=7;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=2;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=8;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=3;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=9;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=4;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=10;
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1; tb_datain=5; //20
#(2.5);
n_rst=1; tbclear=0; tb_max_en=1;
#(2.5);
end

endmodule
