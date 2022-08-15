`timescale 1ns/1ps
module Controller(input Clk,
                  input Reset,
                  input ValidCmd,
                  input RW,
                  input InputKey,
                  input TransferDone,
                  
                  output Busy,
                  output Active,
                  output Mode,
                  //Acces Memory
                  output AccessMem,
                  output RWMem,
                  //Control Tranceiver
                  output SampleData,
                  output TransferData);


    DecodificatorKey DecodificatorKeyInst(.Clk(Clk),
                                          .Reset(Reset),
                                          .ValidCmd(ValidCmd),
                                          .InputKey(InputKey),
                                          .Active(Active),
                                          .Mode(Mode));


    Control_RW_Flow Control_RW_FLowInst(.Clk(Clk),
                                        .Reset(Reset),
                                        .RW(RW),
                                        .ValidCmd(ValidCmd),
                                        .TransferDone(TransferDone),
                                        .Busy(Busy),
                                        .Active(Active),
                                        .Mode(Mode),
                                        .AccessMem(AccessMem),
                                        .RWMem(RWMem),
                                        .SampleData(SampleData),
                                        .TransferData(TransferData));


endmodule