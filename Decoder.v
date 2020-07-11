
module Decoder(
input clk,
input rst,
input demodulation_down_to_decoder,
output reg demodulation_to_decoder_receive,
// 解调后的数据
input [71:0]initial_value_input,
output reg decoder_down
);
// 对initial_value进行拆分
wire [5:0] initial_value[11:0];
assign initial_value[0] = initial_value_input[5:0];
assign initial_value[1] = initial_value_input[11:6];
assign initial_value[2] = initial_value_input[17:12];
assign initial_value[3] = initial_value_input[23:18];
assign initial_value[4] = initial_value_input[29:24];
assign initial_value[5] = initial_value_input[35:30];
assign initial_value[6] = initial_value_input[41:36];
assign initial_value[7] = initial_value_input[47:42];
assign initial_value[8] = initial_value_input[53:48];
assign initial_value[9] = initial_value_input[59:54];
assign initial_value[10] = initial_value_input[65:60];
assign initial_value[11] = initial_value_input[71:66];
reg [11:0]initial_value_enable;
wire [11:0]initial_down;
reg check_begin;
reg [2:0] decision_state;
reg decision_down;
reg decision_success;
reg [11:0]decision_information;
reg [9:0] decision_times;
reg [11:0]decision_result;
reg decision_time_max;
wire [11:0]decision_variable_enable;
// 校验节点0的接口
wire [35:0] value_variable_to_check_0;
wire [35:0] value_check_0_to_variable;
wire [5:0] enable_variable_to_check_0;
wire [5:0] enable_check_0_to_variable;
// 拆分后校验节点0传递给变量节点1的值以及对变量节点1传递过来的值
wire [5:0] value_check_0_to_variable_1;
wire enable_check_0_to_variable_1;
wire [5:0] value_variable_1_to_check_0;
wire enable_variable_1_to_check_0;
// 对校验节点的输出值进行拆分
assign value_check_0_to_variable_1 = value_check_0_to_variable[5:0];
assign enable_check_0_to_variable_1 = enable_check_0_to_variable[0];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_0[5:0] = value_variable_1_to_check_0;
assign enable_variable_to_check_0[0] = enable_variable_1_to_check_0;
// 拆分后校验节点0传递给变量节点5的值以及对变量节点5传递过来的值
wire [5:0] value_check_0_to_variable_5;
wire enable_check_0_to_variable_5;
wire [5:0] value_variable_5_to_check_0;
wire enable_variable_5_to_check_0;
// 对校验节点的输出值进行拆分
assign value_check_0_to_variable_5 = value_check_0_to_variable[11:6];
assign enable_check_0_to_variable_5 = enable_check_0_to_variable[1];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_0[11:6] = value_variable_5_to_check_0;
assign enable_variable_to_check_0[1] = enable_variable_5_to_check_0;
// 拆分后校验节点0传递给变量节点6的值以及对变量节点6传递过来的值
wire [5:0] value_check_0_to_variable_6;
wire enable_check_0_to_variable_6;
wire [5:0] value_variable_6_to_check_0;
wire enable_variable_6_to_check_0;
// 对校验节点的输出值进行拆分
assign value_check_0_to_variable_6 = value_check_0_to_variable[17:12];
assign enable_check_0_to_variable_6 = enable_check_0_to_variable[2];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_0[17:12] = value_variable_6_to_check_0;
assign enable_variable_to_check_0[2] = enable_variable_6_to_check_0;
// 拆分后校验节点0传递给变量节点9的值以及对变量节点9传递过来的值
wire [5:0] value_check_0_to_variable_9;
wire enable_check_0_to_variable_9;
wire [5:0] value_variable_9_to_check_0;
wire enable_variable_9_to_check_0;
// 对校验节点的输出值进行拆分
assign value_check_0_to_variable_9 = value_check_0_to_variable[23:18];
assign enable_check_0_to_variable_9 = enable_check_0_to_variable[3];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_0[23:18] = value_variable_9_to_check_0;
assign enable_variable_to_check_0[3] = enable_variable_9_to_check_0;
// 拆分后校验节点0传递给变量节点10的值以及对变量节点10传递过来的值
wire [5:0] value_check_0_to_variable_10;
wire enable_check_0_to_variable_10;
wire [5:0] value_variable_10_to_check_0;
wire enable_variable_10_to_check_0;
// 对校验节点的输出值进行拆分
assign value_check_0_to_variable_10 = value_check_0_to_variable[29:24];
assign enable_check_0_to_variable_10 = enable_check_0_to_variable[4];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_0[29:24] = value_variable_10_to_check_0;
assign enable_variable_to_check_0[4] = enable_variable_10_to_check_0;
// 拆分后校验节点0传递给变量节点11的值以及对变量节点11传递过来的值
wire [5:0] value_check_0_to_variable_11;
wire enable_check_0_to_variable_11;
wire [5:0] value_variable_11_to_check_0;
wire enable_variable_11_to_check_0;
// 对校验节点的输出值进行拆分
assign value_check_0_to_variable_11 = value_check_0_to_variable[35:30];
assign enable_check_0_to_variable_11 = enable_check_0_to_variable[5];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_0[35:30] = value_variable_11_to_check_0;
assign enable_variable_to_check_0[5] = enable_variable_11_to_check_0;

// 校验节点1的接口
wire [35:0] value_variable_to_check_1;
wire [35:0] value_check_1_to_variable;
wire [5:0] enable_variable_to_check_1;
wire [5:0] enable_check_1_to_variable;
// 拆分后校验节点1传递给变量节点0的值以及对变量节点0传递过来的值
wire [5:0] value_check_1_to_variable_0;
wire enable_check_1_to_variable_0;
wire [5:0] value_variable_0_to_check_1;
wire enable_variable_0_to_check_1;
// 对校验节点的输出值进行拆分
assign value_check_1_to_variable_0 = value_check_1_to_variable[5:0];
assign enable_check_1_to_variable_0 = enable_check_1_to_variable[0];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_1[5:0] = value_variable_0_to_check_1;
assign enable_variable_to_check_1[0] = enable_variable_0_to_check_1;
// 拆分后校验节点1传递给变量节点7的值以及对变量节点7传递过来的值
wire [5:0] value_check_1_to_variable_7;
wire enable_check_1_to_variable_7;
wire [5:0] value_variable_7_to_check_1;
wire enable_variable_7_to_check_1;
// 对校验节点的输出值进行拆分
assign value_check_1_to_variable_7 = value_check_1_to_variable[11:6];
assign enable_check_1_to_variable_7 = enable_check_1_to_variable[1];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_1[11:6] = value_variable_7_to_check_1;
assign enable_variable_to_check_1[1] = enable_variable_7_to_check_1;
// 拆分后校验节点1传递给变量节点8的值以及对变量节点8传递过来的值
wire [5:0] value_check_1_to_variable_8;
wire enable_check_1_to_variable_8;
wire [5:0] value_variable_8_to_check_1;
wire enable_variable_8_to_check_1;
// 对校验节点的输出值进行拆分
assign value_check_1_to_variable_8 = value_check_1_to_variable[17:12];
assign enable_check_1_to_variable_8 = enable_check_1_to_variable[2];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_1[17:12] = value_variable_8_to_check_1;
assign enable_variable_to_check_1[2] = enable_variable_8_to_check_1;
// 拆分后校验节点1传递给变量节点9的值以及对变量节点9传递过来的值
wire [5:0] value_check_1_to_variable_9;
wire enable_check_1_to_variable_9;
wire [5:0] value_variable_9_to_check_1;
wire enable_variable_9_to_check_1;
// 对校验节点的输出值进行拆分
assign value_check_1_to_variable_9 = value_check_1_to_variable[23:18];
assign enable_check_1_to_variable_9 = enable_check_1_to_variable[3];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_1[23:18] = value_variable_9_to_check_1;
assign enable_variable_to_check_1[3] = enable_variable_9_to_check_1;
// 拆分后校验节点1传递给变量节点10的值以及对变量节点10传递过来的值
wire [5:0] value_check_1_to_variable_10;
wire enable_check_1_to_variable_10;
wire [5:0] value_variable_10_to_check_1;
wire enable_variable_10_to_check_1;
// 对校验节点的输出值进行拆分
assign value_check_1_to_variable_10 = value_check_1_to_variable[29:24];
assign enable_check_1_to_variable_10 = enable_check_1_to_variable[4];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_1[29:24] = value_variable_10_to_check_1;
assign enable_variable_to_check_1[4] = enable_variable_10_to_check_1;
// 拆分后校验节点1传递给变量节点11的值以及对变量节点11传递过来的值
wire [5:0] value_check_1_to_variable_11;
wire enable_check_1_to_variable_11;
wire [5:0] value_variable_11_to_check_1;
wire enable_variable_11_to_check_1;
// 对校验节点的输出值进行拆分
assign value_check_1_to_variable_11 = value_check_1_to_variable[35:30];
assign enable_check_1_to_variable_11 = enable_check_1_to_variable[5];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_1[35:30] = value_variable_11_to_check_1;
assign enable_variable_to_check_1[5] = enable_variable_11_to_check_1;

// 校验节点2的接口
wire [35:0] value_variable_to_check_2;
wire [35:0] value_check_2_to_variable;
wire [5:0] enable_variable_to_check_2;
wire [5:0] enable_check_2_to_variable;
// 拆分后校验节点2传递给变量节点0的值以及对变量节点0传递过来的值
wire [5:0] value_check_2_to_variable_0;
wire enable_check_2_to_variable_0;
wire [5:0] value_variable_0_to_check_2;
wire enable_variable_0_to_check_2;
// 对校验节点的输出值进行拆分
assign value_check_2_to_variable_0 = value_check_2_to_variable[5:0];
assign enable_check_2_to_variable_0 = enable_check_2_to_variable[0];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_2[5:0] = value_variable_0_to_check_2;
assign enable_variable_to_check_2[0] = enable_variable_0_to_check_2;
// 拆分后校验节点2传递给变量节点1的值以及对变量节点1传递过来的值
wire [5:0] value_check_2_to_variable_1;
wire enable_check_2_to_variable_1;
wire [5:0] value_variable_1_to_check_2;
wire enable_variable_1_to_check_2;
// 对校验节点的输出值进行拆分
assign value_check_2_to_variable_1 = value_check_2_to_variable[11:6];
assign enable_check_2_to_variable_1 = enable_check_2_to_variable[1];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_2[11:6] = value_variable_1_to_check_2;
assign enable_variable_to_check_2[1] = enable_variable_1_to_check_2;
// 拆分后校验节点2传递给变量节点2的值以及对变量节点2传递过来的值
wire [5:0] value_check_2_to_variable_2;
wire enable_check_2_to_variable_2;
wire [5:0] value_variable_2_to_check_2;
wire enable_variable_2_to_check_2;
// 对校验节点的输出值进行拆分
assign value_check_2_to_variable_2 = value_check_2_to_variable[17:12];
assign enable_check_2_to_variable_2 = enable_check_2_to_variable[2];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_2[17:12] = value_variable_2_to_check_2;
assign enable_variable_to_check_2[2] = enable_variable_2_to_check_2;
// 拆分后校验节点2传递给变量节点4的值以及对变量节点4传递过来的值
wire [5:0] value_check_2_to_variable_4;
wire enable_check_2_to_variable_4;
wire [5:0] value_variable_4_to_check_2;
wire enable_variable_4_to_check_2;
// 对校验节点的输出值进行拆分
assign value_check_2_to_variable_4 = value_check_2_to_variable[23:18];
assign enable_check_2_to_variable_4 = enable_check_2_to_variable[3];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_2[23:18] = value_variable_4_to_check_2;
assign enable_variable_to_check_2[3] = enable_variable_4_to_check_2;
// 拆分后校验节点2传递给变量节点5的值以及对变量节点5传递过来的值
wire [5:0] value_check_2_to_variable_5;
wire enable_check_2_to_variable_5;
wire [5:0] value_variable_5_to_check_2;
wire enable_variable_5_to_check_2;
// 对校验节点的输出值进行拆分
assign value_check_2_to_variable_5 = value_check_2_to_variable[29:24];
assign enable_check_2_to_variable_5 = enable_check_2_to_variable[4];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_2[29:24] = value_variable_5_to_check_2;
assign enable_variable_to_check_2[4] = enable_variable_5_to_check_2;
// 拆分后校验节点2传递给变量节点6的值以及对变量节点6传递过来的值
wire [5:0] value_check_2_to_variable_6;
wire enable_check_2_to_variable_6;
wire [5:0] value_variable_6_to_check_2;
wire enable_variable_6_to_check_2;
// 对校验节点的输出值进行拆分
assign value_check_2_to_variable_6 = value_check_2_to_variable[35:30];
assign enable_check_2_to_variable_6 = enable_check_2_to_variable[5];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_2[35:30] = value_variable_6_to_check_2;
assign enable_variable_to_check_2[5] = enable_variable_6_to_check_2;

// 校验节点3的接口
wire [35:0] value_variable_to_check_3;
wire [35:0] value_check_3_to_variable;
wire [5:0] enable_variable_to_check_3;
wire [5:0] enable_check_3_to_variable;
// 拆分后校验节点3传递给变量节点0的值以及对变量节点0传递过来的值
wire [5:0] value_check_3_to_variable_0;
wire enable_check_3_to_variable_0;
wire [5:0] value_variable_0_to_check_3;
wire enable_variable_0_to_check_3;
// 对校验节点的输出值进行拆分
assign value_check_3_to_variable_0 = value_check_3_to_variable[5:0];
assign enable_check_3_to_variable_0 = enable_check_3_to_variable[0];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_3[5:0] = value_variable_0_to_check_3;
assign enable_variable_to_check_3[0] = enable_variable_0_to_check_3;
// 拆分后校验节点3传递给变量节点2的值以及对变量节点2传递过来的值
wire [5:0] value_check_3_to_variable_2;
wire enable_check_3_to_variable_2;
wire [5:0] value_variable_2_to_check_3;
wire enable_variable_2_to_check_3;
// 对校验节点的输出值进行拆分
assign value_check_3_to_variable_2 = value_check_3_to_variable[11:6];
assign enable_check_3_to_variable_2 = enable_check_3_to_variable[1];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_3[11:6] = value_variable_2_to_check_3;
assign enable_variable_to_check_3[1] = enable_variable_2_to_check_3;
// 拆分后校验节点3传递给变量节点3的值以及对变量节点3传递过来的值
wire [5:0] value_check_3_to_variable_3;
wire enable_check_3_to_variable_3;
wire [5:0] value_variable_3_to_check_3;
wire enable_variable_3_to_check_3;
// 对校验节点的输出值进行拆分
assign value_check_3_to_variable_3 = value_check_3_to_variable[17:12];
assign enable_check_3_to_variable_3 = enable_check_3_to_variable[2];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_3[17:12] = value_variable_3_to_check_3;
assign enable_variable_to_check_3[2] = enable_variable_3_to_check_3;
// 拆分后校验节点3传递给变量节点4的值以及对变量节点4传递过来的值
wire [5:0] value_check_3_to_variable_4;
wire enable_check_3_to_variable_4;
wire [5:0] value_variable_4_to_check_3;
wire enable_variable_4_to_check_3;
// 对校验节点的输出值进行拆分
assign value_check_3_to_variable_4 = value_check_3_to_variable[23:18];
assign enable_check_3_to_variable_4 = enable_check_3_to_variable[3];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_3[23:18] = value_variable_4_to_check_3;
assign enable_variable_to_check_3[3] = enable_variable_4_to_check_3;
// 拆分后校验节点3传递给变量节点8的值以及对变量节点8传递过来的值
wire [5:0] value_check_3_to_variable_8;
wire enable_check_3_to_variable_8;
wire [5:0] value_variable_8_to_check_3;
wire enable_variable_8_to_check_3;
// 对校验节点的输出值进行拆分
assign value_check_3_to_variable_8 = value_check_3_to_variable[29:24];
assign enable_check_3_to_variable_8 = enable_check_3_to_variable[4];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_3[29:24] = value_variable_8_to_check_3;
assign enable_variable_to_check_3[4] = enable_variable_8_to_check_3;
// 拆分后校验节点3传递给变量节点11的值以及对变量节点11传递过来的值
wire [5:0] value_check_3_to_variable_11;
wire enable_check_3_to_variable_11;
wire [5:0] value_variable_11_to_check_3;
wire enable_variable_11_to_check_3;
// 对校验节点的输出值进行拆分
assign value_check_3_to_variable_11 = value_check_3_to_variable[35:30];
assign enable_check_3_to_variable_11 = enable_check_3_to_variable[5];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_3[35:30] = value_variable_11_to_check_3;
assign enable_variable_to_check_3[5] = enable_variable_11_to_check_3;

// 校验节点4的接口
wire [35:0] value_variable_to_check_4;
wire [35:0] value_check_4_to_variable;
wire [5:0] enable_variable_to_check_4;
wire [5:0] enable_check_4_to_variable;
// 拆分后校验节点4传递给变量节点3的值以及对变量节点3传递过来的值
wire [5:0] value_check_4_to_variable_3;
wire enable_check_4_to_variable_3;
wire [5:0] value_variable_3_to_check_4;
wire enable_variable_3_to_check_4;
// 对校验节点的输出值进行拆分
assign value_check_4_to_variable_3 = value_check_4_to_variable[5:0];
assign enable_check_4_to_variable_3 = enable_check_4_to_variable[0];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_4[5:0] = value_variable_3_to_check_4;
assign enable_variable_to_check_4[0] = enable_variable_3_to_check_4;
// 拆分后校验节点4传递给变量节点4的值以及对变量节点4传递过来的值
wire [5:0] value_check_4_to_variable_4;
wire enable_check_4_to_variable_4;
wire [5:0] value_variable_4_to_check_4;
wire enable_variable_4_to_check_4;
// 对校验节点的输出值进行拆分
assign value_check_4_to_variable_4 = value_check_4_to_variable[11:6];
assign enable_check_4_to_variable_4 = enable_check_4_to_variable[1];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_4[11:6] = value_variable_4_to_check_4;
assign enable_variable_to_check_4[1] = enable_variable_4_to_check_4;
// 拆分后校验节点4传递给变量节点5的值以及对变量节点5传递过来的值
wire [5:0] value_check_4_to_variable_5;
wire enable_check_4_to_variable_5;
wire [5:0] value_variable_5_to_check_4;
wire enable_variable_5_to_check_4;
// 对校验节点的输出值进行拆分
assign value_check_4_to_variable_5 = value_check_4_to_variable[17:12];
assign enable_check_4_to_variable_5 = enable_check_4_to_variable[2];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_4[17:12] = value_variable_5_to_check_4;
assign enable_variable_to_check_4[2] = enable_variable_5_to_check_4;
// 拆分后校验节点4传递给变量节点7的值以及对变量节点7传递过来的值
wire [5:0] value_check_4_to_variable_7;
wire enable_check_4_to_variable_7;
wire [5:0] value_variable_7_to_check_4;
wire enable_variable_7_to_check_4;
// 对校验节点的输出值进行拆分
assign value_check_4_to_variable_7 = value_check_4_to_variable[23:18];
assign enable_check_4_to_variable_7 = enable_check_4_to_variable[3];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_4[23:18] = value_variable_7_to_check_4;
assign enable_variable_to_check_4[3] = enable_variable_7_to_check_4;
// 拆分后校验节点4传递给变量节点8的值以及对变量节点8传递过来的值
wire [5:0] value_check_4_to_variable_8;
wire enable_check_4_to_variable_8;
wire [5:0] value_variable_8_to_check_4;
wire enable_variable_8_to_check_4;
// 对校验节点的输出值进行拆分
assign value_check_4_to_variable_8 = value_check_4_to_variable[29:24];
assign enable_check_4_to_variable_8 = enable_check_4_to_variable[4];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_4[29:24] = value_variable_8_to_check_4;
assign enable_variable_to_check_4[4] = enable_variable_8_to_check_4;
// 拆分后校验节点4传递给变量节点10的值以及对变量节点10传递过来的值
wire [5:0] value_check_4_to_variable_10;
wire enable_check_4_to_variable_10;
wire [5:0] value_variable_10_to_check_4;
wire enable_variable_10_to_check_4;
// 对校验节点的输出值进行拆分
assign value_check_4_to_variable_10 = value_check_4_to_variable[35:30];
assign enable_check_4_to_variable_10 = enable_check_4_to_variable[5];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_4[35:30] = value_variable_10_to_check_4;
assign enable_variable_to_check_4[5] = enable_variable_10_to_check_4;

// 校验节点5的接口
wire [35:0] value_variable_to_check_5;
wire [35:0] value_check_5_to_variable;
wire [5:0] enable_variable_to_check_5;
wire [5:0] enable_check_5_to_variable;
// 拆分后校验节点5传递给变量节点1的值以及对变量节点1传递过来的值
wire [5:0] value_check_5_to_variable_1;
wire enable_check_5_to_variable_1;
wire [5:0] value_variable_1_to_check_5;
wire enable_variable_1_to_check_5;
// 对校验节点的输出值进行拆分
assign value_check_5_to_variable_1 = value_check_5_to_variable[5:0];
assign enable_check_5_to_variable_1 = enable_check_5_to_variable[0];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_5[5:0] = value_variable_1_to_check_5;
assign enable_variable_to_check_5[0] = enable_variable_1_to_check_5;
// 拆分后校验节点5传递给变量节点2的值以及对变量节点2传递过来的值
wire [5:0] value_check_5_to_variable_2;
wire enable_check_5_to_variable_2;
wire [5:0] value_variable_2_to_check_5;
wire enable_variable_2_to_check_5;
// 对校验节点的输出值进行拆分
assign value_check_5_to_variable_2 = value_check_5_to_variable[11:6];
assign enable_check_5_to_variable_2 = enable_check_5_to_variable[1];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_5[11:6] = value_variable_2_to_check_5;
assign enable_variable_to_check_5[1] = enable_variable_2_to_check_5;
// 拆分后校验节点5传递给变量节点3的值以及对变量节点3传递过来的值
wire [5:0] value_check_5_to_variable_3;
wire enable_check_5_to_variable_3;
wire [5:0] value_variable_3_to_check_5;
wire enable_variable_3_to_check_5;
// 对校验节点的输出值进行拆分
assign value_check_5_to_variable_3 = value_check_5_to_variable[17:12];
assign enable_check_5_to_variable_3 = enable_check_5_to_variable[2];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_5[17:12] = value_variable_3_to_check_5;
assign enable_variable_to_check_5[2] = enable_variable_3_to_check_5;
// 拆分后校验节点5传递给变量节点6的值以及对变量节点6传递过来的值
wire [5:0] value_check_5_to_variable_6;
wire enable_check_5_to_variable_6;
wire [5:0] value_variable_6_to_check_5;
wire enable_variable_6_to_check_5;
// 对校验节点的输出值进行拆分
assign value_check_5_to_variable_6 = value_check_5_to_variable[23:18];
assign enable_check_5_to_variable_6 = enable_check_5_to_variable[3];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_5[23:18] = value_variable_6_to_check_5;
assign enable_variable_to_check_5[3] = enable_variable_6_to_check_5;
// 拆分后校验节点5传递给变量节点7的值以及对变量节点7传递过来的值
wire [5:0] value_check_5_to_variable_7;
wire enable_check_5_to_variable_7;
wire [5:0] value_variable_7_to_check_5;
wire enable_variable_7_to_check_5;
// 对校验节点的输出值进行拆分
assign value_check_5_to_variable_7 = value_check_5_to_variable[29:24];
assign enable_check_5_to_variable_7 = enable_check_5_to_variable[4];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_5[29:24] = value_variable_7_to_check_5;
assign enable_variable_to_check_5[4] = enable_variable_7_to_check_5;
// 拆分后校验节点5传递给变量节点9的值以及对变量节点9传递过来的值
wire [5:0] value_check_5_to_variable_9;
wire enable_check_5_to_variable_9;
wire [5:0] value_variable_9_to_check_5;
wire enable_variable_9_to_check_5;
// 对校验节点的输出值进行拆分
assign value_check_5_to_variable_9 = value_check_5_to_variable[35:30];
assign enable_check_5_to_variable_9 = enable_check_5_to_variable[5];
// 对变量节点传递过来的值进行组合
assign value_variable_to_check_5[35:30] = value_variable_9_to_check_5;
assign enable_variable_to_check_5[5] = enable_variable_9_to_check_5;

// 变量节点0的接口
wire [17:0] value_check_to_variable_0;
wire [2:0] enable_check_to_variable_0;
wire [5:0] value_variable_0_to_check;
wire enable_variable_0_to_check;
// 对校验节点1传递过来的数据进行整合
assign value_check_to_variable_0[5:0] = value_check_1_to_variable_0;
assign enable_check_to_variable_0[0] = enable_check_1_to_variable_0;
// 将变量节点0的输出与校验节点1的输入相连
assign value_variable_0_to_check_1 = value_variable_0_to_check;
assign enable_variable_0_to_check_1 = enable_variable_0_to_check;
// 对校验节点2传递过来的数据进行整合
assign value_check_to_variable_0[11:6] = value_check_2_to_variable_0;
assign enable_check_to_variable_0[1] = enable_check_2_to_variable_0;
// 将变量节点0的输出与校验节点2的输入相连
assign value_variable_0_to_check_2 = value_variable_0_to_check;
assign enable_variable_0_to_check_2 = enable_variable_0_to_check;
// 对校验节点3传递过来的数据进行整合
assign value_check_to_variable_0[17:12] = value_check_3_to_variable_0;
assign enable_check_to_variable_0[2] = enable_check_3_to_variable_0;
// 将变量节点0的输出与校验节点3的输入相连
assign value_variable_0_to_check_3 = value_variable_0_to_check;
assign enable_variable_0_to_check_3 = enable_variable_0_to_check;

// 变量节点1的接口
wire [17:0] value_check_to_variable_1;
wire [2:0] enable_check_to_variable_1;
wire [5:0] value_variable_1_to_check;
wire enable_variable_1_to_check;
// 对校验节点0传递过来的数据进行整合
assign value_check_to_variable_1[5:0] = value_check_0_to_variable_1;
assign enable_check_to_variable_1[0] = enable_check_0_to_variable_1;
// 将变量节点1的输出与校验节点0的输入相连
assign value_variable_1_to_check_0 = value_variable_1_to_check;
assign enable_variable_1_to_check_0 = enable_variable_1_to_check;
// 对校验节点2传递过来的数据进行整合
assign value_check_to_variable_1[11:6] = value_check_2_to_variable_1;
assign enable_check_to_variable_1[1] = enable_check_2_to_variable_1;
// 将变量节点1的输出与校验节点2的输入相连
assign value_variable_1_to_check_2 = value_variable_1_to_check;
assign enable_variable_1_to_check_2 = enable_variable_1_to_check;
// 对校验节点5传递过来的数据进行整合
assign value_check_to_variable_1[17:12] = value_check_5_to_variable_1;
assign enable_check_to_variable_1[2] = enable_check_5_to_variable_1;
// 将变量节点1的输出与校验节点5的输入相连
assign value_variable_1_to_check_5 = value_variable_1_to_check;
assign enable_variable_1_to_check_5 = enable_variable_1_to_check;

// 变量节点2的接口
wire [17:0] value_check_to_variable_2;
wire [2:0] enable_check_to_variable_2;
wire [5:0] value_variable_2_to_check;
wire enable_variable_2_to_check;
// 对校验节点2传递过来的数据进行整合
assign value_check_to_variable_2[5:0] = value_check_2_to_variable_2;
assign enable_check_to_variable_2[0] = enable_check_2_to_variable_2;
// 将变量节点2的输出与校验节点2的输入相连
assign value_variable_2_to_check_2 = value_variable_2_to_check;
assign enable_variable_2_to_check_2 = enable_variable_2_to_check;
// 对校验节点3传递过来的数据进行整合
assign value_check_to_variable_2[11:6] = value_check_3_to_variable_2;
assign enable_check_to_variable_2[1] = enable_check_3_to_variable_2;
// 将变量节点2的输出与校验节点3的输入相连
assign value_variable_2_to_check_3 = value_variable_2_to_check;
assign enable_variable_2_to_check_3 = enable_variable_2_to_check;
// 对校验节点5传递过来的数据进行整合
assign value_check_to_variable_2[17:12] = value_check_5_to_variable_2;
assign enable_check_to_variable_2[2] = enable_check_5_to_variable_2;
// 将变量节点2的输出与校验节点5的输入相连
assign value_variable_2_to_check_5 = value_variable_2_to_check;
assign enable_variable_2_to_check_5 = enable_variable_2_to_check;

// 变量节点3的接口
wire [17:0] value_check_to_variable_3;
wire [2:0] enable_check_to_variable_3;
wire [5:0] value_variable_3_to_check;
wire enable_variable_3_to_check;
// 对校验节点3传递过来的数据进行整合
assign value_check_to_variable_3[5:0] = value_check_3_to_variable_3;
assign enable_check_to_variable_3[0] = enable_check_3_to_variable_3;
// 将变量节点3的输出与校验节点3的输入相连
assign value_variable_3_to_check_3 = value_variable_3_to_check;
assign enable_variable_3_to_check_3 = enable_variable_3_to_check;
// 对校验节点4传递过来的数据进行整合
assign value_check_to_variable_3[11:6] = value_check_4_to_variable_3;
assign enable_check_to_variable_3[1] = enable_check_4_to_variable_3;
// 将变量节点3的输出与校验节点4的输入相连
assign value_variable_3_to_check_4 = value_variable_3_to_check;
assign enable_variable_3_to_check_4 = enable_variable_3_to_check;
// 对校验节点5传递过来的数据进行整合
assign value_check_to_variable_3[17:12] = value_check_5_to_variable_3;
assign enable_check_to_variable_3[2] = enable_check_5_to_variable_3;
// 将变量节点3的输出与校验节点5的输入相连
assign value_variable_3_to_check_5 = value_variable_3_to_check;
assign enable_variable_3_to_check_5 = enable_variable_3_to_check;

// 变量节点4的接口
wire [17:0] value_check_to_variable_4;
wire [2:0] enable_check_to_variable_4;
wire [5:0] value_variable_4_to_check;
wire enable_variable_4_to_check;
// 对校验节点2传递过来的数据进行整合
assign value_check_to_variable_4[5:0] = value_check_2_to_variable_4;
assign enable_check_to_variable_4[0] = enable_check_2_to_variable_4;
// 将变量节点4的输出与校验节点2的输入相连
assign value_variable_4_to_check_2 = value_variable_4_to_check;
assign enable_variable_4_to_check_2 = enable_variable_4_to_check;
// 对校验节点3传递过来的数据进行整合
assign value_check_to_variable_4[11:6] = value_check_3_to_variable_4;
assign enable_check_to_variable_4[1] = enable_check_3_to_variable_4;
// 将变量节点4的输出与校验节点3的输入相连
assign value_variable_4_to_check_3 = value_variable_4_to_check;
assign enable_variable_4_to_check_3 = enable_variable_4_to_check;
// 对校验节点4传递过来的数据进行整合
assign value_check_to_variable_4[17:12] = value_check_4_to_variable_4;
assign enable_check_to_variable_4[2] = enable_check_4_to_variable_4;
// 将变量节点4的输出与校验节点4的输入相连
assign value_variable_4_to_check_4 = value_variable_4_to_check;
assign enable_variable_4_to_check_4 = enable_variable_4_to_check;

// 变量节点5的接口
wire [17:0] value_check_to_variable_5;
wire [2:0] enable_check_to_variable_5;
wire [5:0] value_variable_5_to_check;
wire enable_variable_5_to_check;
// 对校验节点0传递过来的数据进行整合
assign value_check_to_variable_5[5:0] = value_check_0_to_variable_5;
assign enable_check_to_variable_5[0] = enable_check_0_to_variable_5;
// 将变量节点5的输出与校验节点0的输入相连
assign value_variable_5_to_check_0 = value_variable_5_to_check;
assign enable_variable_5_to_check_0 = enable_variable_5_to_check;
// 对校验节点2传递过来的数据进行整合
assign value_check_to_variable_5[11:6] = value_check_2_to_variable_5;
assign enable_check_to_variable_5[1] = enable_check_2_to_variable_5;
// 将变量节点5的输出与校验节点2的输入相连
assign value_variable_5_to_check_2 = value_variable_5_to_check;
assign enable_variable_5_to_check_2 = enable_variable_5_to_check;
// 对校验节点4传递过来的数据进行整合
assign value_check_to_variable_5[17:12] = value_check_4_to_variable_5;
assign enable_check_to_variable_5[2] = enable_check_4_to_variable_5;
// 将变量节点5的输出与校验节点4的输入相连
assign value_variable_5_to_check_4 = value_variable_5_to_check;
assign enable_variable_5_to_check_4 = enable_variable_5_to_check;

// 变量节点6的接口
wire [17:0] value_check_to_variable_6;
wire [2:0] enable_check_to_variable_6;
wire [5:0] value_variable_6_to_check;
wire enable_variable_6_to_check;
// 对校验节点0传递过来的数据进行整合
assign value_check_to_variable_6[5:0] = value_check_0_to_variable_6;
assign enable_check_to_variable_6[0] = enable_check_0_to_variable_6;
// 将变量节点6的输出与校验节点0的输入相连
assign value_variable_6_to_check_0 = value_variable_6_to_check;
assign enable_variable_6_to_check_0 = enable_variable_6_to_check;
// 对校验节点2传递过来的数据进行整合
assign value_check_to_variable_6[11:6] = value_check_2_to_variable_6;
assign enable_check_to_variable_6[1] = enable_check_2_to_variable_6;
// 将变量节点6的输出与校验节点2的输入相连
assign value_variable_6_to_check_2 = value_variable_6_to_check;
assign enable_variable_6_to_check_2 = enable_variable_6_to_check;
// 对校验节点5传递过来的数据进行整合
assign value_check_to_variable_6[17:12] = value_check_5_to_variable_6;
assign enable_check_to_variable_6[2] = enable_check_5_to_variable_6;
// 将变量节点6的输出与校验节点5的输入相连
assign value_variable_6_to_check_5 = value_variable_6_to_check;
assign enable_variable_6_to_check_5 = enable_variable_6_to_check;

// 变量节点7的接口
wire [17:0] value_check_to_variable_7;
wire [2:0] enable_check_to_variable_7;
wire [5:0] value_variable_7_to_check;
wire enable_variable_7_to_check;
// 对校验节点1传递过来的数据进行整合
assign value_check_to_variable_7[5:0] = value_check_1_to_variable_7;
assign enable_check_to_variable_7[0] = enable_check_1_to_variable_7;
// 将变量节点7的输出与校验节点1的输入相连
assign value_variable_7_to_check_1 = value_variable_7_to_check;
assign enable_variable_7_to_check_1 = enable_variable_7_to_check;
// 对校验节点4传递过来的数据进行整合
assign value_check_to_variable_7[11:6] = value_check_4_to_variable_7;
assign enable_check_to_variable_7[1] = enable_check_4_to_variable_7;
// 将变量节点7的输出与校验节点4的输入相连
assign value_variable_7_to_check_4 = value_variable_7_to_check;
assign enable_variable_7_to_check_4 = enable_variable_7_to_check;
// 对校验节点5传递过来的数据进行整合
assign value_check_to_variable_7[17:12] = value_check_5_to_variable_7;
assign enable_check_to_variable_7[2] = enable_check_5_to_variable_7;
// 将变量节点7的输出与校验节点5的输入相连
assign value_variable_7_to_check_5 = value_variable_7_to_check;
assign enable_variable_7_to_check_5 = enable_variable_7_to_check;

// 变量节点8的接口
wire [17:0] value_check_to_variable_8;
wire [2:0] enable_check_to_variable_8;
wire [5:0] value_variable_8_to_check;
wire enable_variable_8_to_check;
// 对校验节点1传递过来的数据进行整合
assign value_check_to_variable_8[5:0] = value_check_1_to_variable_8;
assign enable_check_to_variable_8[0] = enable_check_1_to_variable_8;
// 将变量节点8的输出与校验节点1的输入相连
assign value_variable_8_to_check_1 = value_variable_8_to_check;
assign enable_variable_8_to_check_1 = enable_variable_8_to_check;
// 对校验节点3传递过来的数据进行整合
assign value_check_to_variable_8[11:6] = value_check_3_to_variable_8;
assign enable_check_to_variable_8[1] = enable_check_3_to_variable_8;
// 将变量节点8的输出与校验节点3的输入相连
assign value_variable_8_to_check_3 = value_variable_8_to_check;
assign enable_variable_8_to_check_3 = enable_variable_8_to_check;
// 对校验节点4传递过来的数据进行整合
assign value_check_to_variable_8[17:12] = value_check_4_to_variable_8;
assign enable_check_to_variable_8[2] = enable_check_4_to_variable_8;
// 将变量节点8的输出与校验节点4的输入相连
assign value_variable_8_to_check_4 = value_variable_8_to_check;
assign enable_variable_8_to_check_4 = enable_variable_8_to_check;

// 变量节点9的接口
wire [17:0] value_check_to_variable_9;
wire [2:0] enable_check_to_variable_9;
wire [5:0] value_variable_9_to_check;
wire enable_variable_9_to_check;
// 对校验节点0传递过来的数据进行整合
assign value_check_to_variable_9[5:0] = value_check_0_to_variable_9;
assign enable_check_to_variable_9[0] = enable_check_0_to_variable_9;
// 将变量节点9的输出与校验节点0的输入相连
assign value_variable_9_to_check_0 = value_variable_9_to_check;
assign enable_variable_9_to_check_0 = enable_variable_9_to_check;
// 对校验节点1传递过来的数据进行整合
assign value_check_to_variable_9[11:6] = value_check_1_to_variable_9;
assign enable_check_to_variable_9[1] = enable_check_1_to_variable_9;
// 将变量节点9的输出与校验节点1的输入相连
assign value_variable_9_to_check_1 = value_variable_9_to_check;
assign enable_variable_9_to_check_1 = enable_variable_9_to_check;
// 对校验节点5传递过来的数据进行整合
assign value_check_to_variable_9[17:12] = value_check_5_to_variable_9;
assign enable_check_to_variable_9[2] = enable_check_5_to_variable_9;
// 将变量节点9的输出与校验节点5的输入相连
assign value_variable_9_to_check_5 = value_variable_9_to_check;
assign enable_variable_9_to_check_5 = enable_variable_9_to_check;

// 变量节点10的接口
wire [17:0] value_check_to_variable_10;
wire [2:0] enable_check_to_variable_10;
wire [5:0] value_variable_10_to_check;
wire enable_variable_10_to_check;
// 对校验节点0传递过来的数据进行整合
assign value_check_to_variable_10[5:0] = value_check_0_to_variable_10;
assign enable_check_to_variable_10[0] = enable_check_0_to_variable_10;
// 将变量节点10的输出与校验节点0的输入相连
assign value_variable_10_to_check_0 = value_variable_10_to_check;
assign enable_variable_10_to_check_0 = enable_variable_10_to_check;
// 对校验节点1传递过来的数据进行整合
assign value_check_to_variable_10[11:6] = value_check_1_to_variable_10;
assign enable_check_to_variable_10[1] = enable_check_1_to_variable_10;
// 将变量节点10的输出与校验节点1的输入相连
assign value_variable_10_to_check_1 = value_variable_10_to_check;
assign enable_variable_10_to_check_1 = enable_variable_10_to_check;
// 对校验节点4传递过来的数据进行整合
assign value_check_to_variable_10[17:12] = value_check_4_to_variable_10;
assign enable_check_to_variable_10[2] = enable_check_4_to_variable_10;
// 将变量节点10的输出与校验节点4的输入相连
assign value_variable_10_to_check_4 = value_variable_10_to_check;
assign enable_variable_10_to_check_4 = enable_variable_10_to_check;

// 变量节点11的接口
wire [17:0] value_check_to_variable_11;
wire [2:0] enable_check_to_variable_11;
wire [5:0] value_variable_11_to_check;
wire enable_variable_11_to_check;
// 对校验节点0传递过来的数据进行整合
assign value_check_to_variable_11[5:0] = value_check_0_to_variable_11;
assign enable_check_to_variable_11[0] = enable_check_0_to_variable_11;
// 将变量节点11的输出与校验节点0的输入相连
assign value_variable_11_to_check_0 = value_variable_11_to_check;
assign enable_variable_11_to_check_0 = enable_variable_11_to_check;
// 对校验节点1传递过来的数据进行整合
assign value_check_to_variable_11[11:6] = value_check_1_to_variable_11;
assign enable_check_to_variable_11[1] = enable_check_1_to_variable_11;
// 将变量节点11的输出与校验节点1的输入相连
assign value_variable_11_to_check_1 = value_variable_11_to_check;
assign enable_variable_11_to_check_1 = enable_variable_11_to_check;
// 对校验节点3传递过来的数据进行整合
assign value_check_to_variable_11[17:12] = value_check_3_to_variable_11;
assign enable_check_to_variable_11[2] = enable_check_3_to_variable_11;
// 将变量节点11的输出与校验节点3的输入相连
assign value_variable_11_to_check_3 = value_variable_11_to_check;
assign enable_variable_11_to_check_3 = enable_variable_11_to_check;

// 校验节点0
Check_Node #(.weight(6),.length(6)) u_Check_Node_0(
.clk(clk),
.rst(rst),
.check_begin(check_begin),
.variable_value_input(value_check_to_variable_0),
.variable_enable_input(enable_check_to_variable_0),
.decision_down(),
.decision_success(),
.decision_down_receive(),
.check_value_output(value_variable_0_to_check),
.check_enable_output(enable_variable_0_to_check)
);

// 校验节点1
Check_Node #(.weight(6),.length(6)) u_Check_Node_1(
.clk(clk),
.rst(rst),
.check_begin(check_begin),
.variable_value_input(value_check_to_variable_1),
.variable_enable_input(enable_check_to_variable_1),
.decision_down(),
.decision_success(),
.decision_down_receive(),
.check_value_output(value_variable_1_to_check),
.check_enable_output(enable_variable_1_to_check)
);

// 校验节点2
Check_Node #(.weight(6),.length(6)) u_Check_Node_2(
.clk(clk),
.rst(rst),
.check_begin(check_begin),
.variable_value_input(value_check_to_variable_2),
.variable_enable_input(enable_check_to_variable_2),
.decision_down(),
.decision_success(),
.decision_down_receive(),
.check_value_output(value_variable_2_to_check),
.check_enable_output(enable_variable_2_to_check)
);

// 校验节点3
Check_Node #(.weight(6),.length(6)) u_Check_Node_3(
.clk(clk),
.rst(rst),
.check_begin(check_begin),
.variable_value_input(value_check_to_variable_3),
.variable_enable_input(enable_check_to_variable_3),
.decision_down(),
.decision_success(),
.decision_down_receive(),
.check_value_output(value_variable_3_to_check),
.check_enable_output(enable_variable_3_to_check)
);

// 校验节点4
Check_Node #(.weight(6),.length(6)) u_Check_Node_4(
.clk(clk),
.rst(rst),
.check_begin(check_begin),
.variable_value_input(value_check_to_variable_4),
.variable_enable_input(enable_check_to_variable_4),
.decision_down(),
.decision_success(),
.decision_down_receive(),
.check_value_output(value_variable_4_to_check),
.check_enable_output(enable_variable_4_to_check)
);

// 校验节点5
Check_Node #(.weight(6),.length(6)) u_Check_Node_5(
.clk(clk),
.rst(rst),
.check_begin(check_begin),
.variable_value_input(value_check_to_variable_5),
.variable_enable_input(enable_check_to_variable_5),
.decision_down(),
.decision_success(),
.decision_down_receive(),
.check_value_output(value_variable_5_to_check),
.check_enable_output(enable_variable_5_to_check)
);


// 变量节点0
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_0(
.clk(clk),
.rst(rst),
.initial_value(initial_value[0]),
.initial_value_enable(initial_value_enable[0]),
.initial_down(initial_down[0]),
.check_value_input(value_check_to_variable_0),
.check_enable_input(enable_check_to_variable_0),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_0_to_check),
.variable_enable(enable_variable_0_to_check)
);

// 变量节点1
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_1(
.clk(clk),
.rst(rst),
.initial_value(initial_value[1]),
.initial_value_enable(initial_value_enable[1]),
.initial_down(initial_down[1]),
.check_value_input(value_check_to_variable_1),
.check_enable_input(enable_check_to_variable_1),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_1_to_check),
.variable_enable(enable_variable_1_to_check)
);

// 变量节点2
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_2(
.clk(clk),
.rst(rst),
.initial_value(initial_value[2]),
.initial_value_enable(initial_value_enable[2]),
.initial_down(initial_down[2]),
.check_value_input(value_check_to_variable_2),
.check_enable_input(enable_check_to_variable_2),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_2_to_check),
.variable_enable(enable_variable_2_to_check)
);

// 变量节点3
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_3(
.clk(clk),
.rst(rst),
.initial_value(initial_value[3]),
.initial_value_enable(initial_value_enable[3]),
.initial_down(initial_down[3]),
.check_value_input(value_check_to_variable_3),
.check_enable_input(enable_check_to_variable_3),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_3_to_check),
.variable_enable(enable_variable_3_to_check)
);

// 变量节点4
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_4(
.clk(clk),
.rst(rst),
.initial_value(initial_value[4]),
.initial_value_enable(initial_value_enable[4]),
.initial_down(initial_down[4]),
.check_value_input(value_check_to_variable_4),
.check_enable_input(enable_check_to_variable_4),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_4_to_check),
.variable_enable(enable_variable_4_to_check)
);

// 变量节点5
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_5(
.clk(clk),
.rst(rst),
.initial_value(initial_value[5]),
.initial_value_enable(initial_value_enable[5]),
.initial_down(initial_down[5]),
.check_value_input(value_check_to_variable_5),
.check_enable_input(enable_check_to_variable_5),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_5_to_check),
.variable_enable(enable_variable_5_to_check)
);

// 变量节点6
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_6(
.clk(clk),
.rst(rst),
.initial_value(initial_value[6]),
.initial_value_enable(initial_value_enable[6]),
.initial_down(initial_down[6]),
.check_value_input(value_check_to_variable_6),
.check_enable_input(enable_check_to_variable_6),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_6_to_check),
.variable_enable(enable_variable_6_to_check)
);

// 变量节点7
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_7(
.clk(clk),
.rst(rst),
.initial_value(initial_value[7]),
.initial_value_enable(initial_value_enable[7]),
.initial_down(initial_down[7]),
.check_value_input(value_check_to_variable_7),
.check_enable_input(enable_check_to_variable_7),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_7_to_check),
.variable_enable(enable_variable_7_to_check)
);

// 变量节点8
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_8(
.clk(clk),
.rst(rst),
.initial_value(initial_value[8]),
.initial_value_enable(initial_value_enable[8]),
.initial_down(initial_down[8]),
.check_value_input(value_check_to_variable_8),
.check_enable_input(enable_check_to_variable_8),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_8_to_check),
.variable_enable(enable_variable_8_to_check)
);

// 变量节点9
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_9(
.clk(clk),
.rst(rst),
.initial_value(initial_value[9]),
.initial_value_enable(initial_value_enable[9]),
.initial_down(initial_down[9]),
.check_value_input(value_check_to_variable_9),
.check_enable_input(enable_check_to_variable_9),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_9_to_check),
.variable_enable(enable_variable_9_to_check)
);

// 变量节点10
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_10(
.clk(clk),
.rst(rst),
.initial_value(initial_value[10]),
.initial_value_enable(initial_value_enable[10]),
.initial_down(initial_down[10]),
.check_value_input(value_check_to_variable_10),
.check_enable_input(enable_check_to_variable_10),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_10_to_check),
.variable_enable(enable_variable_10_to_check)
);

// 变量节点11
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_11(
.clk(clk),
.rst(rst),
.initial_value(initial_value[11]),
.initial_value_enable(initial_value_enable[11]),
.initial_down(initial_down[11]),
.check_value_input(value_check_to_variable_11),
.check_enable_input(enable_check_to_variable_11),
.decision_down(decision_down),
.decoder_down(decoder_down),
.variable_value(value_variable_11_to_check),
.variable_enable(enable_variable_11_to_check)
);



always@(*)begin
    // 调制结束，开始进行译码
    if(demodulation_down_to_decoder)begin
        initial_value_enable = 0-1;
    end
    else begin
        initial_value_enable = 0;
    end
    // 所有变量节点在初始化的时候信号是一致的，所以只需要对第一个变量节点进行讨论就行
    if(initial_down[0])begin
        demodulation_to_decoder_receive = 1;
    end
    else begin
        demodulation_to_decoder_receive = 0;
    end
end

// 校验部分与变量节点和校验节点的交互
always@(*)begin
    // 如果校验失败且迭代次数未到最大值,开始进行校验节点的更新
    if(decision_down & ~decision_success & ~decision_time_max) begin
        /*check_begin 可以是一位也可以是多位,看后面优化的时候怎么说*/
        check_begin = 1;
    end
    // 如果发现迭代次数到达最大值或者校验成功，那么译码结束
    if(decision_time_max || decision_success) begin
        /*这个也是,到底是一位还是多位优化时再考虑*/
        decoder_down = 1;
    end
end
// 将变量节点的enable值全部合并一下
assign decision_variable_enable[0] = enable_variable_0_to_check;
assign decision_variable_enable[1] = enable_variable_1_to_check;
assign decision_variable_enable[2] = enable_variable_2_to_check;
assign decision_variable_enable[3] = enable_variable_3_to_check;
assign decision_variable_enable[4] = enable_variable_4_to_check;
assign decision_variable_enable[5] = enable_variable_5_to_check;
assign decision_variable_enable[6] = enable_variable_6_to_check;
assign decision_variable_enable[7] = enable_variable_7_to_check;
assign decision_variable_enable[8] = enable_variable_8_to_check;
assign decision_variable_enable[9] = enable_variable_9_to_check;
assign decision_variable_enable[10] = enable_variable_10_to_check;
assign decision_variable_enable[11] = enable_variable_11_to_check;

integer i;
always@(posedge clk or negedge rst)begin
if(~rst)begin
i <= 0;
decision_state <= 0;
decision_down <= 0;
decision_success <= 0;
decision_information <= 0;
decision_times <= 0;
decision_result <= 0;
decision_time_max <= 0;
end
else begin
case(decision_state)
3'd0: begin
// 如果发现变量节点全部更新完毕,将变量节点的值进行判决然后计算
if(~decision_variable_enable == 0) begin
decision_information[0] <= value_variable_0_to_check;
decision_information[1] <= value_variable_1_to_check;
decision_information[2] <= value_variable_2_to_check;
decision_information[3] <= value_variable_3_to_check;
decision_information[4] <= value_variable_4_to_check;
decision_information[5] <= value_variable_5_to_check;
decision_information[6] <= value_variable_6_to_check;
decision_information[7] <= value_variable_7_to_check;
decision_information[8] <= value_variable_8_to_check;
decision_information[9] <= value_variable_9_to_check;
decision_information[10] <= value_variable_10_to_check;
decision_information[11] <= value_variable_11_to_check;
// 变更状态，开始进行校验
decision_state <= 3'd1;
end
end

// 开始校验
3'd1: begin
    // 一个周期完成校验
decision_result[0] <= decision_information[1] ^ decision_information[5] ^ decision_information[6] ^ decision_information[9] ^ decision_information[10] ^ decision_information[11];
decision_result[1] <= decision_information[0] ^ decision_information[7] ^ decision_information[8] ^ decision_information[9] ^ decision_information[10] ^ decision_information[11];
decision_result[2] <= decision_information[0] ^ decision_information[1] ^ decision_information[2] ^ decision_information[4] ^ decision_information[5] ^ decision_information[6];
decision_result[3] <= decision_information[0] ^ decision_information[2] ^ decision_information[3] ^ decision_information[4] ^ decision_information[8] ^ decision_information[11];
decision_result[4] <= decision_information[3] ^ decision_information[4] ^ decision_information[5] ^ decision_information[7] ^ decision_information[8] ^ decision_information[10];
decision_result[5] <= decision_information[1] ^ decision_information[2] ^ decision_information[3] ^ decision_information[6] ^ decision_information[7] ^ decision_information[9];

    decision_state <= 3'd2;
end

3'd2: begin
    // 校验成功
    if(decision_result == 0)begin
        decision_down <= 1;
        decision_success <= 1;
        // 让校验成功信号多保持一个周期
        decision_state <= 3'd4;
    end
    //此次校验没有成功
    else begin
        decision_down <= 1;
        decision_success <= 0;
        if(decision_times == 50) begin

            decision_time_max <= 1;
            decision_state <= 3'd4;
        end
        else begin 
            decision_times <= decision_times+1;
            decision_state <= 3'd3;
        end
    end
end

3'd3: begin
    decision_down <= 0;
    decision_time_max <= 0;
    decision_success <= 0;
    decision_state <= 3'd0;
end

// 拖延一周期时间
3'd4: begin
    decision_times <= 0;
    decision_state <= 3'd3;
end

endcase
end
end
endmodule
