module concatenator (out,inA,inB,inC,inD,inE);
  parameter WIDTH0=8;
  parameter WIDTH1=4;
 // parameter WIDTH_out=
  output [(3*WIDTH0+2*WIDTH1)-1:0] out;
  input [WIDTH0-1:0] inA, inB,inC;
  input [WIDTH1-1:0] inD, inE;
  
  assign out={inA,inB,inC,inD,inE};
  
endmodule