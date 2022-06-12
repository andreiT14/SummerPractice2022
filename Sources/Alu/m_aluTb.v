// Testbench
module test;

  wire [7:0] out;
  wire [3:0] f;
  reg [7:0] a;
  reg [7:0] b;
  reg [3:0] s;

  m_alu m_alu_inst(.A(a), .B(b), .ALU_Sel(s), .ALU_Out(out), .Flag(f));
  
   initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
     $display("Mux alu");
    a=8'h01; b=8'h02; s=4'hf; 
    display;
 
     $display("Add");
    a=8'h01; b=8'h02; s=4'h0;
    display;
     
     $display("Xor");
     a=8'h01; b=8'h04; s=4'h1;
     display;
     
     $display("Sub");
     a=8'h71; b=8'h06; s=4'h1;
     display;
     $display("Mul");
    a=8'h01; b=8'h02; s=4'h2;
    display;
     
     $display("Div");
     a=8'h01; b=8'h04; s=4'h3;
     display;
     
     $display("Shift left");
     a=8'h71; b=8'h06; s=4'h4;
     display;
     $display("Shift right");
    a=8'h01; b=8'h02; s=4'h5;
    display;
     
     $display("And");
     a=8'h01; b=8'h04; s=4'h6;
     display;
     
     $display("Or");
     a=8'h71; b=8'h06; s=4'h7;
     display;
     
      $display("Xor");
     a=8'h01; b=8'h04; s=4'h8;
     display;
     
     $display("Nxor");
     a=8'h71; b=8'h06; s=4'h9;
     display;
     $display("Nand");
     a=8'h01; b=8'h04; s=4'ha;
     display;
     
     $display("Nor");
     a=8'h71; b=8'h06; s=4'hb;
     display;
       
   
end


 task display;
   #1 $display("a:%0h, b:%0h, s:%0h, f:%0h, out:%0h",
      a, b, s, f, out);
  endtask
  


endmodule
