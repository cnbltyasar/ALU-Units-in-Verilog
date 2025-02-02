`timescale 1ns / 1ps
 

module ALU(

    input [31:0] rs1_data_i,

    input [31:0] rs2_data_i,

    input [7:0] alu_cmd,

    output  [31:0] rd_data_o,

    output  zero_o

);

 

    // ---- SINGLE CYCLE ------------

    reg [31:0] single_cycle_data_out;

 

    // ------------------------------ R-Types Operations Reg Definitions ---------------------------------------

    wire [31:0] fsgnj_s_o;

    wire [31:0] fsgnjn_s_o;

    wire [31:0] fsgnjx_s_o;

    wire [9:0] fclass_o;

 

    wire [31:0] fcvt_w_s_o,fcvt_o;

    wire [31:0] fcvt_wu_s_o;

    wire [31:0] fcvt_s_w_o;

    wire [31:0] fcvt_s_wu_o;

 

    // --- Function Port definitions

    // Instantiate R-Type Operations

    reg [1:0] op_type;

    fclass_s fclass_instance0 (.rs1(rs1_data_i), .rd(fclass_o));

    fsgnj_x fsgnj_x (.rs1(rs1_data_i), .rs2(rs2_data_i), .op_type(op_type), .rd(fsgnj_s_o));

    /*

    fsgnj_x fsgnj_s (.rs1(rs1_data_i), .rs2(rs2_data_i), .op_type(2'b00), .rd(fsgnj_s_o));

    fsgnj_x fsgnjn_s (.rs1(rs1_data_i), .rs2(rs2_data_i), .op_type(2'b01), .rd(fsgnjn_s_o));

    fsgnj_x fsgnjx_s (.rs1(rs1_data_i), .rs2(rs2_data_i), .op_type(2'b10), .rd(fsgnjx_s_o));

    */

    reg  op_signed_cvt,conv_type_cvt;

    fcvt_xx fcvt_w_s0 (.a_i(rs1_data_i), .op_signed_i(op_signed_cvt), .conv_type_i(conv_type_cvt), .result(fcvt_o));

   

    // FLOAT TO INTEGER: FCVT.W.S and FCVT.WU.S

    /*

    fcvt_xx fcvt_w_s0 (.a_i(rs1_data_i), .op_signed_i(1'b1), .conv_type_i(1'b0), .result(fcvt_w_s_o));

    fcvt_xx fcvt_wu_s1 (.a_i(rs1_data_i), .op_signed_i(1'b0), .conv_type_i(1'b0), .result(fcvt_wu_s_o));

    // INTEGER TO FLOAT: FCVT.S.W and FCVT.S.WU

    fcvt_xx fcvt_s_w2 (.a_i(rs1_data_i), .op_signed_i(1'b1), .conv_type_i(1'b1), .result(fcvt_s_w_o));

    fcvt_xx fcvt_s_wu3 (.a_i(rs1_data_i), .op_signed_i(1'b0), .conv_type_i(1'b1), .result(fcvt_s_wu_o));

    */

    assign rd_data_o = single_cycle_data_out; // Drive the output register here

    assign zero_o = (rd_data_o == 32'h0); // Set zero_o based on rd_data_o

    // Single Cycle Operations

    always @ (alu_cmd, rs1_data_i, rs2_data_i,fsgnj_s_o,fcvt_o,fclass_o) begin

        // Initialize the outputs to 0 by default

        //single_cycle_data_out = 32'h0;

       

        if (alu_cmd == 7'd1) begin

            single_cycle_data_out = rs1_data_i + rs2_data_i;

        end else if (alu_cmd == 7'd2 || alu_cmd == 8'd3) begin

            single_cycle_data_out = rs1_data_i;

        end else if (alu_cmd == 7'd74) begin

            single_cycle_data_out = fsgnj_s_o; //FSGNJ_S Module

            op_type  = 2'b0;

        end else if (alu_cmd == 7'd75) begin

            single_cycle_data_out = fsgnj_s_o; //FSGNJN_S Module

            op_type  = 2'b01;

        end else if (alu_cmd == 7'd76) begin

            single_cycle_data_out = fsgnj_s_o; //FSGNJX_S Module

            op_type  = 2'b10;

        end else if (alu_cmd == 7'd79) begin

            single_cycle_data_out = fcvt_o; //FCVT_W_S Module

            op_signed_cvt = 1;

            conv_type_cvt = 0;

        end else if (alu_cmd == 7'd80) begin

            single_cycle_data_out = fcvt_o; //FCVT_WU_S Module

            op_signed_cvt = 0;

            conv_type_cvt = 0;

        end else if (alu_cmd == 7'd86) begin

            single_cycle_data_out = fcvt_o; //FCVT_S_W Module

            op_signed_cvt = 1;

            conv_type_cvt = 1;

        end else if (alu_cmd == 7'd87) begin

            single_cycle_data_out = fcvt_o; //FCVT_S_WU Module

            op_signed_cvt = 0;

            conv_type_cvt = 1;

        end else if (alu_cmd == 7'd85) begin

            single_cycle_data_out = {22'b0, fclass_o}; //FCLASS Module

        end

        else begin

            single_cycle_data_out = 0;

        end

       

    end

endmodule