// Testbench
module test;

  wire [7:0] out;
  reg [7:0] a;
  reg [7:0] b;
  reg  s;

  mux2to1 MUX2to1(.out(out), .d0(a), .d1(b), .sel(s));
  
   initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
     $display("Mux");
    a=8'h01; b=8'h02; s=1'b0;
    display;
     
     $display("Select D1");
     a=8'h01; b=8'h04; s=1'b1;
     display;
     
     $display("Select D0");
     a=8'h71; b=8'h06; s=1'b0;
     display;
 

end


 task display;
   #1 $display("a:%0h, b:%0h, s:%0h, out:%0h",
      a, b, s, out);
  endtask
  


endmodule
