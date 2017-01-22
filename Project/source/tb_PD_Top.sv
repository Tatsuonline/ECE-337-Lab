// $Id: $mg68, $mg69
// File name:   tb_PD_Top.sv
// Created:     Unknown
// Author:      Tatsu, CrocKim
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: This is the top level file.

`timescale 1 ns / 10 ps
module tb_PD_Top (); 

reg tb_clk, n_rst, tbclear;
reg [19:0] baseline_oT, data_inT;
reg baseline_doneT, roll20fT;
reg shift_enT, baseline_enT, C_enT, cnt20_enT;
reg [4:0] roll20valT=20;
reg [4:0] tcoutT=0;  

PD_Top PDTOP(.clk(tb_clk), .n_rst(n_rst), .clear(tbclear), .baseline_o(baseline_oT), .data_in(data_inT), .shift_en(shift_enT), .baseline_en(baseline_enT), .C_en(C_enT), .roll20val(roll20valT));



always begin
tb_clk=0;
#(1.25);
tb_clk=1;
#(1.25);
end

initial begin

n_rst=0;
tbclear=0;
shift_enT=0;
baseline_doneT=0;
roll20fT=0;
baseline_enT=0;

#(2.5);//start
n_rst=1; tbclear=0; data_inT=0;
C_enT=0; //baseline_enT=0; shift_enT=0; cnt20_enT=0;
#(2.5);
n_rst=0; tbclear=0;  data_inT=0;
C_enT=0; //baseline_enT=0; shift_enT=0; cnt20_enT=0;
#(2.5);
n_rst=1; tbclear=0;  data_inT=0;
C_enT=0; //baseline_enT=0; shift_enT=0; cnt20_enT=0;
#(2.5);

n_rst=1; tbclear=0;  data_inT=20'b00000000000000000001;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b0000000000000000010;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000000000000100;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000000000001000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000000000010000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000000000100000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000000001000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000000010000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000000100000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000001000000000;//////10/////
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000010000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000000100000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000001000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000010000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00000100000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00001000000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00010000000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b00100000000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b01000000000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b10000000000000000000;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b10101010101010101010;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);
n_rst=1; tbclear=0;  data_inT=20'b10101010101010101010;
C_enT=1; //baseline_enT=0; shift_enT=0; cnt20_enT=1;
#(2.5);



end

endmodule
