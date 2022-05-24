
module SerialTranceiver(
    input Reset,
    input Clk,

    input[31:0] DataIn,
    input Sample,
    input StartTx,
    input ClkTx,

    output TxBusy,
    output TxDone,
    output DataOut //working at ClkTx
);

    reg[31:0] DataInTmp;
    reg TransferData;
    reg TransferSerialInProgress;
    reg[31:0] CountDataBits;

    assign TxBusy = CountDataBits <= 31 && (TransferData || TransferSerialInProgress);

    assign TxDone = CountDataBits == 0 && TransferSerialInProgress;

    assign DataOut = TransferSerialInProgress & DataInTmp[CountDataBits];

    always @(posedge Clk, posedge Reset)begin
        if(Reset)begin
            //reset internal logic
            DataInTmp <= 32'b0;
            TransferData <= 0;
        end else begin
            if(Clk && Sample && !TxBusy)begin
                DataInTmp <= DataIn;
            end
            if(Clk && StartTx && !TxBusy) begin
                TransferData <= 1'b1;
            end
            if(Clk && TransferData && CountDataBits == 32'b0)begin
                TransferData <= 1'b0;
            end
        end
    end

    always @(posedge ClkTx, posedge Reset)begin
        if(Reset)begin
            CountDataBits <= 32'd31;
            TransferSerialInProgress <= 1'b0;
        end else begin
            if(ClkTx && TransferData && !TransferSerialInProgress)begin
                TransferSerialInProgress <= 1'b1;
            end
            if(ClkTx && TransferSerialInProgress && CountDataBits > 0) begin
                CountDataBits <= CountDataBits - 1; 
            end else if(ClkTx && TransferSerialInProgress && CountDataBits == 0)begin
                TransferSerialInProgress <= 0;
                CountDataBits <= 32'd31; 
            end
        end
    end
    
endmodule