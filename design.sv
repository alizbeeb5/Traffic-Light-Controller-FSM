//top level connects counter with generator
`include "timing_counter.sv"
`include "signal_generator.sv"
module traffic_controller (input CK, input SENSOR,
                           output NSRED, output NSYEL, output NSGRN,
                           output EWRED, output EWYEL, output EWGRN,
                           output SW);

    timing_counter   U_CNT (.CK(CK), .SW(SW));

    signal_generator U_GEN (.CK(CK), .SW(SW), .SENSOR(SENSOR),
                            .NSRED(NSRED), .NSYEL(NSYEL), .NSGRN(NSGRN),
                            .EWRED(EWRED), .EWYEL(EWYEL), .EWGRN(EWGRN));

endmodule
