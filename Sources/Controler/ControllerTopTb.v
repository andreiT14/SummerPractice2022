`timescale 1ns/1ps
module ControllerTb();

    reg ClkTb;
    reg ResetTb;
    reg ValidCmdTb;
    reg RWTb;
    reg InputKeyTb;
    reg TransferDoneTb;

    wire BusyTb;
    wire ActiveTb;
    wire ModeTb;
    wire AccessMemTb;
    wire RWMemTb;
    wire SampleDataTb;
    wire TransferDataTb;

    Controller ControllerInst(.Clk(ClkTb),
                              .Reset(ResetTb),
                              .ValidCmd(ValidCmdTb),
                              .RW(RWTb),
                              .InputKey(InputKeyTb),
                              .TransferDone(TransferDoneTb),
                              .Busy(BusyTb),
                              .Active(ActiveTb),
                              .Mode(ModeTb),
                              .AccessMem(AccessMemTb),
                              .RWMem(RWMemTb),
                              .SampleData(SampleDataTb),
                              .TransferData(TransferDataTb));

    //generate clock
    always #5 ClkTb <= ~ClkTb;

    initial begin
        $dumpfile("dump.vcd"); 
      	$dumpvars;

        //Resetam semnalele interne
        ClkTb <= 1'b0;
        ResetTb <= 1'b0;
        ValidCmdTb <= 1'b0;
        RWTb <= 1'b0;
        InputKeyTb <= 1'b0;
        TransferDoneTb <= 1'b0;

        //Generate reset
        ResetTb <= 1'b1;
        #23;
        ResetTb <= 1'b0;

        //Generate an fake READ
        $display("[%0t]: Generate Fake Read Memory sequence.", $time);
        ValidCmdTb <= 1'b1;
        RWTb       <= 1'b0;
        #10;
        ValidCmdTb <= 1'b0;

        //Generate an fake WRITE
        #100
        $display("[%0t]: Generate Fake Write Memory sequence.", $time);
        ValidCmdTb <= 1'b1;
        RWTb       <= 1'b1;
        #10;
        ValidCmdTb <= 1'b0;


        //Enable controller
        #200
        $display("[%0t]: Enable Controller", $time);
        ValidCmdTb  <= 1'b1;
        InputKeyTb  <= 1'b1;
        #10;
        InputKeyTb  <= 1'b0;
        #10;
        InputKeyTb  <= 1'b1;
        #10 
        InputKeyTb  <= 1'b0;
        #10
        InputKeyTb  <= 1'b1; //MODE = 1;

        //Release signals
        #10
        ValidCmdTb <= 1'b0;
        InputKeyTb <= 1'b0;
        //Enable Controller Done


        //Generate valid Read
        $display("[%0t]: Generate Valid READ Memory sequence.", $time);
        #50
        ValidCmdTb <= 1'b1;
        RWTb       <= 1'b0;
        #10;
        ValidCmdTb <= 1'b0;

        //Generate TransferDone
        #200;
        TransferDoneTb <= 1'b1;
        #30;
        TransferDoneTb <= 1'b0;

        //Generate valid WRITE
        #100
        $display("[%0t]: Generate Valid WRITE Memory sequence.", $time);
        ValidCmdTb <= 1;
      	RWTb <= 1;
      	#10
      	ValidCmdTb <= 0;
      	RWTb <= 0;

        //Resetam circuitul pentru a modifica mode-ul
        #200
        $display("[%0t]: Reset controller.", $time);
        ResetTb <= 1'b1;
        #20
        ResetTb <= 1'b0;

        //Enable controller
        #200
        $display("[%0t]: Enable Controller", $time);
        ValidCmdTb  <= 1'b1;
        InputKeyTb  <= 1'b1;
        #10;
        InputKeyTb  <= 1'b0;
        #10;
        InputKeyTb  <= 1'b1;
        #10 
        InputKeyTb  <= 1'b0;
        #10
        InputKeyTb  <= 1'b0; //MODE = 0;
        
        //Release signals
        #10
        ValidCmdTb <= 1'b0;
        InputKeyTb <= 1'b0;
        //Enable Controller Done

        //Generate valid Read
        $display("[%0t]: Generate Valid READ Memory sequence.", $time);
        #50
        ValidCmdTb <= 1'b1;
        RWTb       <= 1'b0;
        #10;
        ValidCmdTb <= 1'b0;

        //Generate TransferDone
        #200;
        TransferDoneTb <= 1'b1;
        #30;
        TransferDoneTb <= 1'b0;

        //Generate valid WRITE
        #100
        $display("[%0t]: Generate Valid WRITE Memory sequence.", $time);
        ValidCmdTb <= 1;  
      	RWTb <= 1;
      	#10
      	ValidCmdTb <= 0;
      	RWTb <= 0;

        #2000;
        $finish;

    end
endmodule