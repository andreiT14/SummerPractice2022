/* ALU Arithmetic and Logic Operations
----------------------------------------------------------------------
|ALU_Sel|   ALU Operation
----------------------------------------------------------------------
| 0000  |   ALU_Out = A + B; ( A + B ) > 8 bits => CF = 1; (carry flag)
----------------------------------------------------------------------
| 0001  |   ALU_Out = A - B; ( A < B ) => UF = 1; (underflow flag)
----------------------------------------------------------------------
| 0010  |   ALU_Out = A * B; ( A || B) > h'F => OF =1; (overflow flag)
----------------------------------------------------------------------
| 0011  |   ALU_Out = A / B; ( A < B ) => UF = 1; (underflow flag)
----------------------------------------------------------------------
| 0100  |   ALU_Out = A << B; => CF ; (carry flag)
----------------------------------------------------------------------
| 0101  |   ALU_Out = A >> B;  => CF ; (carry flag)
----------------------------------------------------------------------
| 0110  |   ALU_Out = A and B;
----------------------------------------------------------------------
| 0111  |   ALU_Out = A or B;
----------------------------------------------------------------------
| 1000  |   ALU_Out = A xor B;
----------------------------------------------------------------------
| 1001  |   ALU_Out = A nxor B;
----------------------------------------------------------------------
| 1010  |   ALU_Out = A nand B;
----------------------------------------------------------------------
| 1011  |   ALU_Out = A nor B;
----------------------------------------------------------------------
| 1100  |   ALU_Out = A nand B;
----------------------------------------------------------------------
| 1101  |   ALU_Out = 0; FLAG=0; ZF => 1 ; (zero flag)
----------------------------------------------------------------------
| 1110  |   ALU_Out = 0; FLAG=0; ZF => 1 ; (zero flag)
----------------------------------------------------------------------
| 1111  |   ALU_Out = 0; FLAG=0; ZF => 1 ; (zero flag)
----------------------------------------------------------------------*/

module m_alu(A, B, ALU_Sel, ALU_Out, Flag);

  input [7:0] A,B;  // ALU 8-bit Inputs                 
  input [3:0] ALU_Sel;// ALU Selection
  output [7:0] ALU_Out; // ALU 8-bit Output
  output  reg [3:0] Flag; // Flag[0] - ZeroFlag (ZF), Flag[1] - CarryFlag (CF), Flag[2] - OverflowFlag (OF), Flag[3] - UnderflowFlag (UF)
    
	reg [7:0] ALU_Result;
	reg [8:0] tmp;
    assign ALU_Out = ALU_Result; // ALU out
  
    always @(*)
    begin
        case(ALU_Sel)
        4'b0000: // Addition
          begin
          if((A+B)>8'hff) begin
              ALU_Result = 8'h0;
              Flag[1]=1;
            end
            else
              ALU_Result = A + B;
          end 
        4'b0001: // Subtraction 
          begin
            if(A<B) begin
            ALU_Result = 8'h0;
              Flag[3] = 1; //UF=1
            end
            else
              ALU_Result = A - B ; 
          end
        4'b0010: // Multiplication
          begin
            if((A>8'hf) && (B>8'hf)) begin
              ALU_Result = 8'h0;
              Flag[2]=1;
            end
            else
              ALU_Result = A * B;
          end
        4'b0011: // Division
          begin
            if(A<B) begin
            ALU_Result = 8'h0;
              Flag[3] = 1; //UF=1
            end
            else
              ALU_Result = A / B ; 
          end
        4'b0100: // Logical shift left
          begin
             ALU_Result = A << B; 
             tmp = {1'b0,A} + {1'b0,B};
             Flag[1] = tmp[8]; //Cf=1
          end
         4'b0101: // Logical shift right
           begin
           /*ALU_Result = A >> B; 
             tmp = {1'b0,A} + {1'b0,B};
             Flag[1] = tmp[8]; //Cf=1
            */
             //ATODERIT
             tmp = {A,1'b0};
             tmp = tmp >> B;
             ALU_Result = tmp[8:1];
             Flag[1] = tmp[0];
           end
         4'b0110: // Logical and
           ALU_Result = A & B;
         4'b0111: // Logical or
           ALU_Result = A | B;
          4'b1000: //  Logical xor 
           ALU_Result = A ^ B;
          4'b1001: //  Logical nxor
            ALU_Result = ~(A ^ B);
          4'b1010: //  Logical nand 
            ALU_Result = ~(A & B);
          4'b1011: //  Logical nor
           ALU_Result = ~(A | B);
          4'b1100,4'b1101,4'b1110,4'b1111:// Default
            begin
            ALU_Result = 8'h0 ; Flag = 4'h0;
            end
          default: begin ALU_Result = 8'h0 ; Flag = 4'h0; end
        endcase
        if (!ALU_Result)
          Flag[0]=1; //ZF=1
    end
  
endmodule

    