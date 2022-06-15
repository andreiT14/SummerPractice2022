module Control_RW_Flow(input Clk,
                       input Reset,
                       input RW,
                       input ValidCmd,
                       input TransferDone,
                       input Active,
                       input Mode,
                       
                       output reg AccessMem,
                       output reg RWMem,
                       output reg SampleData,
                       output reg TransferData,
                       output reg Busy);

    parameter Idle              = 2'b00;
    parameter ReadMemory        = 2'b01,
              SampleAndTransfer = 2'b10,
              WriteMemory       = 2'b11;

    reg [1:0] ControllerCurrentState;
    reg [1:0] ControllerNextState;

    //Generate Next State
    always @(ValidCmd, Active, Mode, RW, TransferDone, ControllerCurrentState)begin
        case(ControllerCurrentState):
            Idle: 
                if( ValidCmd && Active && Mode && !RW && !TransferDone) begin
                    ControllerNextState = ReadMemory;
                end else if( ValidCmd && Active && !Mode && !TransferDone) begin
                    ControllerNextState = SampleAndTransfer;
                end else if( ValidCmd && Active && Mode && RW && !TransferDone )begin
                    ControllerNextState = WriteMemory;
                end else begin
                    ControllerNextState = Idle;
                end
            ReadMemory: 
                if(Active && Mode && !TransferDone)begin
                    ControllerNextState = SampleAndTransfer;
                end else begin
                    ControllerNextState = Idle;
                end
            SampleAndTransfer: 
                if(Active && !TransferDone)begin
                    ControllerNextState = SampleAndTransfer;
                end else if (Active && TransferDone)begin
                    ControllerNextState = Idle;
                end else begin
                    ControllerNextState = Idle;
                end
            WriteMemory: 
                if (ValidCmd && Active && Mode && RW && !TransferDone)begin
                    ControllerNextState = WriteMemory;
                end else if(Active && Mode && RW && !TransferDone)begin
                    ControllerNextState = WriteMemory;
                end else if(Active && Mode && !RW && !TransferDone)begin
                    ControllerNextState = Idle;
                end else begin
                    ControllerNextState = Idle;
                end
            default: ControllerNextState = Idle;
        endcase
    end

    //Model Current State
    always @(posedge Clk, posedge Reset)begin
        if(Reset)begin
            ControllerCurrentState <= Idle;
        end else if(Clk)begin
            ControllerCurrentState <= ControllerNextState;
        end
    end

    //Model Output
    always @(ControllerCurrentState)begin
        AccessMem    = ControllerCurrentState == ReadMemory ||
                       ControllerCurrentState == WriteMemory       ? 1'b1 : 1'b0;
        RWMem        = ControllerCurrentState == WriteMemory       ? 1'b1 : 1'b0;
        SampleData   = ControllerCurrentState == SampleAndTransfer ? 1'b1 : 1'b0;
        TransferData = ControllerCurrentState == SampleAndTransfer ? 1'b1 : 1'b0;
        Busy         = ControllerCurrentState != Idle              ? 1'b1 : 1'b0;
    end

    
endmodule