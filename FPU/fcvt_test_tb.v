`timescale 1ns / 1ps
module fcvt_test_tb;

// Inputs
reg [31:0] a_i;
reg op_signed_i;
reg conv_type_i;

// Outputs
wire [31:0] result;

// Instantiate the Unit Under Test (UUT)
fcvt_test uut (
    .a_i(a_i), 
    .op_signed_i(op_signed_i), 
    .conv_type_i(conv_type_i), 
    .result(result)
);

initial begin
    // Initialize Inputs
    a_i = 0;
    op_signed_i = 0;
    conv_type_i = 0;

    // Apply Test Vectors
    // Test float to int (unsigned)
    a_i = 32'h4048F5C3; // float 3.14
    op_signed_i = 0;
    conv_type_i = 0;
    #10;
    $display("Float to Unsigned Int: a_i = %h, result = %h", a_i, result);

    // Test float to int (signed)
    a_i = 32'hC048F5C3; // float -3.14
    op_signed_i = 1;
    conv_type_i = 0;
    #10;
    $display("Float to Signed Int: a_i = %h, result = %h", a_i, result);

    // Test int to float (unsigned)
    a_i = 32'h00000064; // int 100
    op_signed_i = 0;
    conv_type_i = 1;
    #10;
    $display("Unsigned Int to Float: a_i = %h, result = %h", a_i, result);

    // Test int to float (signed positive)
    a_i = 32'h00000064; // int 100
    op_signed_i = 1;
    conv_type_i = 1;
    #10;
    $display("Signed Int to Float (positive): a_i = %h, result = %h", a_i, result);

    // Test int to float (signed negative)
    a_i = 32'hFFFFFF9C; // int -100
    op_signed_i = 1;
    conv_type_i = 1;
    #10;
    op_signed_i = 0;
    conv_type_i = 1;
    #10;
    op_signed_i = 1;
    conv_type_i = 0;
    #10;
    op_signed_i = 0;
    conv_type_i = 0;
    #10;
    $display("Signed Int to Float (negative): a_i = %h, result = %h", a_i, result);

    // Test edge cases
    // Small float to int
    a_i = 32'h3E800000; // float 0.25
    op_signed_i = 0;
    conv_type_i = 0;
    #10;
    $display("Small Float to Int: a_i = %h, result = %h", a_i, result);

    // Large float to int (overflow)
    a_i = 32'h7F800000; // float infinity
    op_signed_i = 0;
    conv_type_i = 0;
    #10;
    $display("Large Float to Int (overflow): a_i = %h, result = %h", a_i, result);

    // Small int to float
    a_i = 32'h00000001; // int 1
    op_signed_i = 0;
    conv_type_i = 1;
    #10;
    $display("Small Int to Float: a_i = %h, result = %h", a_i, result);

    // Negative float to unsigned int (should be 0)
    a_i = 32'hBF800000; // float -1.0
    op_signed_i = 0;
    conv_type_i = 0;
    #10;
    $display("Negative Float to Unsigned Int: a_i = %h, result = %h", a_i, result);

    $stop;
end

endmodule
