`timescale 1ns / 1ps

module tb_ALU_single_cycle;

    // Inputs
    reg [31:0] rs1_data_i;
    reg [31:0] rs2_data_i;
    reg [6:0] alu_cmd;
    reg [2:0] zero_cmd;

    // Outputs
    wire [31:0] rd_data_o;
    wire zero_o;

    // Variables for file I/O
    integer file;
    integer r;
    reg [255:0] line;
    reg [31:0] expected_result;
    integer error_count;

    // Instantiate the ALU module
    ALU_single_cycle uut (
        .rs1_data_i(rs1_data_i), 
        .rs2_data_i(rs2_data_i), 
        .alu_cmd(alu_cmd), 
        .zero_cmd(zero_cmd), 
        .rd_data_o(rd_data_o), 
        .zero_o(zero_o)
    );

    initial begin
        // Initialize Inputs
        rs1_data_i = 0;
        rs2_data_i = 0;
        alu_cmd = 0;
        zero_cmd = 0;
        error_count = 0;

        // Open the test vectors file
        file = $fopen("C:/Users/canbo/Work Items/TEKNOFEST/fpu/fpu.srcs/sim_1/new/single_cycle_test.txt", "r");
        if (file == 0) begin
            $display("Failed to open file");
            $stop;
        end

        // Read the file line by line
        while (!$feof(file)) begin
            r = $fgets(line, file);
            if (r) begin
                r = $sscanf(line, "%h,%h,%d,%d,%h", rs1_data_i, rs2_data_i, alu_cmd, zero_cmd, expected_result);
                if (r == 5) begin
                    #10; // Wait for the operation to complete
                    if (rd_data_o !== expected_result) begin
                        $display("ERROR: rs1 = %h, rs2 = %h, alu_cmd = %d, zero_cmd = %d, expected = %h, got = %h", 
                                 rs1_data_i, rs2_data_i, alu_cmd, zero_cmd, expected_result, rd_data_o);
                        error_count = error_count + 1;
                    end else begin
                        $display("PASSED: rs1 = %h, rs2 = %h, alu_cmd = %d, zero_cmd = %d, result = %h", 
                                 rs1_data_i, rs2_data_i, alu_cmd, zero_cmd, rd_data_o);
                    end
                end
            end
        end

        // Close the file
        $fclose(file);

        $display("Test completed with %d errors", error_count);
        //$stop; // Stop simulation
    end
      
endmodule
