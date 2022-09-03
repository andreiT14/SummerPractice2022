`timescale 1ns/1ps 

module FrequencyDivider(
    input Reset,
    input Clk,

    input[31:0] Din,
    input ConfigDiv,
    input Enable,

    output ClkOutput
);
    reg[31:0] FrequenceDivTarget;
    reg[31:0] CountFreqDiv;


    assign ClkOutput = Enable && (FrequenceDivTarget == 1'b1 ? Clk : CountFreqDiv <= (FrequenceDivTarget >> 1) ? 1'b1: 1'b0);

    //Configure Divider
    always @(posedge Clk, posedge Reset)begin
        if(Reset)begin
            FrequenceDivTarget <= 32'h1;
        end else if (Clk && ConfigDiv && !Enable) begin //Nu pot configura generatorul in timp ce functioneaza
            if(Din > 1'b1)begin
                FrequenceDivTarget <= Din;
            end else begin
                FrequenceDivTarget <= 1'b1;
            end
        end
    end

    //Generare clock
    always @(posedge Clk, posedge Reset)begin
        if(Reset)begin
            CountFreqDiv <= 32'h1;
        end else if (Clk) begin
            if (Enable) begin
                if (CountFreqDiv == FrequenceDivTarget)begin
                    CountFreqDiv <= 1;
                end else if( CountFreqDiv < FrequenceDivTarget) begin
                    CountFreqDiv <= CountFreqDiv + 1'b1;
                end
            end else if (!Enable) begin
                CountFreqDiv <= 32'h1;
            end
        end
    end

endmodule