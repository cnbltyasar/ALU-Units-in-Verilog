`timescale 1ns / 1ps

module ALU_tb;

    // Testbench signals
    reg [31:0] rs1_data_i;
    reg [31:0] rs2_data_i;
    reg [7:0]  alu_cmd;
    wire [31:0] rd_data_o;
    wire zero_o;

    // Instantiate the ALU module
    ALU uut (
        .rs1_data_i(rs1_data_i),
        .rs2_data_i(rs2_data_i),
        .alu_cmd(alu_cmd),
        .rd_data_o(rd_data_o),
        .zero_o(zero_o)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        rs1_data_i = 0;
        rs2_data_i = 0;
        alu_cmd = 0;

        // Wait for global reset
        #10;

        // Test cases
        // Test case for signed addition
        rs1_data_i = 32'h0000_0005;
        rs2_data_i = 32'h0000_0003;
        alu_cmd = 7'd1; // ALU operation: Addition
        #10;
        $display("Test case 1: ALU_cmd = %d, rs1_data_i = %h, rs2_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rs2_data_i, rd_data_o, zero_o);
        
        // Test case for signed comparison (L)
        rs1_data_i = 32'h0000_0001;
        rs2_data_i = 32'h0000_0002;
        alu_cmd = 7'd2; // ALU operation: Signed comparison
        #10;
        $display("Test case 2: ALU_cmd = %d, rs1_data_i = %h, rs2_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rs2_data_i, rd_data_o, zero_o);

        // Test case for FSGNJ_S operation
        rs1_data_i = 32'h3f800000; // 1.0 in IEEE 754 float
        rs2_data_i = 32'hbf800000; // -1.0 in IEEE 754 float
        alu_cmd = 7'd74; // ALU operation: FSGNJ_S
        #10;
        $display("Test case 4: ALU_cmd = %d, rs1_data_i = %h, rs2_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rs2_data_i, rd_data_o, zero_o);

        // Test case for FSGNJNS operation
        rs1_data_i = 32'h3f800000; // 1.0 in IEEE 754 float
        rs2_data_i = 32'hbf800000; // -1.0 in IEEE 754 float
        alu_cmd = 7'd75; // ALU operation: FSGNJN_S
        #10;
        $display("Test case 5: ALU_cmd = %d, rs1_data_i = %h, rs2_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rs2_data_i, rd_data_o, zero_o);

        // Test case for FSGNJX operation
        rs1_data_i = 32'h3f800000; // 1.0 in IEEE 754 float
        rs2_data_i = 32'hbf800000; // -1.0 in IEEE 754 float
        alu_cmd = 7'd76; // ALU operation: FSGNJX_S
        #10;
        $display("Test case 6: ALU_cmd = %d, rs1_data_i = %h, rs2_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rs2_data_i, rd_data_o, zero_o);

        // Test case for FCVT_W_S operation
        rs1_data_i = 32'h3f800000; // 1.0 in IEEE 754 float
        alu_cmd = 7'd79; // ALU operation: FCVT_W_S
        #10;
        $display("Test case 7: ALU_cmd = %d, rs1_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rd_data_o, zero_o);

        // Test case for FCVT_WU_S operation
        rs1_data_i = 32'h3f800000; // 1.0 in IEEE 754 float
        alu_cmd = 7'd80; // ALU operation: FCVT_WU_S
        #10;
        $display("Test case 8: ALU_cmd = %d, rs1_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rd_data_o, zero_o);

        // Test case for FCVT_S_W operation
        rs1_data_i = 32'h0000_0003; // 3 in integer
        alu_cmd = 7'd86; // ALU operation: FCVT_S_W
        #10;
        $display("Test case 9: ALU_cmd = %d, rs1_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rd_data_o, zero_o);

        // Test case for FCVT_S_WU operation
        rs1_data_i = 32'h0000_0003; // 3 in integer
        alu_cmd = 7'd87; // ALU operation: FCVT_S_WU
        #10;
        $display("Test case 10: ALU_cmd = %d, rs1_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rd_data_o, zero_o);

        // Test case for FCLASS operation
        rs1_data_i = 32'h3f800000; // 1.0 in IEEE 754 float
        alu_cmd = 7'd85; // ALU operation: FCLASS
        #10;
        $display("Test case 11: ALU_cmd = %d, rs1_data_i = %h, rd_data_o = %h, zero_o = %b", alu_cmd, rs1_data_i, rd_data_o, zero_o);

        // End simulation
        $finish;
    end

endmodule
