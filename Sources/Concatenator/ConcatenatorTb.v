// Testbench
module test;

  wire [31:0] out;
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;
  reg [3:0] d;
  reg [3:0] e;

  concatenator concat(.out(out), .inA(a), .inB(b), .inC(c), .inD(d), .inE(e));
  
   initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
     $display("Concatenator");
    a=8'h01; b=8'h02; c=8'h03; d=4'h4;
    e=4'h5;
    display;
 

end


 task display;
   #1 $display("a:%0h, b:%0h, c:%0h, d:%0h, e:%0h, out:%0h",
      a, b, c, d, e , out);
  endtask
  


endmodule
