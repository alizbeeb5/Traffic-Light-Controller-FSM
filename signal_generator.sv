module signal_generator (input CK, input SW, input SENSOR,
                         output NSRED, output NSYEL, output NSGRN,
                         output EWRED, output EWYEL, output EWGRN);

    localparam [2:0] NSG0 = 3'd0,   // NS green when sw is low
                     NSG1 = 3'd1,   // NS green stalled
                     NSY  = 3'd2,   // NS yellow
                     EWG  = 3'd3,   // EW green
                     EWY  = 3'd4;   // EW yellow

    reg [2:0] state = NSG0;
    reg [2:0] next_state;

    // next state login
    always @(*) begin
        case (state)
            NSG0:    next_state = (SW == 1'b0) ? NSG0 :
                                  (SENSOR)     ? NSY  : NSG1;
            NSG1:    next_state = (SW == 1'b1) ? NSG1 : NSG0;
            NSY :    next_state = (SW == 1'b1) ? NSY  : EWG;
            EWG :    next_state = (SW == 1'b0) ? EWG  : EWY;
            EWY :    next_state = (SW == 1'b1) ? EWY  : NSG0;
            default: next_state = NSG0;
        endcase
    end

    // state register controls all flip flops with the same clock
    always @(posedge CK)
        state <= next_state;

    
    assign NSGRN = (state == NSG0) | (state == NSG1);
    assign NSYEL = (state == NSY);
    assign NSRED = (state == EWG)  | (state == EWY);

    assign EWGRN = (state == EWG);
    assign EWYEL = (state == EWY);
    assign EWRED = (state == NSG0) | (state == NSG1) | (state == NSY);

endmodule
