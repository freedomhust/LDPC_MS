/*
 * Author: neidong_fu
 * Time  : 2020/03/04
 * function: caculate sqrt(exp)
*/

module exp_sqrt(
    // out = sqrt(2^in) = 2^(in/2) = round(2^(in/2) * 2^8)
    input [6:0] in,        // in (1,6,0)
    output reg [11:0] out // out(0,0,12)
    );
    
    always@(*) begin
        case (in)
            7'd   0:out = 12'd   256;
            7'd   1:out = 12'd   362;
            7'd   2:out = 12'd   512;
            7'd   3:out = 12'd   724;
            7'd   4:out = 12'd  1024;
            7'd   5:out = 12'd  1448;
            7'd   6:out = 12'd  2048;
            7'd   7:out = 12'd  2896;
            7'd   8:out = 12'd  4095;         // saturate to 4095
            7'd   9:out = 12'd  4095;
            7'd  10:out = 12'd  4095;
            7'd  11:out = 12'd  4095;
            7'd  12:out = 12'd  4095;
            7'd  13:out = 12'd  4095;
            7'd  14:out = 12'd  4095;
            7'd  15:out = 12'd  4095;
            7'd  16:out = 12'd  4095;
            7'd  17:out = 12'd  4095;
            7'd  18:out = 12'd  4095;
            7'd  19:out = 12'd  4095;
            7'd  20:out = 12'd  4095;
            7'd  21:out = 12'd  4095;
            7'd  22:out = 12'd  4095;
            7'd  23:out = 12'd  4095;
            7'd  24:out = 12'd  4095;
            7'd  25:out = 12'd  4095;
            7'd  26:out = 12'd  4095;
            7'd  27:out = 12'd  4095;
            7'd  28:out = 12'd  4095;
            7'd  29:out = 12'd 4095;
            7'd  30:out = 12'd 4095;
            7'd  31:out = 12'd 4095;
            7'd  32:out = 12'd 4095;
            7'd  33:out = 12'd 4095;
            7'd  34:out = 12'd 4095;
            7'd  35:out = 12'd 4095;
            7'd  36:out = 12'd 4095;
            7'd  37:out = 12'd 4095;
            7'd  38:out = 12'd 4095;
            7'd  39:out = 12'd 4095;
            7'd  40:out = 12'd 4095;
            7'd  41:out = 12'd 4095;
            7'd  42:out = 12'd 4095;
            7'd  43:out = 12'd 4095;
            7'd  44:out = 12'd 4095;
            7'd  45:out = 12'd 4095;
            7'd  46:out = 12'd 4095;
            7'd  47:out = 12'd 4095;
            7'd  48:out = 12'd 4095;
            7'd  49:out = 12'd 4095;
            7'd  50:out = 12'd 4095;
            7'd  51:out = 12'd 4095;
            7'd  52:out = 12'd 4095;
            7'd  53:out = 12'd 4095;
            7'd  54:out = 12'd 4095;
            7'd  55:out = 12'd 4095;
            7'd  56:out = 12'd 4095;
            7'd  57:out = 12'd 4095;
            7'd  58:out = 12'd 4095;
            7'd  59:out = 12'd 4095;
            7'd  60:out = 12'd 4095;
            7'd  61:out = 12'd 4095;
            7'd  62:out = 12'd 4095;
            7'd  63:out = 12'd 4095;
            7'd  64:out = 12'd 0;                     // index = 64 (-64), 0
            7'd  65:out = 12'd 0;                     // index = 65 (-63), 0
            7'd  66:out = 12'd 0;
            7'd  67:out = 12'd 0;
            7'd  68:out = 12'd 0;
            7'd  69:out = 12'd 0;
            7'd  70:out = 12'd 0;
            7'd  71:out = 12'd 0;
            7'd  72:out = 12'd 0;
            7'd  73:out = 12'd 0;
            7'd  74:out = 12'd 0;
            7'd  75:out = 12'd 0;
            7'd  76:out = 12'd 0;
            7'd  77:out = 12'd 0;
            7'd  78:out = 12'd 0;
            7'd  79:out = 12'd 0;
            7'd  80:out = 12'd 0;
            7'd  81:out = 12'd 0;
            7'd  82:out = 12'd 0;
            7'd  83:out = 12'd 0;
            7'd  84:out = 12'd 0;
            7'd  85:out = 12'd 0;
            7'd  86:out = 12'd 0;
            7'd  87:out = 12'd 0;
            7'd  88:out = 12'd 0;
            7'd  89:out = 12'd 0;
            7'd  90:out = 12'd 0;
            7'd  91:out = 12'd 0;
            7'd  92:out = 12'd 0;
            7'd  93:out = 12'd 0;
            7'd  94:out = 12'd 0;
            7'd  95:out = 12'd 0;
            7'd  96:out = 12'd 0;
            7'd  97:out = 12'd 0;
            7'd  98:out = 12'd 0;
            7'd  99:out = 12'd 0;
            7'd 100:out = 12'd 0;
            7'd 101:out = 12'd 0;
            7'd 102:out = 12'd 0;
            7'd 103:out = 12'd 0;
            7'd 104:out = 12'd 0;
            7'd 105:out = 12'd 0;
            7'd 106:out = 12'd 0;
            7'd 107:out = 12'd 0;
            7'd 108:out = 12'd 0;
            7'd 109:out = 12'd 0;
            7'd 110:out = 12'd 1;
            7'd 111:out = 12'd 1;
            7'd 112:out = 12'd 1;
            7'd 113:out = 12'd 1;
            7'd 114:out = 12'd 2;
            7'd 115:out = 12'd 3;
            7'd 116:out = 12'd 4;
            7'd 117:out = 12'd 6;
            7'd 118:out = 12'd 8;
            7'd 119:out = 12'd 11;
            7'd 120:out = 12'd 16;
            7'd 121:out = 12'd 23;
            7'd 122:out = 12'd 32;
            7'd 123:out = 12'd 45;
            7'd 124:out = 12'd 64;
            7'd 125:out = 12'd 91;
            7'd 126:out = 12'd 128;
            7'd 127:out = 12'd 181;                    // index = 127 (-1), 181
            default: out =12'd0; 
        endcase
    end
    
endmodule
