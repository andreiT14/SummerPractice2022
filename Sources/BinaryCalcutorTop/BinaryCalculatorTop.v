module BinaryCalculatorTop(
    input Clk,
    input Reset,

    //Config Tranceiver Frequency
    input ConfigDiv,
    input[31:0] Din,

    //Acces Memory & Enable Calculator 
    input ValidCmd,
    input InputKey,
    input RWMem,
    input[7:0] Addr,

    //Access ALU 
    input[3:0] Sel,
    input[7:0] InA,
    input[7:0] InB,

    output CalcActive,
    output CalcMode,
    output CalcBusy,

    output DoutValid,
    output DataOut,
    output ClkTx);

    //FIXME- Remove assing
    assign ClkTx = Clk;

    wire ResetTmp;

    //Mux Operator A/Operator B/ Selector wires
    wire[7:0] MuxATmp;
    wire[7:0] MuxBTmp;
    wire[3:0] MuxSelTmp;

    //Alu ouput wires
    wire[7:0] AluOutTmp;
    wire[3:0] AluFlagsTmp;

    //Concatenator output
    wire[31:0] ConcatenatorOutTmp;

    //Controller wires
    wire CtrlRWTmp;
    wire CtrlActiveTmp;
    wire CtrlAccesMemTmp;
    wire CtrlRWMemTmp;
    wire CtrlSampleDataTmp;
    wire CtrlTransferDataTmp;

    //Memory wires
    wire[31:0] MemoryDoutTmp;

    //Transceiver wires
    wire[31:0] TxDinTmp;
    wire TxTransferDone;
    
    //Controll Calculator Reset
    assign ResetTmp = Reset & !CtrlActiveTmp;


    //Control Operator A/ Operator B/ Selector
    mux2to1 MuxInA_inst #(WIDTH = 8)(.out(MuxATmp),
                                     .d0(InA),
                                     .d1(8'h0),
                                     .sel(ResetTmp));

    mux2to1 MuxInB_inst #(WIDTH = 8)(.out(MuxBTmp),
                                     .d0(InB),
                                     .d1(8'h0),
                                     .sel(ResetTmp));

    mux2to1 MuxSel_inst #(WIDTH = 4)(.out(MuxSelTmp),
                                     .d0(Sel),
                                     .d1(4'h0),
                                     .sel(ResetTmp));


    //Add ALU logic block
    m_alu Alu_inst(.A(MuxATmp),
                   .B(MuxBTmp).
                   .ALU_Sel(MuxSelTmp),
                   .ALU_Out(AluOutTmp),
                   .Flag(AluFlagsTmp));

    assign CtrlRWTmp = RW & CtrlActive;

    //Add controller
    Controller Controller_inst(.Clk(Clk),
                               .Reset(Reset),
                               .ValidCmd(ValidCmd),
                               .RW(CtrlRWTmp),
                               .InputKey(InputKey),
                               .TransferDone(TxTransferDone),
                               .Busy(CalcBusy),
                               .Active(CalcActive),
                               .Mode(CalcMode),
                               .AccessMem(CtrlAccesMemTmp),
                               .RWMem(CtrlRWMemTmp),
                               .SampleData(CtrlSampleDataTmp),
                               .TransferData(CtrlTransferDataTmp));


    
    concatenator Concatenator_inst #(WIDTH0 = 8, WIDTH1 = 4)(.out(ConcatenatorOutTmp),
                                                            .inA(MuxATmp),
                                                            .InB(MuxBTmp),
                                                            .inC(AluOutTmp),
                                                            .inD(MuxSelTmp),
                                                            .inE(AluFlagsTmp));

    Memory Memory_inst #(AddrSize = 8, DataSize = 32)(.Clk(Clk),
                                                      .Reset(ResetTmp),
                                                      .Din(ConcatenatorOutTmp),
                                                      .Addr(Addr),
                                                      .Valid(CtrlActiveTmp),
                                                      .R_W(CtrlRWMemTmp),
                                                      .Dout(MemoryDoutTmp));

    mux2to1 MuxTransceiver_inst#(WIDTH = 32 )(.out(TxDinTmp),
                                              .d0(ConcatenatorOutTmp),
                                              .d1(MemoryDoutTmp),
                                              .sel(CalcMode));

    SerialTranceiver Registru_Shift_ParalelLoad_inst(.Clk(Clk),
                                                     .Reset(Reset),
                                                     .DataIn(TxDinTmp),
                                                     .Sample(CtrlSampleDataTmp),
                                                     .StartTx(CtrlTransferDataTmp),
                                                     .ClkTx(Clk),
                                                     .TxBusy(CalcBusy),
                                                     .TxDone(TxTransferDone),
                                                     .DataOut(DataOut));


    //FIXME - Add frequency divider.
    



endmodule