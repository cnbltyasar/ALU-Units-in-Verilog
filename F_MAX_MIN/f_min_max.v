`timescale 1ns / 1ps

module f_min_max(
	input [31:0] rs1,
	input [31:0] rs2,
	input [1:0] func_type,
	output reg[31:0] rd
);
	// Extract components of the single-precision floating-point number
	
    wire sign_1 = rs1[31];
    wire [7:0] exp_1 = rs1[30:23];
    wire [22:0] mantissa_1 = rs1[22:0];
	
	wire sign_2 = rs2[31];
    wire [7:0] exp_2 = rs2[30:23];
    wire [22:0] mantissa_2 = rs2[22:0];
	

    // NaN has all exponent bits set and a non-zero fraction
    wire isNaN_rs1 = (rs1[30:23] == 8'hFF) & (rs1[22:0] != 0);
	wire isNaN_rs2 = (rs2[30:23] == 8'hFF) & (rs2[22:0] != 0);

	
	
	always@(func_type, rs1, rs2, isNaN_rs1, isNaN_rs2, sign_1, sign_2, exp_1, exp_2, mantissa_1, mantissa_2) begin 
		if(func_type == 2'b00)begin
			// Fmax functıon called
			// Compare signs
			if (sign_1 != sign_2) begin
				rd = sign_1 ? rs2 : rs1;
			end else begin
				// Compare exponents if signs are the same
				if (exp_1 != exp_2) begin
					if (sign_1) begin
						rd = exp_1 > exp_2 ? rs2 : rs1;
					end else begin
						rd = exp_1 < exp_2 ? rs2 : rs1;
					end
				end else begin
					// Compare fractions if exponents are the same
					if (sign_1) begin
						rd = mantissa_1 >= mantissa_2 ? rs2 : rs1;
					end else begin
						rd = mantissa_1 <= mantissa_2 ? rs2 : rs1;
					end
				end
			end
			
		end else if(func_type == 2'b01)begin
			if (sign_1 != sign_2) begin
				// If signs are different, the negative number is smaller
				rd = sign_1 ? rs1 : rs2;
				end else begin
				// Compare exponents if signs are the same
				if (exp_1 != exp_2) begin
					if (sign_1) begin
						// If both are negative, the one with the larger exponent is smaller
						rd = exp_1 > exp_2 ? rs1 : rs2;
					end else begin
						// If both are positive, the one with the smaller exponent is smaller
						rd = exp_1 < exp_2 ? rs1 : rs2;
					end
				end else begin
					// Compare fractions if exponents are the same
					if (sign_1) begin
						// If both are negative, the one with the larger fraction is smaller
						rd = mantissa_1 >= mantissa_2 ? rs1 : rs2;
					end else begin
						// If both are positive, the one with the smaller fraction is smaller
						rd = mantissa_1 <= mantissa_2 ? rs1 : rs2;
					end
				end
			end
		end else if(func_type == 2'b10)begin
			//F_LT
			if (isNaN_rs1 || isNaN_rs2) begin
				rd = 32'd0;

			end else begin 
				// Compare signs
				if (sign_1 != sign_2) begin
					rd = sign_1 ?  32'd1 : 32'd0;
				end else begin
					// Compare exponents if signs are the same
					if (exp_1 != exp_2) begin
						if (sign_1) begin
							rd = exp_1 > exp_2 ?  32'd1 : 32'd0;
						end else begin
							rd = exp_1 < exp_2 ?  32'd1 : 32'd0;
						end
					end else begin
						// Compare fractions if exponents are the same
						if (sign_1) begin
							rd = mantissa_1 > mantissa_2 ? 32'd1 : 32'd0;
						end else begin
							rd = mantissa_1 < mantissa_2 ?  32'd1 : 32'd0;
						end
					end
				end
			end 

		 

		end else if(func_type == 2'b11)begin
			//F_LEQ
			if (isNaN_rs1 || isNaN_rs2) begin
				rd = 32'd0;

			end else begin 
				// Compare signs
				if (sign_1 != sign_2) begin
					rd = sign_1 ?  32'd1 : 32'd0;
				end else begin
					// Compare exponents if signs are the same
					if (exp_1 != exp_2) begin
						if (sign_1) begin
							rd = exp_1 > exp_2 ?  32'd1 : 32'd0;
						end else begin
							rd = exp_1 < exp_2 ?  32'd1 : 32'd0;
						end
					end else begin
						// Compare fractions if exponents are the same
						if (sign_1) begin
							rd = mantissa_1 >= mantissa_2 ? 32'd1 : 32'd0;
						end else begin
							rd = mantissa_1 <= mantissa_2 ?  32'd1 : 32'd0;
						end
					end
				end
			end


 
		end
		
	end 
endmodule
