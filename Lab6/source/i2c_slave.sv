// $Id: $mg68
// File name:   i2c_slave.sv
// Created:     10/9/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: The top-level design file where I have connected up all of the other functional unit designs.
// 

module i2c_slave
(
  // Inputs and outputs for the sda and scl.
  input clk,
  input n_rst,
  input scl,
  input sda_in,
  output sda_out,
  
  // Inputs and outputs for the FIFO.
  input write_enable,
  input [7:0] write_data,
  output fifo_empty,
  output fifo_full
);
  
reg sda_syncd;
reg scl_syncd;
reg rising_edge_found;
reg falling_edge_found;
reg tx_out;
reg [1:0] sda_mode;
reg rw_mode;
reg address_match;
reg stop_found;
reg start_found;
reg rx_enable;
reg [7:0] rx_data;
reg tx_enable;
reg load_data;
reg [7:0] read_data;
reg read_enable;
reg byte_received;
reg ack_prep;
reg check_ack;
reg ack_done;


sync SDA_SYNC
(
.clk(clk),
.n_rst(n_rst),
.async_in(sda_in),
.sync_out(sda_syncd)
);

sync SCL_SYNC
(
.clk(clk),
.n_rst(n_rst),
.async_in(scl),
.sync_out(scl_syncd)
);

scl_edge EDGE_DETECTOR
(
.clk(clk),
.n_rst(n_rst),
.scl(scl_syncd),
.rising_edge_found(rising_edge_found),
.falling_edge_found(falling_edge_found)
);

sda_sel SDA_SELECTOR
(
.tx_out(tx_out),
.sda_mode(sda_mode),
.sda_out(sda_out)
);

decode DECODER
(
.clk(clk),
.n_rst(n_rst),
.scl(scl_syncd),
.sda_in(sda_syncd),
.starting_byte(rx_data),
.rw_mode(rw_mode),
.address_match(address_match),
.stop_found(stop_found),
.start_found(start_found)
);

rx_sr RECEIVING_SR
(
.clk(clk),
.n_rst(n_rst),
.sda_in(sda_syncd),
.rising_edge_found(rising_edge_found),
.rx_enable(rx_enable),
.rx_data(rx_data)
);

tx_sr TRANSMITTING_SR
(
.clk(clk),
.n_rst(n_rst),
.tx_out(tx_out),
.falling_edge_found(falling_edge_found),
.tx_enable(tx_enable),
.tx_data(read_data),
.load_data(load_data)
);

tx_fifo FIFO
(
.clk(clk),
.n_rst(n_rst),
.read_enable(read_enable),
.read_data(read_data),
.fifo_empty(fifo_empty),
.fifo_full(fifo_full),
.write_enable(write_enable),
.write_data(write_data)
);

timer TIMER
(
.clk(clk),
.n_rst(n_rst),
.rising_edge_found(rising_edge_found),
.falling_edge_found(falling_edge_found),
.stop_found(stop_found),
.start_found(start_found),
.byte_received(byte_received),
.ack_prep(ack_prep),
.check_ack(check_ack),
.ack_done(ack_done)
);

controller KINGPIN_OF_CRIME
(
.clk(clk),
.n_rst(n_rst),
.start_found(start_found),
.stop_found(stop_found),
.byte_received(byte_received),
.ack_prep(ack_prep),
.check_ack(check_ack),
.ack_done(ack_done),
.rw_mode(rw_mode),
.address_match(address_match),
.sda_in(sda_syncd),
.rx_enable(rx_enable),
.tx_enable(tx_enable),
.read_enable(read_enable),
.sda_mode(sda_mode),
.load_data(load_data)
);

endmodule
