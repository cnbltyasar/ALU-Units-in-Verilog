`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2024 09:47:47
// Design Name: 
// Module Name: unsigned_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`define N(n)                       [(n)-1:0]
`define FFx(signal,bits)           always @ ( posedge clk or posedge  rst ) if (   rst   )  signal <= bits;  else


module unsigned_divider 
#(
    parameter                      XLEN          = 32,
    parameter `N(XLEN)             STAGE_LIST    = 0
)
(

    input              clk,
    input              rst,

    input  `N(XLEN)    a,
    input  `N(XLEN)    b,
    input              vld,


    output `N(XLEN)    quo,
    output `N(XLEN)    rem,
    output             ack

);

    reg               ready    `N(XLEN+1);
    reg `N(XLEN)      dividend `N(XLEN+1);  
    reg `N(XLEN)      divisor  `N(XLEN+1);
    reg `N(XLEN)      quotient `N(XLEN+1);     

    always@* begin
        ready[0]    = vld;    
        dividend[0] = a;
        divisor[0]  = b;
        quotient[0] = 0;
    end   

    generate
    	genvar i;
    	for (i=0;i<XLEN;i=i+1) begin:gen_div

            wire [i:0]      m = dividend[i]>>(XLEN-i-1);
             
            wire [i:0]      n = divisor[i];
     
    	    wire            q = (|(divisor[i]>>(i+1))) ? 1'b0 : ( m>=n );
     
    	    wire [i:0]      t = q ? (m - n) : m;

			wire [XLEN-1:0] u = dividend[i]<<(i+1);
			    
    	    wire [XLEN+i:0] d = {t,u}>>(i+1);

            if (STAGE_LIST[XLEN-i-1]) begin:gen_ff
                `FFx(ready[i+1],0)
                ready[i+1] <= ready[i];

                `FFx(dividend[i+1],0)
                dividend[i+1] <= d;

                `FFx(divisor[i+1],0)
                divisor[i+1] <= divisor[i];

                `FFx(quotient[i+1],0)
                quotient[i+1] <= quotient[i]|(q<<(XLEN-i-1));
               
            end else begin:gen_comb
                always @* begin
                	ready[i+1]    = ready[i];
                	dividend[i+1] = d;
                    divisor[i+1]  = divisor[i];
                	quotient[i+1] = quotient[i]|(q<<(XLEN-i-1));                	
                end
            end
        end
    endgenerate

    assign quo = quotient[XLEN];

    assign rem = dividend[XLEN];

    assign ack = ready[XLEN];

endmodule

