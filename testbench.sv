`timescale 1us / 1ns
module traffic_tb;

    reg  CK = 1'b0;
    reg  SENSOR = 1'b0;
    wire NSRED, NSYEL, NSGRN, EWRED, EWYEL, EWGRN, SW;

    
    traffic_controller UUT (.CK(CK), .SENSOR(SENSOR),
                            .NSRED(NSRED), .NSYEL(NSYEL), .NSGRN(NSGRN),
                            .EWRED(EWRED), .EWYEL(EWYEL), .EWGRN(EWGRN),
                            .SW(SW));

    
    always #5 CK = ~CK;

    //initialize colors
    wire [23:0] NS = NSGRN ? "GRN" : NSYEL ? "YEL" : NSRED ? "RED" : "???";
    wire [23:0] EW = EWGRN ? "GRN" : EWYEL ? "YEL" : EWRED ? "RED" : "???";

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, traffic_tb);
        $monitor("T=%0t SW=%b SEN=%b NS=%s EW=%s",
                  $time, SW, SENSOR, NS, EW);

        //no cars on eastwest
        repeat (130) @(posedge CK);

        // test 1
        wait (SW == 1'b0);
        repeat (20) @(posedge CK);
        SENSOR = 1'b1;
        $display("TEST 1: SENSOR asserted at T=%0t (SW=%b)", $time, SW);

    
        repeat (250) @(posedge CK);

        // drop the sensor
        wait (EWYEL == 1'b1);           // end of an EW 
        wait (NSGRN == 1'b1);           // NS green started
        repeat (2) @(posedge CK);
        SENSOR = 1'b0;
      $display("SENSOR deasserted at T=%0t; controller should stopl",
                  $time);
        repeat (130) @(posedge CK);     

        // test 2
        @(posedge SW);
        repeat (3) @(posedge CK);
        SENSOR = 1'b1;
        $display(" TEST 2: SENSOR asserted MID-PULSE at T=%0t (SW=%b)",
                  $time, SW);

        //ns green then yellow 
        repeat (200) @(posedge CK);

        $finish;
    end

endmodule
