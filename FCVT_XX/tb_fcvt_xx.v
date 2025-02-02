`timescale 1ns / 1ps


module tb_fcvt_xx;

// Inputs
reg [31:0] a_i;
reg op_signed_i;
reg conv_type_i;

// Outputs
wire [31:0] result;

	// Instantiate the Unit Under Test (UUT)
	fcvt_xx uut (
		.a_i(a_i), 
		.op_signed_i(op_signed_i), 
		.conv_type_i(conv_type_i), 
		.result(result)
	);

integer file, r;
reg [31:0] expected_result;
reg [1023:0] line;
reg [31:0] error_count;

initial begin
    // Initialize Inputs
    a_i = 0;
    op_signed_i = 0;
    conv_type_i = 0;
    error_count = 0;

    // Open the file



    file = $fopen("C:/Users/canbo/Work Items/TEKNOFEST/fpu/fpu.srcs/sim_1/new/test_vectors.txt", "r");
    if (file == 0) begin
        $display("Failed to open file");
        $stop;
    end

    // Read the file line by line
    while (!$feof(file)) begin
        r = $fgets(line, file);
        if (r) begin
            r = $sscanf(line, "%h,%b,%b,%h", a_i, op_signed_i, conv_type_i, expected_result);
            if (r == 4) begin
                #10; // Wait for the operation to complete
                if (result !== expected_result) begin
                    $display("ERROR: a_i = %h, op_signed_i = %b, conv_type_i = %b, expected = %h, got = %h", 
                             a_i, op_signed_i, conv_type_i, expected_result, result);
                    error_count = error_count + 1;
                end else begin
                    $display("PASSED: a_i = %h, op_signed_i = %b, conv_type_i = %b, result = %h", 
                             a_i, op_signed_i, conv_type_i, result);
                end
            end
        end
    end

    // Close the file
    $fclose(file);

    $display("Test completed with %d errors", error_count);
    $stop;
end

endmodule
