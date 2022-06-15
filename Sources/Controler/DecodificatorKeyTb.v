`timescale 1ns/1ps
module DecodificatorKeyTb();

    reg ClkTb;
    reg ValidCmdTb;
    reg InputKeyTb;
    reg ResetTb;

    wire ActiveTb;
    wire ModeTb;

    DecodificatorKey DecodificatorKeyInst(.Clk(ClkTb),
                                          .Reset(ResetTb),
                                          .ValidCmd(ValidCmdTb),
                                          .InputKey(InputKeyTb),
                                          .Active(ActiveTb),
                                          .Mode(ModeTb));


    initial begin
        ClkTb = 0;
        ValidCmdTb = 0;
        InputKeyTb = 0;
        ResetTb = 1;
        $display("Reset Tb");
        #15;

        ResetTb = 1'b0;
        //Introduce InputKey
        ValidCmdTb = 1'b1;
        InputKeyTb = 1'b1;
        #10;
        InputKeyTb = 1'b0;
        #10
        InputKeyTb = 1'b1;
        #10
        InputKeyTb = 1'b0;
        #10
        //Mode = 1;
        InputKeyTb = 1'b1;
        #10;
        ValidCmdTb = 1'b0;
        InputKeyTb = 1'b0;
    end

    always #5 ClkTb = ~ClkTb;
endmodule