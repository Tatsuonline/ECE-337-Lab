// $Id: $mg68, $mg69
// File name:   PD_Top.sv
// Created:     Unknown
// Author:      Tatsu, CrocKim
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: This is the top level file.

module PD_Top
(
input wire clk, n_rst, clear, shift_en, baseline_en,
C_en,
input wire [19:0] data_in,
input wire [4:0] roll20val,
output wire [19:0] baseline_o
);

reg cnt20_en;
reg [399:0] ptp20_o;
reg baseline_done, roll20f;



flex_counter #(5) CNT20(.clk(clk), .n_rst(n_rst), .clear(clear), .count_enable(cnt20_en), .rollover_val(roll20val), .rollover_flag(roll20f));

controller MASTER(.clk(clk), .n_rst(n_rst), .clear(clear), .baseline_done(baseline_done), .controller_enable(C_en), .roll20f(roll20f), .baseline_enable(baseline_en), .shift_enable(shift_en), .cnt20_en(cnt20_en));

ptp20_sr Shift(.clk(clk),.n_rst(n_rst), .clear(clear), .shift_enable(shift_en), .serial_in(data_in), .parallel_out(ptp20_o));

baseline_creator BC(.clk(clk),.nrst(n_rst),.clear(clear), .baseline_enable(baseline_en), .baseline_done(baseline_done), .data_in(ptp20_o), .baseline_value(baseline_o));


endmodule
