module FIFO(input Clk,
            input Reset,

            input [1:0] OpCode,
            input [31:0] Din,

            output reg [31:0] Dout,
            output reg FifoFull,
            output reg FifoEmpty,
            output reg Overflow,
            output reg Underflow);

    localparam FIFO_WIDTH = 16;
    localparam WRITE = 2'b01;
    localparam READ = 2'10;

    reg [3:0] CountAddress;
    reg [31:0] FifoMemory [3:0];
    integer CountPos;

    always @(posedge Clk, posedge Reset)begin // Acces memorie
        if(Reset) begin
            CountAddress <= 4'h0; //4'b0//4'b1000;
            Dout <= 32'h0;
            for(CountPos = 0; CountPos < FIFO_WIDTH; CountPos = CountPos + 1)begin
                FifoMemory[CountPos] <= 32'h0;
            end
        end else begin
            if(OpCode == WRITE && CountAddress < FIFO_WIDTH) begin
                FifoMemory[CountAddress] <= Din;
                CountAddress <= CountAddress + 4'b1;
            end
            if(OpCode == READ && CountAddress >= 0) begin
                Dout <= FifoMemory[0];
                for(CountPos = 1; CountPos < CountAddress; CountPos = CountPos + 1 )begin
                    FifoMemory[CountPos-1] <= FifoMemory[CountPos]; 
                end
                CountAddress <= CountAddress - 1;
            end
        end
    end
    
    always @(posedge Clk, posedge Reset)begin //Comportament FifoFull/ FifoEmpty/ Overflow/ Underflow
        if(Reset) begin
            FifoFull    <= 1'b0;
            FifoEmpty   <= 1'b0;
            Overflow    <= 1'b0;
            Underflow   <= 1'b0;
        end else begin
            if( CountAddress == 4'hE && OpCode == WRITE)begin
                FifoFull <= 1'b1;
            end
            if( CountAddress == 4'b1 && Opcode == READ)begin
                FifoEmpty <= 1'b1;
            end
            if( CountAddress == 4'hF && Opcode == WRITE)begin
                Overflow <= 1'b1;
            end
            if( CountAddress == 4'h0 && Opcode == READ)begin
                Underflow <= 1'b1;
            end
            if(FifoFull)begin
                FifoFull <= ~FifoFull;
            end
            if(FifoEmpty)begin
                FifoEmpty <= ~FifoEmpty;
            end
            if(Overflow && OpCode != WRITE)begin
                Overflow <= ~Overflow;
            end
            if(Underflow && OpCode != READ)begin
                Underflow <= ~Underflow;
            end
        end
    end 


endmodule


