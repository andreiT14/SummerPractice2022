`timescale 1ns/1ps 

module FreqDividerTb();

    reg ResetTb;
    reg ClkTb;

    reg[31:0] DinTb;
    reg ConfigDivTb;
    reg EnableTb;

    wire ClkOutputTb;

    FreqDivider FreqDividerInst(.Reset(ResetTb),
                                .Clk(ClkTb),
                                .Din(DinTb),
                                .ConfigDiv(ConfigDivTb),
                                .Enable(EnableTb),
                                .ClkOutput(ClkOutputTb));

    initial begin
      	$dumpfile("dump.vcd"); 
      	$dumpvars;
      
        ResetTb = 1;
        ClkTb = 0;
        DinTb = 32'h0;
        ConfigDivTb =  0;
        EnableTb = 0;

        #23;
        ResetTb = 0;
        EnableTb = 1;
        #35

        EnableTb = 0;
        ConfigDivTb = 1;
        DinTb = 5;
        #10
        EnableTb = 1;
        ConfigDivTb = 0;
      
      	#300;
      	$finish;
    end

    always #5 ClkTb =~ ClkTb;
endmodule