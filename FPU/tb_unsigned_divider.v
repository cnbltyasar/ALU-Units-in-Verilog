`timescale 1ns / 1ps

module unsigned_divider_tb;

    // Parameters
    parameter XLEN = 32;
    parameter `N(XLEN) STAGE_LIST = 32'h00000000 		; // All stages are registered

    // Inputs
    reg clk;
    reg rst;
    reg `N(XLEN) a;
    reg `N(XLEN) b;
    reg vld;

    // Outputs
    wire `N(XLEN) quo;
    wire `N(XLEN) rem;
    wire ack;

    // Instantiate the Unit Under Test (UUT)
    unsigned_divider #(XLEN, STAGE_LIST) uut (
        .clk(clk), 
        .rst(rst), 
        .a(a), 
        .b(b), 
        .vld(vld), 
        .quo(quo), 
        .rem(rem), 
        .ack(ack)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test vector generation and checking
    initial begin
        // Initialize Inputs
        rst = 1;
        a = 0;
        b = 0;
        vld = 0;

        // Wait for global reset
        #10;
        rst = 0;
        
        // Test Case 1: a = 10, b = 2 (Expected quo = 5, rem = 0)
        a = 10;
        b = 2;
        vld = 1;
        #10;
        vld = 0;
        wait (ack);
        #10;
        $display("a=10, b=2 -> quo=%d, rem=%d", quo, rem);
        if (quo !== 5 || rem !== 0) $display("ERROR: Test Case 1 Failed!");

        // Test Case 2: a = 10, b = 3 (Expected quo = 3, rem = 1)
        a = 10;
        b = 3;
        vld = 1;
        #10;
        vld = 0;
        wait (ack);
        #10;
        $display("a=10, b=3 -> quo=%d, rem=%d", quo, rem);
        if (quo !== 3 || rem !== 1) $display("ERROR: Test Case 2 Failed!");

        // Test Case 3: a = 0, b = 5 (Expected quo = 0, rem = 0)
        a = 0;
        b = 5;
        vld = 1;
        #10;
        vld = 0;
        wait (ack);
        #10;
        $display("a=0, b=5 -> quo=%d, rem=%d", quo, rem);
        if (quo !== 0 || rem !== 0) $display("ERROR: Test Case 3 Failed!");

        // Test Case 4: a = 5, b = 1 (Expected quo = 5, rem = 0)
        a = 5;
        b = 1;
        vld = 1;
        #10;
        vld = 0;
        wait (ack);
        #10;
        $display("a=5, b=1 -> quo=%d, rem=%d", quo, rem);
        if (quo !== 5 || rem !== 0) $display("ERROR: Test Case 4 Failed!");

        // Test Case 5: a = 123456789, b = 12345 (Random case)
        a = 123456789;
        b = 12345;
        vld = 1;
        #10;
        vld = 0;
        wait (ack);
        #10;
        $display("a=123456789, b=12345 -> quo=%d, rem=%d", quo, rem);
        if (quo !== (123456789 / 12345) || rem !== (123456789 % 12345)) $display("ERROR: Test Case 5 Failed!");

        // Test Case 6: a = 1000000000, b = 3 (Expected quo = 333333333, rem = 1)
        a = 1000000000;
        b = 3;
        vld = 1;
        #10;
        vld = 0;
        wait (ack);
        #10;
        $display("a=1000000000, b=3 -> quo=%d, rem=%d", quo, rem);
        if (quo !== 333333333 || rem !== 1) $display("ERROR: Test Case 6 Failed!");

        // End of test
        $finish;
    end

endmodule
