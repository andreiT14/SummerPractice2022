`timescale 1ns/1ps
module MemotyTb();
    parameter AddrSizeTb = 8;
    parameter DataSizeTb = 32;


    reg ClkTb = 0;
    reg ResetTb = 0;
    reg[DataSizeTb-1: 0] DinTb = 0;
    reg[AddrSizeTb-1: 0] AddrTb = 0;
    reg ValidTb= 0;
    reg R_WTb= 0;

    wire[DataSizeTb-1: 0] DoutTb;

    reg[DataSizeTb-1: 0] DinData;
    integer AddrMem;

    //instantiate Memory
    Memory #(AddrSizeTb, DataSizeTb)MemoryInst(.Clk(ClkTb),
                                               .Reset(ResetTb),
                                               .Din(DinTb),
                                               .Addr(AddrTb),
                                               .Valid(ValidTb),
                                               .R_W(R_WTb),
                                               .Dout(DoutTb));

    initial begin
        ResetTb = 1'b1;
        #34
        ResetTb = 1'b0;
        DinData = 32'h1;

        //Drive read to various addresses
        ValidTb = 1'b1;
        R_WTb = 1'b1;
        for(AddrMem = 0; AddrMem < 8'h20 ; AddrMem= AddrMem + 1)begin
            #25;
            AddrTb = AddrMem;
            DinTb = DinData;
            DinData = DinData + 32'h10;
        end

        ValidTb = 1'b0;
        R_WTb = 1'b0;
        AddrTb = 0;
        DinTb = 0;

        #100

        ValidTb = 1'b1;
        R_WTb = 1'b0;
        for(AddrMem = 0; AddrMem < 8'h20 ; AddrMem= AddrMem + 1)begin
            #25;
            AddrTb = AddrMem;
        end
    end

    always #10 ClkTb <= ~ClkTb;
endmodule