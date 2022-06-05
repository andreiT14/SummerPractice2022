`timescale 1ns/1ps
module Memory#(parameter AddrSize = 8,
               parameter DataSize = 32)(
               input                Clk,
               input                Reset,
               input[DataSize-1: 0] Din,
               input[AddrSize-1: 0] Addr,
               input                Valid,
               input                R_W, //1 = Write; 0 = Read; 

               output[DataSize-1: 0] Dout
               );

    reg [DataSize-1: 0] MemoryBank [(2**AddrSize)-1: 0]; //Memory Bank

    reg [DataSize-1: 0] AccesMemLocation;

    integer MemAddr = 0;

    assign Dout = AccesMemLocation;
    
    always @(posedge Clk, posedge Reset)begin
        if(Reset) begin
            //Reset Memory
            for(MemAddr = 0; MemAddr < (2 ** AddrSize); MemAddr = MemAddr + 1)begin
                MemoryBank[MemAddr] <= {DataSize{1'b0}};
            end
        end else if(Clk) begin
            if( Valid && R_W )begin
                //Write Flow
                MemoryBank[Addr] <= Din;
            end else if( Valid && !R_W)begin
                //Read Flow
                AccesMemLocation <= MemoryBank[Addr];
            end
        end
    end


endmodule