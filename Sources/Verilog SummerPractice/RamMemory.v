module ram(data,clk,reset,cs,we,addr,out);
    input [3:0] data,addr;
    input clk,reset,cs,we;
    output reg [3:0] out;
    
    reg [3:0] RamMem[0:15];
    integer CountAddr;
    
    always @(posedge clk, posedge reset) begin
        if(reset)begin
            for(CountAddr = 0; CountAddr < 16; CountAddr = CountAddr+1)begin
                RamMem[CountAddr] <= 4'h0;
            end
        end else if (clk) begin
            if(cs)
                if(we)begin
                    RamMem[addr]<=data;
                    out<=4'bzzzz;
                end else begin
                    out<=RamMem[addr];
                end
            else begin
                out<=4'bzzzz;
            end
        end
    end
endmodule

module Test(input a, 
            input b, 
            input c,
            output reg [15:0] Out);
    reg[15:0] d0;

    always@(posedge a, posedge b, posedge c)begin
        if (a)begin
            d0 <= {16{1'h0}};
            if(b)begin
                Out <= d0;
            end
            if(c)begin
                Out <= 16'h0;
            end
        end else begin
            d0 <= {13{1'h0}, a, b, c};
        end
    end
endmodule


module Test(input a,
            input b,
            input c,
            output reg [15:0] Out);

    wire[15:0] n0;
    wire[15:0] n1;
    wire[15:0] n2;

    assign n0 = 16'h0;
    assign n1 = {16{1'b0}};
    assign n2 = 16'h0000_0000_1111_2222;

    always @(*) begin
        if(a) begin
            Out = {16{1'h0}};
        end else begin
            Out = {a, {13{1'b0}}, b, c};
        end
    end
endmodule

module FIFO(
  input [1:0] Opcode,
  input [31:0] Din,
  input Reset,
  input Clk,
  output reg [31:0] Dout,
  output reg FifoFull,
  output reg FifoEmpty,
  output reg Overflow,
  output reg Underflow
);
  
  reg [31:0] RamMem[15:0];
  integer indexCitire, indexScriere, fifo_counter;

  localparam read = 2'b10;
  localparam write = 2'b01;
 
 
  always@(posedge Clk, posedge Reset)
    begin
      if(Reset)
        begin
          Overflow <= 1'b0;
          Underflow <= 1'b0;
        end
	  else if( FifoFull && Opcode==write )
         Overflow <= 1'b1;
	  else if( FifoEmpty && Opcode==read   )
         Underflow <= 1'b1;
    end

  
  
  always@(posedge Clk, posedge Reset)
    begin
	  if( Overflow )
         Overflow <= 1'b0;
      
	  if( Underflow )
         Underflow <= 1'b0;
    end


  
 
 always @(fifo_counter)
    begin
       FifoEmpty <= (fifo_counter==0);
       FifoFull <= (fifo_counter== 15);
  end

 always @(posedge Clk or posedge Reset) //comportament numarator celule de 	memorie ocupate
begin
   if( Reset )
       fifo_counter <= 0;

  else if( Opcode==2'b00 || Opcode==2'b11 ) //inactiv
       fifo_counter <= fifo_counter;

   else if( !FifoFull && Opcode==write )
       fifo_counter <= fifo_counter + 1;

   else if( !FifoEmpty && Opcode==read )
       fifo_counter <= fifo_counter - 1;
   else
      fifo_counter <= fifo_counter;
end

always@(posedge Clk or posedge Reset)
begin
   if( Reset )
   begin
	  Dout <= 0;
      indexScriere <= 0;
      indexCitire <= 0;
   end
   else
     begin
       if( !FifoFull && Opcode==write )
          begin
               RamMem[ indexScriere ] <= Din;
               indexScriere <= indexScriere + 1;
          end
    	else  
           indexScriere <= indexScriere;

    if( !FifoEmpty && Opcode==read )  
	  begin
			Dout <= RamMem[indexCitire];
        	indexCitire <= indexCitire + 1;
	  end
      else 
       		indexCitire <= indexCitire;
   end
    if( indexScriere == 16)
      indexScriere = 0;
end

endmodule
