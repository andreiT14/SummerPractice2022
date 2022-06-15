module Control_RW_FlowTb();

    reg ClkTb;
    reg ResetTb;
    reg RWTb;
    reg ValidCmdTb;
    reg ActiveTb;
  	reg	TransferDoneTb;
    reg ModeTb;
                       
    wire AccessMemTb;
    wire RWMemTb;
    wire SampleDataTb;
    wire TransferDataTb;
    wire BusyTb;

    Control_RW_Flow Control_RW_FLowInst(.Clk(ClkTb),
                                        .Reset(ResetTb),
                                        .RW(RWTb),
                                        .ValidCmd(ValidCmdTb),
                                        .TransferDone(TransferDoneTb),
                                        .Active(ActiveTb),
                                        .Mode(ModeTb),
                                        .AccessMem(AccessMemTb),
                                        .RWMem(RWMemTb),
                                        .SampleData(SampleDataTb),
                                        .TransferData(TransferDataTb),
                                        .Busy(BusyTb));

    initial begin
      	$dumpfile("dump.vcd"); 
      	$dumpvars;
      
        ClkTb <= 0;
        ResetTb <= 0;
        RWTb <= 0;
        ValidCmdTb <= 0;
        ActiveTb <= 0;
      	TransferDoneTb <= 0;
        ModeTb <= 0;

        //Generate Reset
      	$display("[%0t]: Generate Reset for #20", $time);
        ResetTb <= 1'b1;
      	#20
      	$display("[%0t]: Deassert Reset", $time);
        ResetTb <= 1'b0;

      	#30
      	$display("[%0t]: Generate Read Memory sequence ", $time);
      	ValidCmdTb <= 1;
        ActiveTb <= 1;
        ModeTb <= 1;
      	RWTb <= 0;
      	#10
      	ValidCmdTb <= 0;
        ActiveTb <= 1;
        ModeTb <= 1;
      	RWTb <= 0;
      	#156;
      	TransferDoneTb <= 1;
      	#15
      	TransferDoneTb <= 0;
      	$display("[%0t]: Read Memory sequence Done ", $time);

        //Generate a simple Read. MODE = 0;
        #30
      	$display("[%0t]: Generate Read Memory sequence. MODE = 0 ", $time);
      	ValidCmdTb <= 1;
        ActiveTb <= 1;
        ModeTb <= 0;
      	RWTb <= 0;
      	#10
      	ValidCmdTb <= 0;
        ActiveTb <= 1;
        ModeTb <= 0;
      	RWTb <= 0;
      	#156;
      	TransferDoneTb <= 1;
      	#15
      	TransferDoneTb <= 0;
      	$display("[%0t]: Read Memory sequence Done. MODE = 0 ", $time);


        //Generate write flow
        /Generate a simple Read. MODE = 0;
        #30
      	$display("[%0t]: Generate Write Memory sequence. MODE = 1 ", $time);
      	ValidCmdTb <= 1;
        ActiveTb <= 1;
        ModeTb <= 1;
      	RWTb <= 1;
      	#50
      	ValidCmdTb <= 0;
        ActiveTb <= 1;
        ModeTb <= 1;
      	RWTb <= 0;
      	$display("[%0t]: Generate write memory sequence Done. MODE = 0 ", $time);
        #2000;
        $finish;

    end

    //generate clock
    always #5 ClkTb = ~ClkTb;

endmodule
