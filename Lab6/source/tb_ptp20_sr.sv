`timescale 1 ns / 10 ps
module tb_ptp20_sr (); 

   reg   tb_clk, n_rst, tbclear, tb_sh_en;
   reg [19:0] tb_serial_in;
   reg [399:0] tbo_pout;      

ptp20_sr DUT(.clk(tb_clk), .n_rst(n_rst), .clear(tbclear), .shift_enable(tb_sh_en), .serial_in(tb_serial_in), .parallel_out(tbo_pout));



always begin
tb_clk=0;
#(1.25);
tb_clk=1;
#(1.25);
end

initial begin

n_rst=1;
tbclear=0;
tb_sh_en=0;

#(2.5);//start
n_rst=0; tbclear=0; tb_sh_en=0; tb_serial_in=0;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=0; tb_serial_in=0;
#(2.5);//shifting start  1
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111111111110;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111111111101;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111111111011;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111111110111;
#(2.5); // 5
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111111101111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111111011111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111110111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111101111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111111011111111;
#(2.5); //10
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111110111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111101111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111111011111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111110111111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111101111111111111;
#(2.5); //15
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11111011111111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11110111111111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11101111111111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b11011111111111111111;
#(2.5);
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b10111111111111111111;
#(2.5); //20
n_rst=1; tbclear=0; tb_sh_en=1; tb_serial_in=20'b01111111111111111111;
#(2.5); //clearling
n_rst=1; tbclear=1; tb_sh_en=0; tb_serial_in=10'b00000000000000000000;

end

endmodule
