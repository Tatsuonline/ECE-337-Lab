// $Id: $mg68
// File name:   sensor_s.sv
// Created:     9/2/2014
// Author:      Tatsu
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: Structural Style Sensor Error Detector Design

module sensor_s (input [3:0] sensors, output error); // A*C + B*C + D

   reg aAndC;
   reg bAndC;
   reg acOrbc;
   
   and andOfAandC (aAndC, sensors[3], sensors[1]);
   and andOfBandC (bAndC, sensors[2], sensors[1]);
   or orOfACandBC (acOrbc, bAndC, aAndC);
   or errorEquation (error, acOrbc, sensors[0]);

endmodule // sensor_s

