`timescale 1ns / 1ps

module fsgnj_x_tb();

    // Testbench variables
    reg [31:0] rs1;
    reg [31:0] rs2;
    reg [1:0] op_type;
    wire [31:0] rd;

    // Instantiate the fsgnj_x module
    fsgnj_x uut (
        .rs1(rs1),
        .rs2(rs2),
        .op_type(op_type),
        .rd(rd)
    );

    initial begin
        // Initialize inputs
        rs1 = 32'h3F800000; // 1.0 (positive)
        rs2 = 32'hBF800000; // -1.0 (negative)
        op_type = 2'b00;
        
        // Apply test cases
        #10;
        $display("Test case 1: fsgnj.s");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);

        op_type = 2'b01;
        #10;
        $display("Test case 2: fsgnjn.s");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);

        op_type = 2'b10;
        #10;
        $display("Test case 3: fsgnjx.s");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);

        op_type = 2'b11;
        #10;
        $display("Test case 4: Default case");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);

        // Initialize inputs
        rs1 = 32'hfF800900; // 1.0 (positive)
        rs2 = 32'hf2802110; // -1.0 (negative)
        op_type = 2'b00;
        
        // Apply test cases
        #10;
        $display("Test case 1: fsgnj.s");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);

        op_type = 2'b01;
        #10;
        $display("Test case 2: fsgnjn.s");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);

        op_type = 2'b10;
        #10;
        $display("Test case 3: fsgnjx.s");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);

        op_type = 2'b11;
        #10;
        $display("Test case 4: Default case");
        $display("rs1 = %h, rs2 = %h, op_type = %b, rd = %h", rs1, rs2, op_type, rd);



        $stop;
    end

endmodule
