`timescale 1ns / 1ps

module fclass_s (
    input  [31:0] rs1,  // Input floating-point value (single-precision)
    output reg [9:0] rd // Output classification mask
);

    // Extract components of the single-precision floating-point number
    wire sign = rs1[31];
    wire [7:0] exp = rs1[30:23];
    wire [22:0] frac = rs1[22:0];

    always @(sign, exp, frac) begin
        // Initialize output to 0
        rd = 10'b0;
        
        // Classify the floating-point number
        if (exp == 8'b11111111) begin
            if (frac[22] == 1) 
                rd = 10'b1000000000;  // Quiet NaN
            else if (frac != 0) 
                rd = 10'b0100000000;  // Signaling NaN
            else if (sign) 
                rd = 10'b0000000001;  // Negative infinity
            else 
                rd = 10'b0010000000;  // Positive infinity
        end
        else if (exp == 8'b00000000) begin
            if (frac == 0) begin
                if (sign)
                    rd = 10'b0000001000;  // Negative zero
                else
                    rd = 10'b0000010000;  // Positive zero
            end else begin
                if (sign)
                    rd = 10'b0000000100;  // Negative subnormal
                else
                    rd = 10'b0000100000;  // Positive subnormal
            end
        end
        else begin
            if (sign)
                rd = 10'b0000000010;  // Negative normal
            else
                rd = 10'b0001000000;  // Positive normal
        end
    end

endmodule
