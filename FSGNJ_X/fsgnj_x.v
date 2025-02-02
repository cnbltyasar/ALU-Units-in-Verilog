`timescale 1ns / 1ps

module fsgnj_x(
    input  [31:0] rs1,  // Input floating-point value (single-precision)
	input  [31:0] rs2,  // Input floating-point value (single-precision)
	input  [1:0] op_type, 
    output reg [31:0] rd // Output classification mask
    );
	
	// Extract components of the single-precision floating-point number1 and number 2
    wire sign_1 = rs1[31];
    wire [30:0] magnitude_1 = rs1[30:0];
	
	wire sign_2 = rs2[31];
    wire [30:0] magnitude_2 = rs2[30:0];
	
	always@(sign_1, sign_2, magnitude_1, magnitude_2, op_type) begin 
	// ---------------------------initialize rd value 
	rd = 32'd0;
	// fsgnj.s rd, rs1, rs2: rs1 kaydındaki değerin büyüklüğünü ve rs2 kaydındaki değerin işaret bitini
	if(op_type == 2'b00) begin 
		rd[30:0] = magnitude_1;
		rd[31] = sign_2;
	end 
	// ---------------------------fsgnjn.s rd, rs1, rs2: rs1 kaydındaki değerin büyüklüğünü ve rs2 kaydındaki değerin ters işaret biti
	else if(op_type == 2'b01) begin 
		rd[30:0] = magnitude_1;
		rd[31] = ~sign_2;
	end
	
	// ---------------------------fsgnjx.s rd, rs1, rs2: rs1 kaydındaki değerin büyüklüğünü ve rs1 ile rs2 kaydındaki değerlerin işaret bitlerinin XOR işlemi sonucunu kullan
	else if(op_type == 2'b10) begin
		rd[30:0] = magnitude_1;
		rd[31] = sign_1^sign_2;
	end 
	// default case 
	else if(op_type == 2'b11) begin
		rd[30:0] = magnitude_1;
		rd[31] = sign_1;
	end
	
	end 
endmodule
