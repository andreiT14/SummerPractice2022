`timescale 1ns/1ps
module DFlipFlop(input Clk,
                 input Reset,
                 input D,
                 output Out);

    reg OutTmp;
    
    assign Out = OutTmp;

    always @(posedge Clk, posedge Reset)begin
        if(Reset) begin
            OutTmp <= 1'b0;
        end else if (Clk) begin
            OutTmp <= D;
        end
    end
endmodule