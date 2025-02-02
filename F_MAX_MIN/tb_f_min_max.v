`timescale 1ns / 1ps

module tb_f_min_max;
    // Inputs
    reg [31:0] rs1;
    reg [31:0] rs2;
    reg [1:0] func_type;

    // Outputs
    wire [31:0] rd;

    // Instantiate the Unit Under Test (UUT)
    f_min_max uut (
        .rs1(rs1), 
        .rs2(rs2), 
        .func_type(func_type), 
        .rd(rd)
    );

    initial begin
        // Initialize Inputs
        rs1 = 32'h3f800000; // 1.0
        rs2 = 32'h40000000; // 2.0
        func_type = 2'b00;  // Fmax
        #10;
        $display("Fmax 1.0, 2.0: rd = %h (expected 40000000)", rd);
        
        func_type = 2'b01;  // Fmin
        #10;
        $display("Fmin 1.0, 2.0: rd = %h (expected 3f800000)", rd);
        
        rs1 = 32'hbf800000; // -1.0
        rs2 = 32'h40000000; // 2.0
        func_type = 2'b00;  // Fmax
        #10;
        $display("Fmax -1.0, 2.0: rd = %h (expected 40000000)", rd);
        
        func_type = 2'b01;  // Fmin
        #10;
        $display("Fmin -1.0, 2.0: rd = %h (expected bf800000)", rd);

        rs1 = 32'h7fc00000; // NaN
        rs2 = 32'h40000000; // 2.0
        func_type = 2'b00;  // Fmax
        #10;
        $display("Fmax NaN, 2.0: rd = %h (expected 40000000)", rd);
        
        func_type = 2'b01;  // Fmin
        #10;
        $display("Fmin NaN, 2.0: rd = %h (expected 40000000)", rd);

        rs1 = 32'h3f800000; // 1.0
        rs2 = 32'h7fc00000; // NaN
        func_type = 2'b00;  // Fmax
        #10;
        $display("Fmax 1.0, NaN: rd = %h (expected 3f800000)", rd);
        
        func_type = 2'b01;  // Fmin
        #10;
        $display("Fmin 1.0, NaN: rd = %h (expected 3f800000)", rd);

        // F_LT and F_LEQ
        rs1 = 32'h3f800000; // 1.0
        rs2 = 32'h40000000; // 2.0
        func_type = 2'b10;  // F_LT
        #10;
        $display("F_LT 1.0, 2.0: rd = %h (expected 1)", rd);

        func_type = 2'b11;  // F_LEQ
        #10;
        $display("F_LEQ 1.0, 2.0: rd = %h (expected 1)", rd);

        rs1 = 32'h40000000; // 2.0
        rs2 = 32'h3f800000; // 1.0
        func_type = 2'b10;  // F_LT
        #10;
        $display("F_LT 2.0, 1.0: rd = %h (expected 0)", rd);

        func_type = 2'b11;  // F_LEQ
        #10;
        $display("F_LEQ 2.0, 1.0: rd = %h (expected 0)", rd);

        $stop;
    end
endmodule
