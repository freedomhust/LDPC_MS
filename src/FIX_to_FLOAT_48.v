/*
 * Author: neidong_fu
 * Time  : 2020/03/04
 * function: change 48 bits fix number to float  
*/

module FIX_to_FLOAT_48(
    input [47:0] in,
    output sign,
    output reg [6:0] exp,
    output reg [9:0] mantissa
    );
    
    assign sign = 0;
    
    always@(*) begin
        if (in[47]) begin
            mantissa = in[47:47-9];
            exp = -1;
        end
        else if(in[46]) begin
                mantissa = in[46:46-9];
                exp = -2;
        end
        else if(in[45]) begin
                mantissa = in[45:45-9];
                exp = -3;
        end
        else if(in[44]) begin
                mantissa = in[44:44-9];
                exp = -4;
        end
        else if(in[43]) begin
                mantissa = in[43:43-9];
                exp = -5;
        end
        else if(in[42]) begin
                mantissa = in[42:42-9];
                exp = -6;
        end
        else if(in[41]) begin
                mantissa = in[41:41-9];
                exp = -7;
        end
        else if(in[40]) begin
                mantissa = in[40:40-9];
                exp = -8;
        end
        else if(in[39]) begin
                mantissa = in[39:39-9];
                exp = -9;
        end
        else if(in[38]) begin
                mantissa = in[38:38-9];
                exp = -10;
        end
        else if(in[37]) begin
                mantissa = in[37:37-9];
                exp = -11;
        end
        else if(in[36]) begin
                mantissa = in[36:36-9];
                exp = -12;
        end
        else if(in[35]) begin
                mantissa = in[35:35-9];
                exp = -13;
        end
        else if(in[34]) begin
                mantissa = in[34:34-9];
                exp = -14;
        end
        else if(in[33]) begin
                mantissa = in[33:33-9];
                exp = -15;
        end
        else if(in[32]) begin
                mantissa = in[32:32-9];
                exp = -16;
        end
        else if(in[31]) begin
                mantissa = in[31:31-9];
                exp = -17;
        end
        else if(in[30]) begin
                mantissa = in[30:30-9];
                exp = -18;
        end
        else if(in[29]) begin
                mantissa = in[29:29-9];
                exp = -19;
        end
        else if(in[28]) begin
                mantissa = in[28:28-9];
                exp = -20;
        end
        else if(in[27]) begin
                mantissa = in[27:27-9];
                exp = -21;
        end
        else if(in[26]) begin
                mantissa = in[26:26-9];
                exp = -22;
        end
        else if(in[25]) begin
                mantissa = in[25:25-9];
                exp = -23;
        end
        else if(in[24]) begin
                mantissa = in[24:24-9];
                exp = -24;
        end
        else if(in[23]) begin
                mantissa = in[23:23-9];
                exp = -25;
        end
        else if(in[22]) begin
                mantissa = in[22:22-9];
                exp = -26;
        end
        else if(in[21]) begin
                mantissa = in[21:21-9];
                exp = -27;
        end
        else if(in[20]) begin
                mantissa = in[20:20-9];
                exp = -28;
        end
        else if(in[19]) begin
                mantissa = in[19:19-9];
                exp = -29;
        end
        else if(in[18]) begin
                mantissa = in[18:18-9];
                exp = -30;
        end
        else if(in[17]) begin
                mantissa = in[17:17-9];
                exp = -31;
        end
        else if(in[16]) begin
                mantissa = in[16:16-9];
                exp = -32;
        end
        else if(in[15]) begin
                mantissa = in[15:15-9];
                exp = -33;
        end
        else if(in[14]) begin
                mantissa = in[14:14-9];
                exp = -34;
        end
        else if(in[13]) begin
                mantissa = in[13:13-9];
                exp = -35;
        end
        else if(in[12]) begin
                mantissa = in[12:12-9];
                exp = -36;
        end
        else if(in[11]) begin
                mantissa = in[11:11-9];
                exp = -37;
        end
        else if(in[10]) begin
                mantissa = in[10:10-9];
                exp = -38;
        end
        else begin
            mantissa = in[9:9-9];
            exp = -39;
        end
    end
   
endmodule
