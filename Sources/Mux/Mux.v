module mux2to1(out,d0, d1, sel);
  parameter WIDTH=8;
  output [WIDTH-1:0] out;
  input [WIDTH-1:0] d0,d1;
  input sel;
  
  assign out=(sel)?d1:d0;
  
endmodule