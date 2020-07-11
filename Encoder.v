/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: 编码部分
*/

// 编码部分状态机状态
`define STATE_GenCode_IDLE          3'd0
`define STATE_GenCode_ING0          3'd1
`define STATE_GenCode_ING1          3'd2
`define STATE_GenCode_CHANGE_COLUMN 3'd3
`define STATE_GenCode_END           3'd4


module Encoder#(parameter
    CodeLen = 256,                                               // 码长
    ChkLen = 128,                                                // 校验方程个数，也是H矩阵行数
    row_weight = 6,                                              // 行重，不过没啥用
    column_weight = 3,                                           // 列重，也没啥用
    Iteration_Times = 50,                                        // 一段序列进行BF翻转的次数
    Sigma_Iteration_Times = 20,                                   // 解码了多少序列了
    CodeLen_bits = 8,
    ChkLen_bits = 7
    `define InfoLen (CodeLen - ChkLen)                          // 信息比特的长度
)(
    input clk,
    input rst,
    
    // 随机序列发生器与编码部分的交互
    input random_sequence_ready,                                // 信息序列已经生成，等待编码部分接收
    input [`InfoLen-1:0] random_sequence,                       // 随机序列生成器生成的信息序列
    output reg random_sequence_ready_receive,                  // 编码部分接收到了随机序列发生器生成的信息序列
    
    
    // PI_ROM与编码部分的交互
    input PI_read_receive,                                     // PI_ROM接收到了编码部分给的读信号
    input PI_valid,                                            // 这时候从PI_ROM中读出的数据有效
    input [CodeLen-1:0] dout_PI,                               // PI_ROM中读取出来的数据
    output reg encoder_read_PI_matrix,                         // 编码部分给PI_ROM的读信号
    
    
    // 调制部分与编码部分的交互
    input generate_code_down_receive,                          // 调制部分接收到了编码部分给的编码结束信号
    output reg generate_code_down,                             // 编码结束
    output reg [CodeLen-1:0] Code_sequence                     // 编码得到的最终编码序列
    );



    reg [10:0] column_change_1[9:0];           // 交换的列的序号1
    reg [10:0] column_change_2[9:0];           // 交换的列的序号2
    reg [10:0] column_change_times;            // 交换列的次数
    
    // 生成信息序列以及编码序列用
    reg [2:0] generate_code_sequence_state;               // 编码状态机
    reg random_sequence_enable;                           // 可以生成信息序列了
    reg  [`InfoLen-1:0]Info_sequence;                     // 编码部分的信息序列
    reg  [ChkLen-1:0]Check_sequence;                      // 校验序列
    integer code_i,code_j;
    
    
    //******************************************* 编码序列的生成
    // 当H矩阵转化完毕之后就可以开始生成校验比特了
    always@(posedge clk, negedge rst) begin
        if(~rst)begin
            random_sequence_ready_receive <= 0;
            generate_code_sequence_state <= 'd0;
            generate_code_down <= 0;
            encoder_read_PI_matrix <= 0;
            Code_sequence <= 'd0;
            code_i <= 0;
            code_j <= 0;
            column_change_times <= 11'b00000000011;
            column_change_1[0]  <= 11'b01000000010;
            column_change_1[1]  <= 11'b01000000001;
            column_change_1[2]  <= 11'b01000000000;
            column_change_1[3]  <= 11'b0;
            column_change_1[4]  <= 11'b0;
            column_change_2[0]  <= 11'b00111111100;
            column_change_2[1]  <= 11'b01000000000;
            column_change_2[2]  <= 11'b00111111111;
            column_change_2[3]  <= 11'b0;
            column_change_2[4]  <= 11'b0;
        end
        else begin
            case(generate_code_sequence_state)
            
                `STATE_GenCode_IDLE:begin
                    if(random_sequence_ready)begin
                        // 告诉信息序列生成器已经接收到了信息序列，可以开始生成下一个信息序列了
                        random_sequence_ready_receive <= 1;
                        Info_sequence <= random_sequence;
                        code_i <= 0;
                        // 开始读取PI矩阵
                        encoder_read_PI_matrix <= 1;
                        generate_code_sequence_state <= `STATE_GenCode_ING0;
                    end
                end
                
                `STATE_GenCode_ING0: begin
                    random_sequence_ready_receive <= 0;
                    // 如果读取部分已经接收到了信号，那么可以重新置0了
                    if(PI_read_receive)begin
                        //$display("开始等待PI矩阵读取数据");
                        encoder_read_PI_matrix <= 0;
                        generate_code_sequence_state <= `STATE_GenCode_ING1;
                    end
                end
                
                `STATE_GenCode_ING1: begin
                    // 开始生成校验序列
                    if(code_i != ChkLen)begin
                        if(PI_valid)begin
                            Check_sequence[code_i] <= ^(dout_PI[ChkLen-1:0] & Info_sequence);
                            code_i <= code_i+1;
                        end
                    end
                    
                    // 全部完成后开始拼接，然后开始看一看有没有发生列变化，有的话要将列换回来
                    else begin
                        Code_sequence <= {Check_sequence,Info_sequence};
                        if(column_change_times != 0)begin
                            code_j <= column_change_times - 1;
                            generate_code_sequence_state <= `STATE_GenCode_CHANGE_COLUMN;
                        end
                        else begin
                            generate_code_sequence_state <= `STATE_GenCode_END;
                        end
                    end
                end

                `STATE_GenCode_CHANGE_COLUMN:begin
                    if(code_j >= 0)begin
                        Code_sequence[column_change_1[code_j]] <= Code_sequence[column_change_2[code_j]];
                        Code_sequence[column_change_2[code_j]] <= Code_sequence[column_change_1[code_j]];
                        code_j <= code_j - 1;
                    end
                    else begin
                        generate_code_sequence_state <= `STATE_GenCode_END;
                    end
                end
                
                // 校验比特已经全部生成，等待校验结果
                `STATE_GenCode_END: begin
                    generate_code_down <= 1;
                    // 如果发现校验结果是正确的，那么回到初始状态，等待生成下一个校验序列
                    if(generate_code_down_receive)begin
                        generate_code_sequence_state <= `STATE_GenCode_IDLE;
                        generate_code_down <= 0;
                    end
                end
                
                default:begin
                    generate_code_sequence_state <= `STATE_GenCode_IDLE;
                end
                
            endcase
        end
    end
    
endmodule
