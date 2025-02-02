`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2024 20:14:36
// Design Name: 
// Module Name: tb_fclass_s
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_fclass_s;

    // Inputs
    reg [31:0] rs1;

    // Outputs
    wire [9:0] rd;

    // Instantiate the Unit Under Test (UUT)
    fclass_s uut (
        .rs1(rs1), 
        .rd(rd)
    );

    initial begin
        // Initialize Inputs
        rs1 = 32'b0;

        // Wait for global reset to finish
        #10;
        
        // Test Cases
        // Test for Quiet NaN
        rs1 = 32'b01111111110000000000000000000001; // Quiet NaN
        #10;
        $display("Quiet NaN: rd = %b", rd);

        // Test for Signaling NaN
        rs1 = 32'b01111111100000000000000000000001; // Signaling NaN
        #10;
        $display("Signaling NaN: rd = %b", rd);

        // Test for Positive Infinity
        rs1 = 32'b01111111100000000000000000000000; // Positive Infinity
        #10;
        $display("Positive Infinity: rd = %b", rd);

        // Test for Negative Infinity
        rs1 = 32'b11111111100000000000000000000000; // Negative Infinity
        #10;
        $display("Negative Infinity: rd = %b", rd);

        // Test for Positive Zero
        rs1 = 32'b00000000000000000000000000000000; // Positive Zero
        #10;
        $display("Positive Zero: rd = %b", rd);

        // Test for Negative Zero
        rs1 = 32'b10000000000000000000000000000000; // Negative Zero
        #10;
        $display("Negative Zero: rd = %b", rd);

        // Test for Positive Subnormal
        rs1 = 32'b00000000000000000000000000000001; // Positive Subnormal
        #10;
        $display("Positive Subnormal: rd = %b", rd);

        // Test for Negative Subnormal
        rs1 = 32'b10000000000000000000000000000001; // Negative Subnormal
        #10;
        $display("Negative Subnormal: rd = %b", rd);

        // Test for Positive Normal
        rs1 = 32'b00111111100000000000000000000000; // Positive Normal
        #10;
        $display("Positive Normal: rd = %b", rd);

        // Test for Negative Normal
        rs1 = 32'b10111111100000000000000000000000; // Negative Normal
        #10;
        $display("Negative Normal: rd = %b", rd);

        // Add additional test cases as needed
    end
      
endmodule
