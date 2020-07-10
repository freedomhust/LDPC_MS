'''
生成top.v,用于变量节点与校验节点之间的连接
'''

file_path_row = r'H:\\LDPC_MS\\row.txt'
file_path_column = r'H:\\LDPC_MS\\column.txt'
row_number = 6
column_number = 12
row_weight = 6
column_weight = 3
length = 6

# 单次译码过程中，迭代的最大次数
decision_time_max = 50

top_file = r'H:\\LDPC_MS\\Decoder.v'
string = '''
module Decoder(
input clk,
input rst,
input demodulation_down_to_decoder,
output reg demodulation_to_decoder_receive,
// 解调后的数据
'''
# 解调后的数据
string += f'input [{length*column_number-1}:0] initial_value_input,\n'
string += f'// 初始比特流\n'
string += f'input [{column_number-1}:0] demodulation_sequence,\n'
string += f'// 输出初始的信息序列\n'
string += f'output reg [{column_number-1}:0] prototype_sequence,\n'
string += f'// 译码过后的信息序列，用于计算误比特率\n'
string += f'output reg [{column_number-1}:0] decision_information,\n'
string += f'output reg decoder_down\n);\n'

# 先将top模块的接口定义了
with open(top_file,'w',encoding='utf-8') as f:
    f.write(string)

# 对initial_value进行拆分
string = ''
string += '// 对initial_value进行拆分\n'
string += f'wire [{length-1}:0] initial_value[{column_number-1}:0];\n'
for i in range(column_number):
    string += f'assign initial_value[{i}] = initial_value_input[{(i+1)*length-1}:{i*length}];\n'
string += '\n\n'
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)

# 定义跟判决部分有关的变量
string = ''
string += '// 定义跟判决部分有关的变量\n'
string += f'reg [{column_number-1}:0]initial_value_enable;\n'
string += f'wire [{column_number-1}:0]initial_down;\n'
string += f'reg check_begin;\n'
string += f'reg [2:0] decision_state;\n'
string += f'reg decision_down;\n'
string += f'reg decision_success;\n'
string += f'reg [9:0] decision_times;\n'
string += f'reg [{column_number-1}:0]decision_result;\n'
string += f'reg decision_time_max;\n'
string += f'wire [{column_number-1}:0]decision_variable_enable;\n\n\n'
with open(top_file,'a',encoding='utf-8') as f:
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
            string += f'// 对校验节点{index}的输出值进行拆分\n'
            string += f'assign value_check_{index}_to_variable_{row_list[i+1]} = value_check_{index}_to_variable[{length*(i+1)-1}:{length*i}];\n'
            string += f'assign enable_check_{index}_to_variable_{row_list[i+1]} = enable_check_{index}_to_variable[{i}];\n'
            # 对变量节点传递过来的值进行组合
            string += f'// 对变量节点{row_list[i+1]}传递过来的值进行组合\n'
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
        string += f'.check_begin(check_begin),\n'
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
        string += f'.initial_value(initial_value[{index}]),\n'
        string += f'.initial_value_enable(initial_value_enable[{index}]),\n'
        string += f'.initial_down(initial_down[{index}]),\n'
        string += f'.check_value_input(value_check_to_variable_{index}),\n'
        string += f'.check_enable_input(enable_check_to_variable_{index}),\n'
        string += f'.decision_down(decision_down),\n'
        string += f'.decoder_down(decoder_down),\n'
        string += f'.variable_value(value_variable_{index}_to_check),\n'
        string += f'.variable_enable(enable_variable_{index}_to_check)\n'
        string += f');\n\n'
    string += '\n'
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)


# 和外面的解调部分交互的逻辑
string = ''
string += '''
always@(*)begin
    // 调制结束，开始进行译码
    if(demodulation_down_to_decoder)begin
        prototype_sequence <= demodulation_sequence;
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
'''
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)


# 校验部分与变量节点和校验节点的交互
string = ''
string += '''
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
    else decoder_down = 0;
end
'''
with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)


# 校验部分
string = ''
string += '// 将变量节点的enable值全部合并一下\n'
for i in range(column_number):
    string += f'assign decision_variable_enable[{i}] = enable_variable_{i}_to_check;\n'
string += '''
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
'''
for i in range(column_number):
    string += f'decision_information[{i}] <= value_variable_{i}_to_check;\n'
string += f'// 变更状态，开始进行校验\n'
string += "decision_state <= 3'd1;\n"
string += 'end\nend\n'

string += '''
// 开始校验
3'd1: begin
    // 一个周期完成校验
'''

# 打开row.txt,找到对应的比特进行校验
with open(file_path_row,'r') as f_row:
    lines = f_row.readlines()
    for index,row in enumerate(lines):
        row_list = row.split(' ')
        row_weight = row_list[0]
        string += f'decision_result[{index}] <= '
        for i in range(int(row_weight)):
            if(i == int(row_weight)-1):
                string += f'decision_information[{row_list[i+1]}];\n'
            else:
                string += f'decision_information[{row_list[i+1]}] ^ '

string += '''
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
'''

string += f'        if(decision_times == {decision_time_max}) begin\n'

string += '''
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

'''



with open(top_file,'a',encoding='utf-8') as f:
    f.write(string)
    f.write('endcase\n')
    f.write('end\n')
    f.write('end\n')
    f.write('endmodule\n')