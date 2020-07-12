'''
description : 将H矩阵变换成更简约的形式，便于top.py使用
author name : neidong_fu
created time: 2020/7/3
'''

import os
import sys

# 这里的参数可以考虑写一个profile.txt来进行配置
file_path = 'H:\\LDPC_MS\\H_matrix\\reverse\\H_matrix_1024_512.txt'
file_path_row = 'H:\\LDPC_MS\\H_matrix\\reverse\\row_1024_512.txt'
file_path_column = 'H:\\LDPC_MS\\H_matrix\\reverse\\column_1024_512.txt'
columns = []
rows = []

# 判断文件是否存在
if(os.path.exists(file_path) == False):
    print(f"{file_path} doesn't exist !")
    exit()

# 删除之前存在的文件
if(os.path.exists(file_path_row)):
    os.remove(file_path_row)

# open(file_path_row,'w')

if(os.path.exists(file_path_column)):
    os.remove(file_path_column)

# open(file_path_column,'w')

with open(file_path,'r') as f:
    lines = f.readlines()
    # print(lines)
    # 计算该行有多少个1
    for index,row in enumerate(lines):
        columns = []
        for i,column in enumerate(row):
            if(column == '1'):
                columns.append(str(i))
        with open(file_path_row,'a') as f_row:
            print(columns)
            f_row.write(str(len(columns)))
            f_row.write(' ')
            for j in columns:
                f_row.write(j)
                f_row.write(' ')
            f_row.write('\n')
    # print(lines[0])
    column_length = len(lines[0])-1
    row_length = len(lines)
    # print(column_length,row_length)

    # 计算一列有多少个1
    for column_index in range(column_length):
        rows = []
        for row_index in range(row_length):
            if(lines[row_index][column_index] == '1'):
                rows.append(str(row_index))
        with open(file_path_column,'a') as f_column:
            print(rows)
            f_column.write(str(len(rows)))
            f_column.write(' ')
            for j in rows:
                f_column.write(j)
                f_column.write(' ')
            f_column.write('\n')
