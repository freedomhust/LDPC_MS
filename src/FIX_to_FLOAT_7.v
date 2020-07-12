/*
 * Author: neidong_fu
 * Time  : 2020/03/04
 * function: change 7 bits fix number to float  
*/

module FIX_to_FLOAT_7(
    input [14:0] in,
    output sign,
    output reg [6:0] exp,
    output reg [9:0] mantissa
    );
    
    assign sign = 0;
    always@(*) begin
        if(in[14]) begin
            mantissa = in[14:14-9];
            exp = 7; 
        end
        else if(in[13]) begin
            mantissa = in[13:13-9];
            exp = 6;
        end
        else if(in[12]) begin
            mantissa = in[12:12-9];
            exp = 5;
        end
        else if(in[11]) begin
            mantissa = in[11:11-9];
            exp = 4;
        end
        else if(in[10]) begin
            mantissa = in[10:10-9];
            exp = 3;
        end
        else begin
            mantissa = in[9:9-9];
            exp = 2;
        end
    end
    
endmodule
