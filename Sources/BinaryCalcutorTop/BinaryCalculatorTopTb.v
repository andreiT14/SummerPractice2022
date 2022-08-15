// Code your testbench here
// or browse Examples
module BinaryCalculatorTopTb();
  
    //input signals
    reg ClkTb;
    reg ResetTb;
    reg ConfigDivTb;
    reg [31:0] DinTb;
    reg ValidCmdTb;
    reg InputKeyTb;
    reg RWMemTb;
    reg[7:0] AddrTb;

    reg[3:0] SelTb;
    reg[7:0] InATb;
    reg[7:0] InBTb;

    wire CalcActiveTb;
    wire CalcModeTb;
    wire CalcBusyTb;

    wire DoutValidTb;
    wire DataOutTb;
    wire ClkTxTb;

    BinaryCalculatorTop BinaryCalculatorTop_i nst(
        .Clk(ClkTb),
        .Reset(ResetTb),

        //config Div
        .ConfigDiv(ConfigDivTb),
        .Din(DinTb),

        //Access Memory & Enable Calculator
        .ValidCmd(ValidCmdTb),
        .InputKey(InputKeyTb),
        .RWMem(RWMemTb),
        .Addr(AddrTb),

        //Access ALU
        .Sel(SelTb),
        .InA(InATb),
        .InB(InBTb),

        .CalcActive(CalcActiveTb),
        .CalcMode(CalcModeTb),
        .CalcBusy(CalcBusyTb),

        .DoutValid(DoutValidTb),
        .DataOut(DataOutTb),
        .ClkTx(ClkTxTb)
    ); 

endmodule
