`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
module ALU_single_cycle(
        input [31:0] rs1_data_i,
        input [31:0] rs2_data_i,
        input [6:0] alu_cmd,
        input [2:0]zero_cmd,
        output [31:0] rd_data_o,
        output reg zero_o  ///branch ???
    );
	

    reg [31:0] rv32_IF_basic_out;
    reg [31:0] rv32_B_basic_out;
    assign rd_data_o = alu_cmd[6] ? rv32_B_basic_out : rv32_IF_basic_out;
	
	    // ------------------------------ R-Types Operations Reg Definitions ---------------------------------------
    wire [31:0] fsgnj_s_o;
    wire [9:0] fclass_o;
    wire [31:0] fcvt_o;
	wire [31:0] f_min_max_res;
	

    // Instantiate R-Type Operations
    reg [1:0] op_type;
	reg [1:0] comparision_type;

	

    fclass_s fclass_instance0 (.rs1(rs1_data_i), .rd(fclass_o));
    fsgnj_x fsgnj_x (.rs1(rs1_data_i), .rs2(rs2_data_i), .op_type(op_type), .rd(fsgnj_s_o));
	
    reg  op_signed_cvt,conv_type_cvt;
	
    fcvt_xx fcvt_w_s0 (.a_i(rs1_data_i), .op_signed_i(op_signed_cvt), .conv_type_i(conv_type_cvt), .result(fcvt_o));
	
	f_min_max f_min_max_func(.rs1(rs1_data_i),.rs2(rs2_data_i),.func_type(comparision_type),.rd(f_min_max_res));


    ///---------------- COMPARISON -----------
    reg [32:0] comp_res;
    wire comparison_op_flag = ((alu_cmd == 2)  || (alu_cmd == 3) || (alu_cmd == 71) || (alu_cmd == 73) || (alu_cmd == 72) ||(alu_cmd == 74) );
    wire E = comparison_op_flag & (rs1_data_i == rs2_data_i);
    wire L = comparison_op_flag & (~comp_res[32]) & (~E);
    wire G = comparison_op_flag & ((comp_res[32])& (~E));
	
	
	
	
	
    always@ (alu_cmd,rs1_data_i,rs2_data_i) begin
        if ((alu_cmd == 2) || (alu_cmd == 71) || (alu_cmd == 73)) begin /// signed comparison , 71 ve 73 MAX ve MIN 
            comp_res = {rs1_data_i[31] ,rs1_data_i} - {rs2_data_i[31] ,rs2_data_i};
        end
        else if ( (alu_cmd == 3) ||(alu_cmd == 72) ||(alu_cmd == 74) ) begin /// unsigned comparison
            comp_res = {1'b0 ,rs1_data_i} - {1'b0 ,rs2_data_i};
        end 
        else begin  
            comp_res=0;
        end
    end
    
    //// ---------- ZERO CALCULATION --------------
    always@ (zero_cmd,E,G,L) begin
        case (zero_cmd) 
            3'b001: begin zero_o = E; end           // BEQ                 
            3'b010: begin zero_o = ~E; end          // BNE  
            3'b011: begin zero_o = L; end           // BLT
            3'b100: begin zero_o = G | E; end       // BGE 
            default : begin zero_o = 0; end
        endcase
    end
    
    /// ------------    SINGLE CYCLE    ------------
    ///---------------------------------------------
    always@ (alu_cmd,rs1_data_i,rs2_data_i, fsgnj_s_o, fclass_o, fcvt_o, f_min_max_res) begin
        if(alu_cmd == 7'd1)begin
            rv32_IF_basic_out = rs1_data_i + rs2_data_i;    //int add
        end
        else if((alu_cmd == 7'd2) || (alu_cmd == 7'd3))begin
            rv32_IF_basic_out = L ? 31'h0000_0001 : 32'h0;  //comparison (SLT, SLTU)
        end
        else if (alu_cmd == 7'd4) begin
            rv32_IF_basic_out = rs1_data_i ^ rs2_data_i;    //xor
        end
        else if (alu_cmd == 7'd5) begin
            rv32_IF_basic_out = rs1_data_i | rs2_data_i;    //or
        end
        else if (alu_cmd == 7'd6) begin
            rv32_IF_basic_out = rs1_data_i & rs2_data_i;    //and
        end
        else if (alu_cmd == 7'd7) begin
            rv32_IF_basic_out = rs1_data_i << rs2_data_i[4:0]; //logic shift left
        end
        else if (alu_cmd == 7'd8) begin
            rv32_IF_basic_out = rs1_data_i >> rs2_data_i[4:0]; //logic shift right
        end
        else if (alu_cmd == 7'd9) begin
            rv32_IF_basic_out = ($signed(rs1_data_i) >>> rs2_data_i[4:0]) ; //arith shift right
        end
        else if (alu_cmd == 7'd10) begin
            rv32_IF_basic_out = rs1_data_i - rs2_data_i;    //subtraction
        end
		
        ///------------- alu_cmd 19 - 32 F type--------
	
		else if (alu_cmd == 7'd24) begin
		
            rv32_IF_basic_out = fsgnj_s_o; //FSGNJ_S Module
            op_type  = 2'b0;
			
        end
		else if (alu_cmd == 7'd25) begin
		
            rv32_IF_basic_out = fsgnj_s_o; //FSGNJN_S Module
            op_type  = 2'b01;
			
        end
		else if (alu_cmd == 7'd26) begin
		
            rv32_IF_basic_out = fsgnj_s_o; //FSGNJX_S Module
            op_type  = 2'b10;
			
        end
		else if (alu_cmd == 7'd27) begin

            rv32_IF_basic_out = fcvt_o; //FCVT_W_S Module  FLOAT TO INTEGER: FCVT.W.S ve FCVT.WU.S
            op_signed_cvt = 1;
            conv_type_cvt = 0;

        end
		else if (alu_cmd == 7'd28) begin

            rv32_IF_basic_out = fcvt_o; //FCVT_WU_S Module
            op_signed_cvt = 0;
            conv_type_cvt = 0;

        end
		else if (alu_cmd == 7'd29) begin

            rv32_IF_basic_out = {22'b0, fclass_o}; //FCLASS Module || Float Class

        end
		
		else if (alu_cmd == 7'd30) begin

            rv32_IF_basic_out = fcvt_o; //FCVT_S_W Module      INTEGER TO FLOAT: FCVT.S.W ve FCVT.S.WU
            op_signed_cvt = 1;
            conv_type_cvt = 1;

        end
		else if (alu_cmd == 7'd31) begin

            rv32_IF_basic_out = fcvt_o; //FCVT_S_WU Module
            op_signed_cvt = 0;
            conv_type_cvt = 1;

        end
		else if (alu_cmd == 7'd32) begin

            rv32_IF_basic_out = f_min_max_res; //F_MAX
			comparision_type = 2'b00 ;

        end
		else if (alu_cmd == 7'd33) begin

            rv32_IF_basic_out = f_min_max_res; //F_MIN
			comparision_type = 2'b01;

        end
		else if (alu_cmd == 7'd34) begin //F_EQ
        // Check if either input is NaN
			if ((rs1_data_i[30:23] == 8'hFF) & (rs1_data_i[22:0] != 0) || (rs2_data_i[30:23] == 8'hFF) & (rs2_data_i[22:0] != 0)) begin
				rv32_IF_basic_out = 32'd0;
			end else begin
				// Perform quiet equal comparison
				if (rs1_data_i == rs2_data_i) begin
						rv32_IF_basic_out = 32'd1;
				end else begin
						rv32_IF_basic_out = 32'd0;
				end
			end
			
        end
		else if (alu_cmd == 7'd35) begin //F_LT
			
			rv32_IF_basic_out = f_min_max_res; 
			comparision_type = 2'b10;
		
        end
		else if (alu_cmd == 7'd36) begin //F_LEQ
			rv32_IF_basic_out = f_min_max_res; 
			comparision_type = 2'b11;
        end

        ///--------------------------------------------
        else begin
            rv32_IF_basic_out = 32'b0;
        end
        
    end
        
    ///-----------------B-TYPE----------------------
    integer i;   
    ///---------------------------------------------
    always @(alu_cmd,rs1_data_i,rs2_data_i) begin
	
        if (alu_cmd == 7'd64) begin
            rv32_B_basic_out = rs1_data_i &~rs2_data_i; //and_not
        end
        else if (alu_cmd == 7'd65) begin   
            for (i = 0; i < 32; i = i+1) begin          //clmul
                if ((rs2_data_i >> i) & 1) begin
                    rv32_B_basic_out = rv32_B_basic_out ^ (rs1_data_i << i);
                end
            end 
        end 
        else if (alu_cmd == 7'd66) begin
            for (i = 1; i < 32; i = i+1 ) begin         //clmulh
                if ((rs2_data_i >> i) & 1) begin
                    rv32_B_basic_out = rv32_B_basic_out ^ (rs1_data_i >> (31-i));
                end
            end
        end
        else if (alu_cmd == 7'd67) begin
            for (i = 0; i < 31; i = i+1) begin
                if ((rs2_data_i >> i) & 1) begin        //clmulr
                    rv32_B_basic_out = rv32_B_basic_out ^ (rs1_data_i >> 30-i);
                end
            end
        end
        else if (alu_cmd == 7'd68) begin
            casex (rs1_data_i)                          //clz
            32'b00000000000000000000000000000001: rv32_B_basic_out = 5'd31;
            32'b0000000000000000000000000000001x: rv32_B_basic_out = 5'd30;
            32'b000000000000000000000000000001xx: rv32_B_basic_out = 5'd29;
            32'b00000000000000000000000000001xxx: rv32_B_basic_out = 5'd28;
            32'b0000000000000000000000000001xxxx: rv32_B_basic_out = 5'd27;
            32'b000000000000000000000000001xxxxx: rv32_B_basic_out = 5'd26;
            32'b00000000000000000000000001xxxxxx: rv32_B_basic_out = 5'd25;
            32'b0000000000000000000000001xxxxxxx: rv32_B_basic_out = 5'd24;
            32'b000000000000000000000001xxxxxxxx: rv32_B_basic_out = 5'd23;
            32'b00000000000000000000001xxxxxxxxx: rv32_B_basic_out = 5'd22;
            32'b0000000000000000000001xxxxxxxxxx: rv32_B_basic_out = 5'd21;
            32'b000000000000000000001xxxxxxxxxxx: rv32_B_basic_out = 5'd20;
            32'b00000000000000000001xxxxxxxxxxxx: rv32_B_basic_out = 5'd19;
            32'b0000000000000000001xxxxxxxxxxxxx: rv32_B_basic_out = 5'd18;
            32'b000000000000000001xxxxxxxxxxxxxx: rv32_B_basic_out = 5'd17;
            32'b00000000000000001xxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd16;
            32'b0000000000000001xxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd15;
            32'b000000000000001xxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd14;
            32'b00000000000001xxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd13;
            32'b0000000000001xxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd12;
            32'b000000000001xxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd11;
            32'b00000000001xxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd10;
            32'b0000000001xxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd9;
            32'b000000001xxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd8;
            32'b00000001xxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd7;
            32'b0000001xxxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd6;
            32'b000001xxxxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd5;
            32'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd4;
            32'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd3;
            32'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd2;
            32'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd1;
            32'b1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: rv32_B_basic_out = 5'd0;
            
            default: rv32_B_basic_out = 32; // If no bits are set, return 32
        endcase             
        end
        else if (alu_cmd == 7'd69) begin
            for (i = 0; i<32; i = i+1) begin        //cpop
                if (rs1_data_i[i] == 1'b1) begin
                    rv32_B_basic_out = rv32_B_basic_out+1;
                end
            end
        end
        else if (alu_cmd == 7'd70) begin
            casex (rs1_data_i)                      //ctz
            32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1: rv32_B_basic_out = 5'd0;
            32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10: rv32_B_basic_out = 5'd1;
            32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100: rv32_B_basic_out = 5'd2;
            32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000: rv32_B_basic_out = 5'd3;
            32'bxxxxxxxxxxxxxxxxxxxxxxxxxxx10000: rv32_B_basic_out = 5'd4;
            32'bxxxxxxxxxxxxxxxxxxxxxxxxxx100000: rv32_B_basic_out = 5'd5;
            32'bxxxxxxxxxxxxxxxxxxxxxxxxx1000000: rv32_B_basic_out = 5'd6;
            32'bxxxxxxxxxxxxxxxxxxxxxxxx10000000: rv32_B_basic_out = 5'd7;
            32'bxxxxxxxxxxxxxxxxxxxxxxx100000000: rv32_B_basic_out = 5'd8;
            32'bxxxxxxxxxxxxxxxxxxxxxx1000000000: rv32_B_basic_out = 5'd9;
            32'bxxxxxxxxxxxxxxxxxxxxx10000000000: rv32_B_basic_out = 5'd10;
            32'bxxxxxxxxxxxxxxxxxxxx100000000000: rv32_B_basic_out = 5'd11;
            32'bxxxxxxxxxxxxxxxxxxx1000000000000: rv32_B_basic_out = 5'd12;
            32'bxxxxxxxxxxxxxxxxxx10000000000000: rv32_B_basic_out = 5'd13;
            32'bxxxxxxxxxxxxxxxxx100000000000000: rv32_B_basic_out = 5'd14;
            32'bxxxxxxxxxxxxxxxx1000000000000000: rv32_B_basic_out = 5'd15;
            32'bxxxxxxxxxxxxxxx10000000000000000: rv32_B_basic_out = 5'd16;
            32'bxxxxxxxxxxxxxx100000000000000000: rv32_B_basic_out = 5'd17;
            32'bxxxxxxxxxxxxx1000000000000000000: rv32_B_basic_out = 5'd18;
            32'bxxxxxxxxxxxx10000000000000000000: rv32_B_basic_out = 5'd19;
            32'bxxxxxxxxxxx100000000000000000000: rv32_B_basic_out = 5'd20;
            32'bxxxxxxxxxx1000000000000000000000: rv32_B_basic_out = 5'd21;
            32'bxxxxxxxxx10000000000000000000000: rv32_B_basic_out = 5'd22;
            32'bxxxxxxxx100000000000000000000000: rv32_B_basic_out = 5'd23;
            32'bxxxxxxx1000000000000000000000000: rv32_B_basic_out = 5'd24;
            32'bxxxxxx10000000000000000000000000: rv32_B_basic_out = 5'd25;
            32'bxxxxx100000000000000000000000000: rv32_B_basic_out = 5'd26;
            32'bxxxx1000000000000000000000000000: rv32_B_basic_out = 5'd27;
            32'bxxx10000000000000000000000000000: rv32_B_basic_out = 5'd28;
            32'bxx100000000000000000000000000000: rv32_B_basic_out = 5'd29;
            32'bx1000000000000000000000000000000: rv32_B_basic_out = 5'd30;
            32'b10000000000000000000000000000000: rv32_B_basic_out = 5'd31;
            
            default: rv32_B_basic_out = 32; // If no bits are set, return 32
            endcase
        end
        else if (alu_cmd == 7'd71 || alu_cmd == 7'd72) begin
            rv32_B_basic_out = L ? rs2_data_i : rs1_data_i; //max,maxu
        end
        else if (alu_cmd == 7'd73 || alu_cmd == 7'd74) begin
            rv32_B_basic_out = L ? rs1_data_i : rs2_data_i; //min,minu
        end
        else if (alu_cmd == 7'd75) begin
            for (i = 0; i<32; i = i+8)begin     //orc.b
                rv32_B_basic_out [i +: 8] = {8{|(rs1_data_i[i +: 8])}};    
            end
        end
        else if (alu_cmd == 7'd76) begin    //or not
            rv32_B_basic_out = rs1_data_i |~rs2_data_i;
        end
        else if (alu_cmd == 7'd77) begin    //rev8
            for (i = 0; i<32; i=i+8 ) begin
                rv32_B_basic_out [i +: 8] = rs1_data_i [32-8-i +: 8];
            end
        end
        else if (alu_cmd == 7'd78) begin    //rotate_left 
            rv32_B_basic_out = (rs1_data_i << rs2_data_i[4:0]) | (rs1_data_i >> (32-rs2_data_i[4:0]));
        end
        else if (alu_cmd == 7'd79) begin //rotate_right, rotate_right_imm
            rv32_B_basic_out = (rs1_data_i >> rs2_data_i[4:0]) | (rs1_data_i << (32-rs2_data_i[4:0]));
        end
        else if (alu_cmd == 7'd80) begin    //bclr,bclri
            rv32_B_basic_out = rs1_data_i & ( ~(31'd1 << rs2_data_i[4:0])); 
        end
        else if (alu_cmd == 7'd81) begin    //bext, bexti
            rv32_B_basic_out = (rs1_data_i >> rs2_data_i[4:0]) & 31'd1;
        end
        else if (alu_cmd == 7'd82) begin //binv, binvi
            rv32_B_basic_out = rs1_data_i ^ (31'd1 << rs2_data_i[4:0]);
        end
        else if (alu_cmd == 7'd83) begin    //bset, bseti
            rv32_B_basic_out = rs1_data_i | (31'd1 << rs2_data_i[4:0]);
        end
        else if (alu_cmd == 7'd84) begin    //sext.b
            rv32_B_basic_out = {{24{rs1_data_i[7]}},rs1_data_i[7:0]};
        end
        else if (alu_cmd == 7'd85) begin    //sext.h
            rv32_B_basic_out = {{16{rs1_data_i[15]}},rs1_data_i[15:0]};
        end
        else if (alu_cmd == 7'd86) begin    //sh1add
            rv32_B_basic_out = (rs1_data_i << 5'd1) + (rs2_data_i);
        end
        else if (alu_cmd == 7'd87) begin    //sh2add
            rv32_B_basic_out = (rs1_data_i << 5'd2) + (rs2_data_i);
        end
        else if (alu_cmd == 7'd88) begin    //sh3add
            rv32_B_basic_out = (rs1_data_i << 5'd3) + (rs2_data_i);
        end
        else if (alu_cmd == 7'd89) begin    //xnor
            rv32_B_basic_out = (~rs1_data_i) ^ (rs2_data_i);
        end
        else if (alu_cmd == 7'd90) begin    //zext.h
            rv32_B_basic_out = {{16{1'b0}},rs1_data_i[15:0]};
        end
        else begin
            rv32_B_basic_out = 0;
        end

    end
endmodule