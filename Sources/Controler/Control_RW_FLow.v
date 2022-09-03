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

    localparam IDLE                 = 3'b000;
    localparam READ_MEMORY          = 3'b001;
    localparam SAMPLE_DATA          = 3'b010;
    localparam TRANFER_DATA         = 3'b011;  
    localparam WRITE_MEMORY         = 3'b100;

    reg [2:0] ControllerCurrentState;
    reg [2:0] ControllerNextState;

    //Generate Next State
    //Generate NextState looking on : ValidCmd, RW, Active, Mode, TransferDone
    always @(ValidCmd, Active, Mode, RW, TransferDone, ControllerCurrentState)begin
        case(ControllerCurrentState)
            IDLE:
              if ( ValidCmd && !RW && Active && Mode && !TransferDone)begin
                    ControllerNextState = READ_MEMORY;
                end else if( ValidCmd && RW && Active && Mode) begin
                    ControllerNextState = WRITE_MEMORY;
                end else if ( ValidCmd && Active && !Mode && !TransferDone ) begin
                    ControllerNextState = SAMPLE_DATA;
                end else begin
                    ControllerNextState = IDLE;
                end

            READ_MEMORY:
                if ( Active && Mode && !TransferDone) begin
                    ControllerNextState = SAMPLE_DATA;
                end else begin
                    ControllerNextState = IDLE;
                end

            WRITE_MEMORY:
                if(ValidCmd && RW && Active && Mode) begin
                    ControllerNextState = WRITE_MEMORY;
                end else begin
                    ControllerNextState = IDLE;
                end

            SAMPLE_DATA:
                if( Active && !TransferDone) begin
                    ControllerNextState = TRANFER_DATA;
                end

            TRANFER_DATA: 
                if(Active && !TransferDone) begin
                    ControllerNextState = TRANFER_DATA;
                end else if (Active && TransferDone)begin
                    ControllerNextState = IDLE;
                end else begin
                    ControllerNextState = IDLE;
                end

            default: ControllerNextState = IDLE;
        endcase
    end

    //Model Current State
    always @(posedge Clk, posedge Reset)begin
        if(Reset)begin
            ControllerCurrentState <= IDLE;
        end else if(Clk)begin
            ControllerCurrentState <= ControllerNextState;
        end
    end

    //Model Output
    always @(ControllerCurrentState)begin
        AccessMem    = ControllerCurrentState == READ_MEMORY ||
                       ControllerCurrentState == WRITE_MEMORY      ? 1'b1 : 1'b0;
        RWMem        = ControllerCurrentState == WRITE_MEMORY      ? 1'b1 : 1'b0;
        SampleData   = ControllerCurrentState == SAMPLE_DATA       ? 1'b1 : 1'b0;
        TransferData = ControllerCurrentState == TRANFER_DATA      ? 1'b1 : 1'b0;
        Busy         = ControllerCurrentState != IDLE              ? 1'b1 : 1'b0;
    end

    
endmodule