// Code your design here
`include "Mux.v"
`include "Memory.v"
`include "Concatenator.v"
`include "SerialTranceiver.v"
`include "ControllerTop.v"
`include "ALU.v"
`include "FrequencyDivider.v"

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
  	wire CtrlModeTmp;
    wire CtrlActiveTmp;
  	wire CtrlBusyTmp;
    wire CtrlAccesMemTmp;
    wire CtrlRWMemTmp;
    wire CtrlSampleDataTmp;
    wire CtrlTransferDataTmp;

    //Memory wires
    wire[31:0] MemoryDoutTmp;

    //Transceiver wires
    wire[31:0] TxDinTmp;
    wire TxTransferDone;
  
  	//Comtrol Tranceiver
  	wire ClkTx;
    
    //Controll Calculator Reset
    assign ResetTmp = Reset & !CtrlActiveTmp;
  
  	assign CtrlRWTmp = RWMem & CtrlActiveTmp;
  	assign CalcActive = CtrlActiveTmp;
  	assign CalcMode   = CtrlModeTmp;
  	assign CalcBusy   = CtrlBusyTmp;
  
    //Control Operator A/ Operator B/ Selector
  	mux2to1 #(.WIDTH(8))MuxInA_inst(.out(MuxATmp),
                                     .d0(InA),
                                     .d1(8'h0),
                                     .sel(ResetTmp));

  	mux2to1 #(.WIDTH(8))MuxInB_inst(.out(MuxBTmp),
                                     .d0(InB),
                                     .d1(8'h0),
                                     .sel(ResetTmp));

  	mux2to1 #(.WIDTH(4))MuxSel_inst(.out(MuxSelTmp),
                                     .d0(Sel),
                                     .d1(4'h0),
                                     .sel(ResetTmp));


    //Add ALU logic block
    m_alu Alu_inst(.A(MuxATmp),
                   .B(MuxBTmp),
                   .ALU_Sel(MuxSelTmp),
                   .ALU_Out(AluOutTmp),
                   .Flag(AluFlagsTmp));

    

    //Add controller
    Controller Controller_inst(.Clk(Clk),
                               .Reset(Reset),
                               .ValidCmd(ValidCmd),
                               .RW(CtrlRWTmp),
                               .InputKey(InputKey),
                               .TransferDone(TxTransferDone),
                               .Busy(CtrlBusyTmp),
                               .Active(CtrlActiveTmp),
                               .Mode(CtrlModeTmp),
                               .AccessMem(CtrlAccesMemTmp),
                               .RWMem(CtrlRWMemTmp),
                               .SampleData(CtrlSampleDataTmp),
                               .TransferData(CtrlTransferDataTmp));


    
  	concatenator #(.WIDTH0(8), .WIDTH1(4))Concatenator_inst(.out(ConcatenatorOutTmp),
                                                            .inA(MuxATmp),
                                                            .inB(MuxBTmp),
                                                            .inC(AluOutTmp),
                                                            .inD(MuxSelTmp),
                                                            .inE(AluFlagsTmp));

  	Memory  #(.AddrSize(8), .DataSize(32))Memory_inst(.Clk(Clk),
                                                      .Reset(ResetTmp),
                                                      .Din(ConcatenatorOutTmp),
                                                      .Addr(Addr),
                                                      .Valid(CtrlAccesMemTmp),
                                                      .R_W(CtrlRWMemTmp),
                                                      .Dout(MemoryDoutTmp));

  	mux2to1 #(.WIDTH(32))MuxTransceiver_inst(.out(TxDinTmp),
                                              .d0(ConcatenatorOutTmp),
                                              .d1(MemoryDoutTmp),
                                              .sel(CalcMode));

  SerialTranceiver Registru_Shift_ParalelLoad_inst(.Clk(Clk),
                                                   .Reset(Reset),
                                                   .DataIn(TxDinTmp),
                                                   .Sample(CtrlSampleDataTmp),
                                                   .StartTx(CtrlTransferDataTmp),
                                                   .ClkTx(ClkTx),
                                                   .TxBusy(DoutValid),
                                                   .TxDone(TxTransferDone),
                                                   .DataOut(DataOut));


  FrequencyDivider FrequencyDivider_inst(.Reset(ResetTmp),
                                         .Clk(Clk),
                                         .Din(Din),
                                         .ConfigDiv(ConfigDiv),
                                         .Enable(CtrlTransferDataTmp),
                                         .ClkOutput(ClkTx));
    



endmodule