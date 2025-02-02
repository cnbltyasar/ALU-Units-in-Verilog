`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module fcvt_test(
    input [31:0] a_i,
    input op_signed_i,
    input conv_type_i,
    output [31:0] result
);

    // Parameters for the IEEE 754 single precision format
    parameter EXPONENT_BIAS = 127;
    parameter EXPONENT_BITS = 8;
    parameter MANTISSA_BITS = 23;

    // Internal signals for float to int conversion
    wire sign = a_i[31];
    wire [7:0] expo_ = a_i[30:23];
    wire [54:0] mantissa = {31'b0, 1'b1, a_i[22:0]};
    wire expo_is_low = (expo_ < 8'd127);
    wire [7:0] exp_diff = expo_is_low ? 8'd0 : expo_ - 8'd127;
    wire [7:0] exp_diff_limit = op_signed_i ? 8'd30 : 8'd31;
    wire over_flow = exp_diff > exp_diff_limit;
    wire [54:0] mantissa_shifted = mantissa << exp_diff;
    wire [31:0] float_to_int_convert_result = over_flow ? 
        (op_signed_i ? (sign ? 32'h8000_0000 : 32'h7fff_ffff) : 32'hffff_ffff) : 
        (op_signed_i ? {sign, mantissa_shifted[53:23]} : mantissa_shifted[54:23]);


    // Internal signals for int to float conversion
    reg signed [31:0] abs_input;
    reg [EXPONENT_BITS-1:0] exponent;
    reg sign_int;
	
    integer shift_amount;
	reg [31:0] m_temp;
	reg [MANTISSA_BITS-1:0] mantissa_int;
	reg [31:0] a_i_twos_converted;
	reg [31:0] a_i_temp;
    reg [31:0] int_to_float_convert_result;
	reg [5:0] rd;
	

    always @(a_i, op_signed_i) begin
			a_i_twos_converted =  {-a_i};
			a_i_temp  = op_signed_i ? {1'b0,{a_i[31] ? a_i_twos_converted[30:0] : a_i[30:0] } } : a_i;
			sign_int = op_signed_i ? a_i[31] : 1'd0;
	        casex (a_i_temp)
            //32'b00000000000000000000000000000000: rd = 5'd32;
            32'b00000000000000000000000000000001: rd = 5'd31;
            32'b0000000000000000000000000000001x: rd = 5'd30;
            32'b000000000000000000000000000001xx: rd = 5'd29;
            32'b00000000000000000000000000001xxx: rd = 5'd28;
            32'b0000000000000000000000000001xxxx: rd = 5'd27;
            32'b000000000000000000000000001xxxxx: rd = 5'd26;
            32'b00000000000000000000000001xxxxxx: rd = 5'd25;
            32'b0000000000000000000000001xxxxxxx: rd = 5'd24;
            32'b000000000000000000000001xxxxxxxx: rd = 5'd23;
            32'b00000000000000000000001xxxxxxxxx: rd = 5'd22;
            32'b0000000000000000000001xxxxxxxxxx: rd = 5'd21;
            32'b000000000000000000001xxxxxxxxxxx: rd = 5'd20;
            32'b00000000000000000001xxxxxxxxxxxx: rd = 5'd19;
            32'b0000000000000000001xxxxxxxxxxxxx: rd = 5'd18;
            32'b000000000000000001xxxxxxxxxxxxxx: rd = 5'd17;
            32'b00000000000000001xxxxxxxxxxxxxxx: rd = 5'd16;
            32'b0000000000000001xxxxxxxxxxxxxxxx: rd = 5'd15;
            32'b000000000000001xxxxxxxxxxxxxxxxx: rd = 5'd14;
            32'b00000000000001xxxxxxxxxxxxxxxxxx: rd = 5'd13;
            32'b0000000000001xxxxxxxxxxxxxxxxxxx: rd = 5'd12;
            32'b000000000001xxxxxxxxxxxxxxxxxxxx: rd = 5'd11;
            32'b00000000001xxxxxxxxxxxxxxxxxxxxx: rd = 5'd10;
            32'b0000000001xxxxxxxxxxxxxxxxxxxxxx: rd = 5'd9;
            32'b000000001xxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd8;
            32'b00000001xxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd7;
            32'b0000001xxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd6;
            32'b000001xxxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd5;
            32'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd4;
            32'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd3;
            32'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd2;
            32'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd1;
            32'b1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd0;
            //32'b1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: rd = 5'd0;
            default: rd = 0; // If no bits are set, return 32
			endcase
		
        // Special case for zero
        if (a_i_temp == 0) begin
            int_to_float_convert_result = 32'b0;
        end else begin
            // Normalize the absolute value to the form 1.x * 2^exp
            //exponent = EXPONENT_BIAS + 31;  // Start with 31, the max possible shift
			m_temp  =  a_i_temp << (rd + 1); // a_i_temp mı yoksa ai mı olacak karar veremedim 
			mantissa_int = m_temp[31:9];
            exponent = EXPONENT_BIAS + 31 - rd;
            // Assemble the final single-precision number
            int_to_float_convert_result = {sign_int, exponent, mantissa_int};
        end
    end

    // Select the conversion type
    assign result = conv_type_i ? int_to_float_convert_result : (expo_is_low ? 32'h0 : float_to_int_convert_result);

endmodule
