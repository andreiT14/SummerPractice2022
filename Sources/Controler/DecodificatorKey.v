//This module controlls decodification of the INPUT_Key.
//Once INPUT_Key was introduced completly and correctly decoder will assign ACTIVE and  MODE
//INPUT_KEY : 
    //Bit 4: MODE 
        //MODE = 0; 
        //MODE = 1;
    //Bit 3:0: SecretPhase: 0101

// This implementation uses MOORE/MEAlY FSM knowledge.
// Using FSM approach there will be 3 main components:
    // 1. Combinational block: Generate Next State
    // 2. Memory Block: Memory the current state 
    // 3. Combinational block: Generate the output signal using current state
module DecodificatorKey(input Clk,
                        input Reset,
                        input ValidCmd,
                        input InputKey,
                        
                        output Active, //Set when the user introduce corrent input Key
                        output Mode);

    //reg ActiveTmp;
    //reg ModeTmp;

    //Variables to memory CurrentState
    wire CurrentS0;
    wire CurrentS1;
    wire CurrentS2;

    //Variabes to memory NextState
    wire NextS0;
    wire NextS1;
    wire NextS2;


    assign NextS2 = CurrentS1 & (!InputKey & ValidCmd & !CurrentS2 & CurrentS0 | CurrentS2 & !CurrentS0) | 
                    CurrentS2 & !CurrentS1 & (CurrentS0 | ValidCmd); 

    assign NextS1 = ValidCmd & !CurrentS1 & 
                    (!InputKey & !CurrentS2 & CurrentS0 | InputKey & CurrentS2 & !CurrentS0) |
                    CurrentS1 & !CurrentS0 & 
                    (InputKey & ValidCmd | CurrentS2);

    assign NextS0 = InputKey & ValidCmd & !CurrentS2 & !CurrentS0 | 
                    CurrentS2 & !CurrentS1  & (CurrentS0 | !InputKey & ValidCmd);

    //2. Memory Current State using D-FlipFlop
    DFlipFlop DFlipFlop_CurrentS0(.Clk(Clk),
                                  .Reset(Reset),
                                  .D(NextS0),
                                  .Out(CurrentS0));
    
    DFlipFlop DFlipFlop_CurrentS1(.Clk(Clk),
                                  .Reset(Reset),
                                  .D(NextS1),
                                  .Out(CurrentS1));

    DFlipFlop DFlipFlop_CurrentS2(.Clk(Clk),
                                  .Reset(Reset),
                                  .D(NextS2),
                                  .Out(CurrentS2));


    //3. Generate Output Signals
    assign Mode = CurrentS2 & CurrentS1 & !CurrentS0;

    assign Active = (CurrentS2 & CurrentS1 & !CurrentS0) |
                    (CurrentS2 & !CurrentS1 & CurrentS0);


endmodule