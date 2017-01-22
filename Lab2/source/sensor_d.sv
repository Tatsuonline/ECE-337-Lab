// $Id: $mg68
// File name:   sensor_d.sv
// Created:     9/2/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Dataflow Style Sensor Error Detector

module sensor_d (input wire [3:0] sensors, output wire error);

   reg aAndC;
   reg bAndC;
   reg acOrbc;

   assign aAndC = sensors[3] & sensors[1];
   assign bAndC = sensors[2] & sensors[1];
   assign acOrbc = bAndC || aAndC;
   assign error = acOrbc || sensors[0];

endmodule // sensor_d
