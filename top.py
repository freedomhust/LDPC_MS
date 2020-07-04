'''
生成top.v,用于变量节点与校验节点之间的连接
'''

file_path_row = r'H:\\LDPC_MS\\row.txt'
file_path_column = r'H:\\LDPC_MS\\column.txt'
row = 6
column = 12
row_weight = 6
column_weight = 3
length = 6


top_file = r'H:\\LDPC_MS\\top.v'
string = '''
module top(
input clk,
input rst,
'''

# 先将top模块的接口定义了
with open(top_file,'w',encoding='utf-8') as f:
    f.write(string)
    for index in range(column):
        string = f'input initial_value_{index},\n'
        f.write(string)
    string = 'output reg decoder_finish\n);\n'
    f.write(string)


# 打开row.txt,定义相关的变量
string = ''
with open(file_path_row,'r') as f_row:
    lines = f_row.readlines()
    for index,row in enumerate(lines):
        row_list = row.split(' ')
        row_weight = row_list[0]
        print(row_list)
        # 当前行所代表的校验节点接收到所有变量节点值
        string += f'// 校验节点{index}的接口\n'
        string += f'wire [{length*int(row_weight) - 1}:0] value_variable_to_check_{index};\n'
        string += f'wire [{length*int(row_weight) - 1}:0] value_check_{index}_to_variable;\n'
        string += f'wire [{int(row_weight)-1}:0] enable_variable_to_check_{index};\n'
        string += f'wire [{int(row_weight)-1}:0] enable_check_{index}_to_variable;\n'
        for i in range(int(row_weight)):
            string += f'// 拆分后校验节点{index}传递给变量节点{row_list[i+1]}的值以及对变量节点{row_list[i+1]}传递过来的值\n'
            string += f'wire [{length-1}:0] value_check_{index}_to_variable_{row_list[i+1]};\n'
            string += f'wire enable_check_{index}_to_variable_{row_list[i+1]};\n'
            string += f'wire [{length-1}:0] value_variable_{row_list[i+1]}_to_check_{index};\n'
            string += f'wire enable_variable_{row_list[i+1]}_to_check_{index};\n'
            # 将校验节点的输出值进行拆分
            string += f'// 对校验节点的输出值进行拆分\n'
            string += f'assign value_check_{index}_to_variable_{row_list[i+1]} = value_check_{index}_to_variable[{length*(i+1)-1}:{length*i}];\n'
            string += f'assign enable_check_{index}_to_variable_{row_list[i+1]} = enable_check_{index}_to_variable[{i}];\n'
            # 对变量节点传递过来的值进行组合
            string += f'// 对变量节点传递过来的值进行组合\n'
            string += f'assign value_variable_to_check_{index}[{length*(i+1)-1}:{length*i}] = value_variable_{row_list[i+1]}_to_check_{index};\n'
            string += f'assign enable_variable_to_check_{index}[{i}] = enable_variable_{row_list[i+1]}_to_check_{index};\n'
        string += '\n'
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)


# 打开column.txt,定义相关的变量
string = ''
with open(file_path_column,'r') as f_column:
    lines = f_column.readlines()
    for index,column in enumerate(lines):
        column_list = column.split(' ')
        column_weight = column_list[0]
        print(column_list)
        # 变量节点的接口
        string += f'// 变量节点{index}的接口\n'
        string += f'wire [{int(column_weight)*length-1}:0] value_check_to_variable_{index};\n'
        string += f'wire [{int(column_weight)-1}:0] enable_check_to_variable_{index};\n'
        string += f'wire [{length-1}:0] value_variable_{index}_to_check;\n'
        string += f'wire enable_variable_{index}_to_check;\n'
        for i in range(int(column_weight)):
            # 对校验节点传递过来的数据进行整合
            string += f'// 对校验节点{column_list[i+1]}传递过来的数据进行整合\n'
            string += f'assign value_check_to_variable_{index}[{length*(i+1)-1}:{length*i}] = value_check_{column_list[i+1]}_to_variable_{index};\n'
            string += f'assign enable_check_to_variable_{index}[{i}] = enable_check_{column_list[i+1]}_to_variable_{index};\n'
            string += f'// 将变量节点{index}的输出与校验节点{column_list[i+1]}的输入相连\n'
            string += f'assign value_variable_{index}_to_check_{column_list[i+1]} = value_variable_{index}_to_check;\n'
            string += f'assign enable_variable_{index}_to_check_{column_list[i+1]} = enable_variable_{index}_to_check;\n'
        string += f'\n'
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)

# 再次打开row.txt,开始实例化校验节点模块
string = ''
with open(file_path_row,'r') as f_row:
    lines = f_row.readlines()
    for index,row in enumerate(lines):
        string += f'// 校验节点{index}\n'
        string += f'Check_Node #(.weight({row_weight}),.length({length})) u_Check_Node_{index}(\n.clk(clk),\n.rst(rst),\n'
        string += f'.check_begin(),\n'
        string += f'.variable_value_input(value_check_to_variable_{index}),\n'
        string += f'.variable_enable_input(enable_check_to_variable_{index}),\n'
        string += f'.decision_down(),\n'
        string += f'.decision_success(),\n'
        string += f'.decision_down_receive(),\n'
        string += f'.check_value_output(value_variable_{index}_to_check),\n'
        string += f'.check_enable_output(enable_variable_{index}_to_check)\n);\n\n'
    string += '\n'
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)

# 再次打开column.txt,开始实例化变量节点模块
string = ''
with open(file_path_column,'r') as f_column:
    lines = f_column.readlines()
    for index,column in enumerate(lines):
        string += f'// 变量节点{index}\n'
        string += f'Variable_Node #(.weight({column_weight}), .length({length})) u_Variable_Node_{index}(\n.clk(clk),\n.rst(rst),\n'
        string += f'.initial_value(initial_value_{index}),\n'
        string += f'.check_value_input(value_check_to_variable_{index}),\n'
        string += f'.check_enable_input(enable_check_to_variable_{index}),\n'
        string += f'.decision_down(),\n'
        string += f'.variable_value(value_variable_{index}_to_check),\n'
        string += f'.variable_enable(enable_variable_{index}_to_check)\n'
        string += f');\n\n'
    string += '\n'
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)

# 校验部分
string = ''
string += '// 将变量节点的enable值全部合并一下'
for i in range(column):
    string += f'assign decision_variable_enable[{i}] = enable_variable_{i}_to_check;\n'
string += '''
always@(posedge clk or negedge rst)begin
if(~rst)begin
decision_state <= 0;
decision_down <= 0;
decision_success <= 0;
decision_information <= 0;
end
else begin
case(decision_state)
1'b0: begin
if( 
'''


with open(top_file,'a',encoding='utf-8') as f:
    f.write('endmodule')