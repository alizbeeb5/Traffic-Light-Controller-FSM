//mod 60 counter depends on cycles not real seconds. 

module timing_counter (input CK, output SW);

    reg [5:0] count = 6'd0;         

    always @(posedge CK) begin
        if (count == 6'd59)
            count <= 6'd0;
        else
            count <= count + 6'd1;
    end

    assign SW = (count >= 6'd50);   

endmodule
