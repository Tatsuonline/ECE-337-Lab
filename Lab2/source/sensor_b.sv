// $Id: $mg68
// File name:   sensor_b.sv
// Created:     9/2/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Behavioral Style Sensor Error Detection

module sensor_b (input wire [3:0] sensors, output reg error);

   reg aAndC;
   reg bAndC;
   reg acOrbc;

   always @ (sensors)
     begin

	aAndC = sensors[3] & sensors[1];
	bAndC = sensors[2] & sensors[1];
        acOrbc = bAndC || aAndC;
	error = acOrbc || sensors[0];

     end

endmodule // sensor_b

