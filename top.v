
module top(
input clk,
input rst,
input initial_value_0,
input initial_value_1,
input initial_value_2,
input initial_value_3,
input initial_value_4,
input initial_value_5,
input initial_value_6,
input initial_value_7,
input initial_value_8,
input initial_value_9,
input initial_value_10,
input initial_value_11,
output reg decoder_finish
);

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
.check_begin(),
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
.check_begin(),
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
.check_begin(),
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
.check_begin(),
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
.check_begin(),
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
.check_begin(),
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
.initial_value(initial_value_0),
.check_value_input(value_check_to_variable_0),
.check_enable_input(enable_check_to_variable_0),
.decision_down(),
.variable_value(value_variable_0_to_check),
.variable_enable(enable_variable_0_to_check)
);

// 变量节点1
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_1(
.clk(clk),
.rst(rst),
.initial_value(initial_value_1),
.check_value_input(value_check_to_variable_1),
.check_enable_input(enable_check_to_variable_1),
.decision_down(),
.variable_value(value_variable_1_to_check),
.variable_enable(enable_variable_1_to_check)
);

// 变量节点2
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_2(
.clk(clk),
.rst(rst),
.initial_value(initial_value_2),
.check_value_input(value_check_to_variable_2),
.check_enable_input(enable_check_to_variable_2),
.decision_down(),
.variable_value(value_variable_2_to_check),
.variable_enable(enable_variable_2_to_check)
);

// 变量节点3
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_3(
.clk(clk),
.rst(rst),
.initial_value(initial_value_3),
.check_value_input(value_check_to_variable_3),
.check_enable_input(enable_check_to_variable_3),
.decision_down(),
.variable_value(value_variable_3_to_check),
.variable_enable(enable_variable_3_to_check)
);

// 变量节点4
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_4(
.clk(clk),
.rst(rst),
.initial_value(initial_value_4),
.check_value_input(value_check_to_variable_4),
.check_enable_input(enable_check_to_variable_4),
.decision_down(),
.variable_value(value_variable_4_to_check),
.variable_enable(enable_variable_4_to_check)
);

// 变量节点5
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_5(
.clk(clk),
.rst(rst),
.initial_value(initial_value_5),
.check_value_input(value_check_to_variable_5),
.check_enable_input(enable_check_to_variable_5),
.decision_down(),
.variable_value(value_variable_5_to_check),
.variable_enable(enable_variable_5_to_check)
);

// 变量节点6
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_6(
.clk(clk),
.rst(rst),
.initial_value(initial_value_6),
.check_value_input(value_check_to_variable_6),
.check_enable_input(enable_check_to_variable_6),
.decision_down(),
.variable_value(value_variable_6_to_check),
.variable_enable(enable_variable_6_to_check)
);

// 变量节点7
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_7(
.clk(clk),
.rst(rst),
.initial_value(initial_value_7),
.check_value_input(value_check_to_variable_7),
.check_enable_input(enable_check_to_variable_7),
.decision_down(),
.variable_value(value_variable_7_to_check),
.variable_enable(enable_variable_7_to_check)
);

// 变量节点8
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_8(
.clk(clk),
.rst(rst),
.initial_value(initial_value_8),
.check_value_input(value_check_to_variable_8),
.check_enable_input(enable_check_to_variable_8),
.decision_down(),
.variable_value(value_variable_8_to_check),
.variable_enable(enable_variable_8_to_check)
);

// 变量节点9
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_9(
.clk(clk),
.rst(rst),
.initial_value(initial_value_9),
.check_value_input(value_check_to_variable_9),
.check_enable_input(enable_check_to_variable_9),
.decision_down(),
.variable_value(value_variable_9_to_check),
.variable_enable(enable_variable_9_to_check)
);

// 变量节点10
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_10(
.clk(clk),
.rst(rst),
.initial_value(initial_value_10),
.check_value_input(value_check_to_variable_10),
.check_enable_input(enable_check_to_variable_10),
.decision_down(),
.variable_value(value_variable_10_to_check),
.variable_enable(enable_variable_10_to_check)
);

// 变量节点11
Variable_Node #(.weight(3), .length(6)) u_Variable_Node_11(
.clk(clk),
.rst(rst),
.initial_value(initial_value_11),
.check_value_input(value_check_to_variable_11),
.check_enable_input(enable_check_to_variable_11),
.decision_down(),
.variable_value(value_variable_11_to_check),
.variable_enable(enable_variable_11_to_check)
);


endmodule