`timescale 1ns/1ps

module SerialTranceiverTb();
    reg ResetTb = 0;
    reg ClkTb = 0;

    reg[31:0] DataInTb = 0;
    reg SampleTb = 0;
    reg StartTxTb = 0;
    reg ClkTxTb = 0;

    wire TxBusyTb;
    wire TxDoneTb;
    wire DataOutTb;

    SerialTranceiver SerialTranceiverTest(.Reset(ResetTb),
                                          .Clk(ClkTb),
                                          .DataIn(DataInTb),
                                          .Sample(SampleTb),
                                          .StartTx(StartTxTb),
                                          .ClkTx(ClkTxTb),
                                          .TxBusy(TxBusyTb),
                                          .TxDone(TxDoneTb),
                                          .DataOut(DataOutTb));


    always #5 ClkTb <= ~ClkTb;

    always #10 ClkTxTb <= ~ClkTxTb;

    initial begin
        ResetTb = 1;
        #50;
        ResetTb = 0;
        #20;
        SampleTb = 1;
        DataInTb = 32'hF00F_100F;
        #10;
        SampleTb = 0;
        #23
        StartTxTb = 1;
        #23
        StartTxTb = 0;

        #1000
        ResetTb = 1;
        #5;
        ResetTb = 0;

    end
endmodule