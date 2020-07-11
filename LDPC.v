/*
 * Author: neidong_fu
 * Time  : 2020/01/07
 * function: LDPC fraction
*/

// 高斯消元H矩阵的状态
`define STATE_HCHANGE_INIT          3'd0
`define STATE_HCHANGE_FINDI         3'd1
`define STATE_HCHANGE_CHANGE_COLUMN 3'd2
`define STATE_HCHANGE_CHANGE_ROW    3'd3
`define STATE_HCHANGE_END           3'd4

// 编码部分状态机状态
`define STATE_GenCode_IDLE          3'd0
`define STATE_GenCode_ING0          3'd1
`define STATE_GenCode_ING1          3'd2
`define STATE_GenCode_CHANGE_COLUMN 3'd3
`define STATE_GenCode_END           3'd4

module LDPC #(parameter
    CodeLen = 512,                                               // 码长
    ChkLen = 256,                                                // 校验方程个数，也是H矩阵行数
    row_weight = 6,                                              // 行重，不过没啥用
    column_weight = 3,                                           // 列重，也没啥用
    Iteration_Times = 50,                                        // 一段序列进行BF翻转的次数
    Sigma_Iteration_Times = 20                                   // 解码了多少序列了
    `define InfoLen (CodeLen - ChkLen)                          // 信息比特的长度
)(
    input rst,                                                 // 
    input clk,
    input AWGN_enable,
    input [9:0] sigma,
    input modulation_rst,
    input [95:0] s0,
    input [95:0] s1,
    output reg decoder_sigma_down,
    output reg [31:0] biterror_counter,
    output reg [31:0] decoder_Code_counter
    );
    
    // store H Matrix
    //reg [CodeLen-1:0] H_matrix[ChkLen-1:0];
    //reg [CodeLen-1:0] check_matrix[ChkLen-1:0];
    reg H_matrix_enable;
    //reg H_matrix_enable;
    
    reg [10:0] column_change_1[9:0];           // 交换的列的序号1
    reg [10:0] column_change_2[9:0];           // 交换的列的序号2
    reg [10:0] column_change_times[1:0];       // 交换列的次数
    
    // read H_matrix File
    initial begin
        $readmemb("H:/graduation_project/LDPC/change_column_times_512_256.txt",column_change_times);
        $readmemb("H:/graduation_project/LDPC/column_change_1_512_256.txt",column_change_1);
        $readmemb("H:/graduation_project/LDPC/column_change_2_512_256.txt",column_change_2);
    end
    
    reg [20:0] count;                          // debug 用

    integer i,j;
    
    // 生成信息序列以及编码序列用
    reg [2:0] generate_code_sequence_state;               // 编码状态机
    reg random_sequence_enable;                           // 可以生成信息序列了
    reg random_sequence_ready_receive;                    // 编码部分接收到了随机序列发生器生成的信息序列
    reg encode_check_result_receive;                      // 编码部分已经接收到了校验的结果
    wire [`InfoLen-1:0]random_sequence;                   // 随机序列生成器生成的信息序列
    reg  [`InfoLen-1:0]Info_sequence;                     // 编码部分的信息序列
    reg  [ChkLen-1:0]Check_sequence;                      // 校验序列
    reg  [CodeLen-1:0]Code_sequence;                      // 最后的编码序列
    reg generate_code_down;                               // 编码序列已经生成完毕
    wire random_sequence_ready;                           // 信息序列已经生成，等待编码部分接收
    reg encoder_read_PI_matrix;                           // 准备读取ROM数据
    reg generate_code_down_receive;                       // 调制部分已经接收到了编码的序列
    
    // 调制用
    reg modulation_check_result_receive;                  // 调制部分接收到了校验部分的结果
    
    //reg ROM_read_enable;
    reg PI_ROM_read_enable;
    reg H_ROM_read_enable;
    //reg  [6:0]   ROM_addr;
    reg  [7:0]   ROM_PI_addr;
    reg  [7:0]   ROM_H_addr;
    wire [CodeLen-1:0] dout_PI;
    wire [CodeLen-1:0] dout_H;
    //wire [CodeLen-1:0] douta;
    //wire [CodeLen-1:0] doutb;
    //reg enable_d,valid;
    reg PI_enable_d,PI_valid;
    reg H_enable_d,H_valid;
    reg [2:0] PI_state;
    reg PI_read_receive;
    
    //******************************************* 信息序列的生成
    random_sequence #(.sequence_length(`InfoLen))u_random_sequence(
        .clk(clk),
        .rst(rst),
        
        .random_sequence_ready_receive(random_sequence_ready_receive),
        .random_sequence(random_sequence),
        .random_sequence_ready(random_sequence_ready)
    );
    
    integer code_i,code_j; 
    
    // 读取PI矩阵
    always@(posedge clk, negedge rst)begin
        if(~rst)begin
            PI_ROM_read_enable <= 'd0;
            ROM_PI_addr <= 'd0;
            PI_state <= 'd0;
            PI_read_receive <= 0;
        end
        else begin
            case(PI_state)
            3'd0: begin
                if(encoder_read_PI_matrix)begin
                    PI_read_receive <= 1;
                    PI_ROM_read_enable <= 1;
                    PI_state <= 3'd1;
                end
            end
            3'd1: begin
                PI_read_receive <= 0;
                if(ROM_PI_addr != ChkLen-1)begin
                    ROM_PI_addr <= ROM_PI_addr+1;
                    PI_ROM_read_enable <= 1;
                end
                else begin
                    PI_state <= 3'd2;
                end
            end
            3'd2: begin
                PI_ROM_read_enable <= 0;
                ROM_PI_addr <= 'd0;
                PI_state <= 3'd0;
            end
            default: begin
                PI_state <= 3'd0;
            end
            endcase
        end
    end
    
    // 放慢两拍
    always@(posedge clk, negedge rst) begin
        if(~rst) begin
            PI_enable_d <= 0;
            PI_valid <= 0;
        end
        else begin
            PI_enable_d <= PI_ROM_read_enable;
            PI_valid <= PI_enable_d;
        end
    end
    
    PI_ROM u_PI(
        .addra(ROM_PI_addr),
        .clka(clk),
        .douta(dout_PI),
        .ena(PI_ROM_read_enable)
    );
    
    
    //******************************************* 编码序列的生成
    // 当H矩阵转化完毕之后就可以开始生成校验比特了
    always@(posedge clk, negedge rst)begin
        if(~rst)begin
            encode_check_result_receive <= 0;
            random_sequence_ready_receive <= 0;
            generate_code_sequence_state <= 'd0;
            generate_code_down <= 0;
            encoder_read_PI_matrix <= 0;
            Code_sequence <= 'd0;
            code_i <= 0;
        end
        else begin
            case(generate_code_sequence_state)
                `STATE_GenCode_IDLE:begin
                    encode_check_result_receive <= 0;
                    if(random_sequence_ready)begin
                        //$display("开始编码");
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
                    encode_check_result_receive <= 0;
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
                            //$display("%b",dout_PI);
                            code_i <= code_i+1;
                        end
                    end
                    
                    // 全部完成后开始拼接，然后开始看一看有没有发生列变化，有的话要将列换回来
                    else begin
                        Code_sequence <= {Check_sequence,Info_sequence};
                        if(column_change_times[0] != 0)begin
                            code_j <= column_change_times[0]-1;
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
                        //encode_check_result_receive <= 1;
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
    
    // AWGN
    wire [14:0] noise0_fix5p10,noise1_fix5p10;
    wire AWGN_valid;
    
    //******************************************* 调制
    reg [2:0]modulation_state;                                          // 调制状态机
    reg [CodeLen-1:0] modulation_sequence_before;                       // 未调制前，原序列
    reg [14:0] modulation_sequence_after_a;                             // 调制后的序列
    reg [14:0] modulation_sequence_after_b;
    reg [9:0] modulation_i;                                              // 调制计数用                                             
    reg modulation_down;                                               // 调制结束，可以开始解调了
    reg demodulation_down_to_modulation_receive;                       // 调制部分接收到了解调部分给它的解调结束信号
    reg write_enable_a;
    reg write_enable_b;
    reg modulation_write_down;
    
    
    // 解调
    reg demodulation_receive;                                          // 解调部分已经接收到了调制结束信号
    reg demodulation_down_to_modulation;                               // 解调部分发给调制部分的解调结束信号
    reg demodulation_down_to_decoder;                                  // 解调部分发给解码部分的解调结束信号
    
    always@(posedge clk, negedge rst, negedge modulation_rst)begin : modulation
        if(~rst || ~modulation_rst)begin
            modulation_i <= 0;
            modulation_state <= 'd0;
            modulation_check_result_receive <= 'd0;
            demodulation_down_to_modulation_receive <= 'd0;
            modulation_down <= 0;
            modulation_sequence_before <= 'd0;
            write_enable_a <= 0;
            write_enable_b <= 0;
            modulation_sequence_after_a <= 'd0;
            modulation_sequence_after_b <= 'd0;
            modulation_write_down <= 'd0;
            // after要初始化的话资源消耗太大了，不初始化也没问题
        end
        else begin
            case(modulation_state)
                3'd0: begin
                    modulation_down <= 0;
                    demodulation_down_to_modulation_receive <= 'd0;
                    // 如果校验正确，那么开始进行调制
                    if(generate_code_down && AWGN_valid) begin
                        modulation_i <= 0;
                        modulation_sequence_before <= Code_sequence;
                        generate_code_down_receive <= 'd1;
                        modulation_state <= 'd1;
                        //write_enable_a <= 1;
                        //write_enable_b <= 1;
                    end
                end
                // BPSK调制+加噪
                3'd1: begin
                    // 已经开始调制了，那么对校验那边的信号应该重制为0了
                    generate_code_down_receive <= 'd0;
                    // 如果值为0，那么调制为15'd1，若值为1，调制为-15'd1，不过因为noisesample是(1,4,10)，所以小数点要相应的向左移10位
                    if(modulation_i < CodeLen) begin
                        modulation_sequence_after_a <= modulation_sequence_before[modulation_i] ? ((-15'd1<<10) + noise0_fix5p10) : ((15'd1<<10) + noise0_fix5p10);
                        write_enable_a <= 1;
                        //$display("modulation_i = %d noise0_sample = %b",modulation_i,noise0_fix5p10);
                        modulation_sequence_after_b <= modulation_sequence_before[modulation_i+1] ?((-15'd1<<10) + noise1_fix5p10) : ((15'd1<<10) + noise1_fix5p10);
                        write_enable_b <= 1;
                        //$display("modulation_i = %d noise1_sample = %b",modulation_i,noise1_fix5p10);
                        modulation_i <= modulation_i+2;
                    end
                    // 调制全部结束，down信号置为1，进入2状态
                    else begin
                        modulation_i <= 0;
                        write_enable_a <= 0;
                        write_enable_b <= 0;
                        modulation_write_down <= 1;
                        modulation_down <= 1'd1;
                        modulation_state <= 3'd2;
                    end
                end
                // 等待解调部分接收
                3'd2: begin
                    // 如果解调部分接收到了，那么down信号置为0，免得后续添麻烦
                    if(demodulation_receive)begin
                        modulation_down <= 1'd0;
                        //$display("调制结束");
                    end
                    // 当收到解调部分的解调结束信号后再重新开始进行调制
                    if(demodulation_down_to_modulation) begin
                        demodulation_down_to_modulation_receive <= 'd1;
                        modulation_write_down <= 0;
                        modulation_sequence_before <= 'd0;
                        modulation_state <= 3'd0;
                    end
                end
                default: begin
                    modulation_state <= 3'd0;
                end
            endcase
        end
    end

    //****************************************** AWGN
    // 放在这里让它自己执行就好，会有源源不断的噪声样本出来的
    AWGN u_AWGN(
        .clk(clk),
        .rst(rst && modulation_rst),
        .enable(AWGN_enable),
        .pop(1'd1),
        .sigma(sigma),
        .s0(s0),
        .s1(s1),
        .valid(AWGN_valid),
        .noise0_fix5p10(noise0_fix5p10),
        .noise1_fix5p10(noise1_fix5p10)
    );
    
    
    wire [7:0] addra,addrb;
    wire [14:0] dina,dinb;
    wire [14:0] douta,doutb;
    wire ena,enb;
    wire wea,web;
    
    reg [2:0] modulation_after_state;
    reg demodulation_RAM_read_enable_a;
    reg demodulation_RAM_read_enable_b;
    reg [9:0] demodulation_addr_a;
    reg [9:0] demodulation_addr_b;
    reg RAM_read_receive;
    reg demodulation_read_RAM;
    
    // 读取调制后的序列
    always@(posedge clk, negedge rst)begin
        if(~rst)begin
            demodulation_RAM_read_enable_a <= 'd0;
            demodulation_RAM_read_enable_b <= 'd0;
            demodulation_addr_a <= 'd0;
            demodulation_addr_b <= 'd1;
            modulation_after_state <= 'd0;
            RAM_read_receive <= 0;
        end
        else begin
            case(modulation_after_state)
            3'd0: begin
                if(demodulation_read_RAM)begin
                    RAM_read_receive <= 1;
                    demodulation_RAM_read_enable_a <= 1;
                    demodulation_RAM_read_enable_b <= 1;
                    modulation_after_state <= 3'd1;
                end
            end
            3'd1: begin
                RAM_read_receive <= 0;
                // 这里我没有考虑码长为奇数的情况，或者说尝试着考虑了但没写出来
                if(demodulation_addr_a != CodeLen && demodulation_addr_b != CodeLen+1)begin
                    demodulation_addr_a <= demodulation_addr_a+2;
                    demodulation_addr_b <= demodulation_addr_b+2;
                    demodulation_RAM_read_enable_a <= 1;
                    demodulation_RAM_read_enable_b <= 1;
                end
                else begin
                    modulation_after_state <= 3'd2;
                end
            end
            3'd2: begin
                demodulation_RAM_read_enable_a <= 0;
                demodulation_RAM_read_enable_b <= 0;
                demodulation_addr_a <= 'd0;
                demodulation_addr_b <= 'd1;
                modulation_after_state <= 3'd0;
            end
            default: begin
                modulation_after_state <= 3'd0;
            end
            endcase
        end
    end
    
    reg demodulation_enable_a_d;
    reg demodulation_enable_b_d;
    reg demodulation_valid_a;
    reg demodulation_valid_b;
    
    // 放慢两拍
    always@(posedge clk, negedge rst) begin
        if(~rst) begin
            demodulation_enable_a_d <= 0;
            demodulation_enable_b_d <= 0;
            demodulation_valid_a <= 0;
            demodulation_valid_b <= 0;
        end
        else begin
            demodulation_enable_a_d <= demodulation_RAM_read_enable_a;
            demodulation_valid_a <= demodulation_enable_a_d;
            demodulation_enable_b_d <= demodulation_RAM_read_enable_b;
            demodulation_valid_b <= demodulation_enable_b_d;
        end
    end
    
    
    assign addra = modulation_write_down ? demodulation_addr_a[8:0] : modulation_i[8:0]-'d2;
    assign addrb = modulation_write_down ? demodulation_addr_b[8:0] : modulation_i[8:0]-'d1;
    assign ena = modulation_write_down ? demodulation_RAM_read_enable_a : write_enable_a;
    assign enb = modulation_write_down ? demodulation_RAM_read_enable_b : write_enable_b;
    assign wea = write_enable_a;
    assign web = write_enable_b;
    assign dina = modulation_sequence_after_a;
    assign dinb = modulation_sequence_after_b;
    
    modulation_after_ram u_ram(
        .addra(addra),
        .clka(clk),
        .dina(dina),
        .douta(douta),
        .ena(ena),
        .wea(wea),
        .addrb(addrb),
        .clkb(clk),
        .dinb(dinb),
        .doutb(doutb),
        .enb(enb),
        .web(web)
    );
    
    //****************************************** 解调
    
    reg [CodeLen-1:0] demodulation_sequence;
    reg [CodeLen-1:0] demodulation_sequence_prototype;
    integer demodulation_i;
    reg [2:0] demodulation_state;
    reg [9:0] demodulation_a;
    reg [9:0] demodulation_b;
    
    
    // 译码
    reg demodulation_to_decoder_receive;                                 // 译码部分已经接收到了解调后的序列
    
    
    always@(posedge clk or negedge rst or negedge modulation_rst) begin : demodulation
        if(~rst || ~modulation_rst) begin
            demodulation_down_to_modulation <= 'd0;
            demodulation_down_to_decoder <= 'd0;
            demodulation_sequence <= 'd0;
            demodulation_i <= 'd0;
            demodulation_state <= 'd0;
            demodulation_receive <= 'd0;
            demodulation_sequence_prototype <= 'd0;
            demodulation_read_RAM <= 'd0;
            demodulation_a <= 'd0;
            demodulation_b <= 'd1;
        end
        else begin
            case(demodulation_state)
                // 调制结束，那么可以开始解调了
                3'd0: begin
                    if(modulation_down) begin
                        demodulation_receive <= 'd1;
                        demodulation_state <= 3'd1;
                        demodulation_read_RAM <= 'd1;
                        demodulation_sequence_prototype <= modulation_sequence_before;
                    end
                end
                
                // 开始一个个进行解调
                3'd1: begin
                    demodulation_receive <= 'd0;
                    if(RAM_read_receive) begin
                        demodulation_read_RAM <= 0;
                        demodulation_state <= 3'd2;
                    end
                end
                
                3'd2: begin
                    if(demodulation_a != CodeLen && demodulation_b != CodeLen+1) begin
                        if(demodulation_valid_a)begin
                            demodulation_sequence[demodulation_a] <= douta[14];
                            demodulation_a <= demodulation_a + 2;
                        end
                        if(demodulation_valid_b)begin
                            demodulation_sequence[demodulation_b] <= doutb[14];
                            demodulation_b <= demodulation_b + 2;
                        end 
                    end
                    else begin
                        // 解调结束后发送解调结束信号
                        demodulation_a <= 'd0;
                        demodulation_b <= 'd1;
                        demodulation_down_to_modulation <= 'd1;
                        demodulation_down_to_decoder <= 'd1;
                        demodulation_state <= 3'd3;
                    end
                end

                // 等待调制部分和解码部分的信号
                3'd3: begin
                    if(demodulation_down_to_modulation_receive) begin
                        demodulation_down_to_modulation <= 'd0;
                    end
                    if(demodulation_to_decoder_receive)begin
                        demodulation_down_to_decoder <= 'd0;
                        demodulation_sequence <= 'd0;
                        demodulation_state <= 3'd0;
                    end

                end
                default: begin
                    demodulation_state <= 3'd0;
                end
                
            endcase
        end
    end


    // ROM读取数据需要两个周期的延迟
    always@(posedge clk, negedge rst) begin
        if(~rst) begin
            H_enable_d <= 0;
            H_valid <= 0;
        end
        else begin
            H_enable_d <= H_ROM_read_enable;
            H_valid <= H_enable_d;
        end
    end
    
    reg H_read_receive;
    reg [2:0] H_state;
    reg decoder_read_H_matrix;
    // 读取PI矩阵
    always@(posedge clk, negedge rst)begin
        if(~rst)begin
            H_ROM_read_enable <= 'd0;
            ROM_H_addr <= 'd0;
            H_state <= 'd0;
            H_read_receive <= 0;
        end
        else begin
            case(H_state)
            3'd0: begin
                if(decoder_read_H_matrix)begin
                    H_read_receive <= 1;
                    H_ROM_read_enable <= 1;
                    H_state <= 3'd1;
                end
            end
            3'd1: begin
                H_read_receive <= 0;
                if(ROM_H_addr != ChkLen-1)begin
                    ROM_H_addr <= ROM_H_addr+1;
                    H_ROM_read_enable <= 1;
                end
                else begin
                    H_state <= 3'd2;
                end
            end
            3'd2: begin
                H_ROM_read_enable <= 0;
                ROM_H_addr <= 'd0;
                H_state <= 3'd0;
            end
            default: begin
                H_state <= 3'd0;
            end
            endcase
        end
    end

    H_ROM u_H(
        .addra(ROM_H_addr),
        .clka(clk),
        .douta(dout_H),
        .ena(H_ROM_read_enable)
    );


    //***************************************** 解码
    reg [2:0] decode_state;                                              // 状态机状态
    reg [CodeLen-1:0] decoder_sequence;                                  // 解码序列
    reg check_flag;                                                      // 用来表明校验方程是否为0
    reg  check_result;                                       // 每一个校验方程校验后的值
    reg [CodeLen-1:0] counter_signal;                                    // counter的计数信号
    reg [10:0] iteration_times;                                          // 记录迭代的次数
    integer check_number_encoder;                                        // 记录一下校验已经进行到了哪个位置
    reg counter_rst;                                                     // counter计数器的rst信号
    integer FIND_MAX_i;                                                  // 计数值，看比较大小比较到哪个地方了
    reg [10:0] max_value;                                                // 存储器couter计数器中的最大值
    reg [10:0] max_value_number;                                         // 存储器counter计数器中最大值的序号
    reg decode_down;                                                     // 译码结束
    reg [CodeLen-1:0]decoder_sequence_prototype;                         // 正在解码的序列的初始序列
    integer decoder_compare_number;                                     // 

    reg [CodeLen-1:0] decoder_check;
    
    // counter部分 对每个节点的错误方程个数进行计数
    wire [2:0] sum[CodeLen-1:0];                                         // counter计数值
    genvar counter_i;
    generate
        for(counter_i = 0; counter_i < CodeLen; counter_i = counter_i+1)begin : counter
            Counter u_counter(
                .rst(counter_rst),
                .clk(clk),
                .signal(counter_signal[counter_i]),
                .sum(sum[counter_i])
            );
        end
    endgenerate
    
    // 状态机部分
    always@(posedge clk, negedge rst, negedge modulation_rst)begin : decoder
        if(~rst || ~modulation_rst) begin
            decode_state <= 3'd0;
            demodulation_to_decoder_receive <= 1'd0;
            check_flag <= 1'd0;
            iteration_times <= 'd0;
            check_number_encoder <= 'd0;
            counter_rst <= 'd0;
            max_value <= 'd0;
            max_value_number <= 'd0;
            decode_down <= 'd0;
            counter_signal <= 'd0;
            FIND_MAX_i <= 'd0;
            decoder_sequence_prototype <= 'd0;
            biterror_counter <= 'd0;
            decoder_Code_counter <= 'd0;
            decoder_compare_number <= 'd0;
            decoder_sigma_down <= 'd0;
            check_result <= 0;
            decoder_read_H_matrix <= 'd0;
            decoder_check <= 'd0;
        end
        else begin
            case(decode_state)
                3'd0: begin
                    counter_rst <= 'd1;
                    // 解调结束了，向解调部分发送receive信号，接收解调的比特
                    if(demodulation_down_to_decoder)begin
                        demodulation_to_decoder_receive <= 1'd1;
                        decoder_read_H_matrix <= 1'd1;
                        decoder_sequence <= demodulation_sequence;
                        // 存储初始序列，为了进行biterror计数
                        decoder_sequence_prototype <= demodulation_sequence_prototype;
                        decode_state <= 3'd1;
                        counter_signal <= 'd0;
                        $display("解码开始 解码序列 %d",decoder_Code_counter);
                        $display("Code_sequence         = %b",demodulation_sequence_prototype);
                        $display("demodulation_sequence = %b",demodulation_sequence);
                    end
                end
                
                3'd1: begin
                    counter_rst <= 'd1;
                    demodulation_to_decoder_receive <= 1'd0;
                    if(H_read_receive) begin
                        decoder_read_H_matrix <= 'd0;
                        decode_state <= 3'd2;
                    end
                end
                
                
                3'd2: begin
                    // 开始进行解码校验，看看每个校验方程是否为0
                    if(check_result) begin
                        counter_signal <= decoder_check;
                        check_flag <= 1'd1;
                    end
                    else counter_signal <= 'd0;
                    
                    if(check_number_encoder < ChkLen) begin
                        if(H_valid)begin
                            check_result <= ^(decoder_sequence & dout_H);
                            decoder_check <= dout_H;
                            check_number_encoder <= check_number_encoder+1;
                        end
                    end
                    // 所有的校验方程都已经校验完了
                    else begin
                        check_number_encoder <= 'd0;
                        counter_signal <= 'd0;
                        FIND_MAX_i <= 'd0;
                        decode_state <= 3'd3;
                        max_value <= 'd0;
                        max_value_number <= 'd0;
                    end
                end
                
                
                3'd3: begin
                    // 首先看校验是否是正确的
                    if(check_flag && iteration_times < Iteration_Times)begin
                        // 如果不正确那么开始找到最大的计数值
                        if(FIND_MAX_i < CodeLen) begin
                            //$display("sum[%d] = %d, max_value = %d, max_value_number = %d",FIND_MAX_i,sum[FIND_MAX_i],max_value,max_value_number);
                            if(sum[FIND_MAX_i] > max_value)begin
                                max_value <= sum[FIND_MAX_i];
                                max_value_number <= FIND_MAX_i;
                            end
                            FIND_MAX_i <= FIND_MAX_i+1;
                        end
                        else begin
                            // 等待查找最大值部分将最大值找到，将最大值的序号进行翻转
                            decoder_sequence[max_value_number] <= ~decoder_sequence[max_value_number];
                            // 翻转后继续进行校验，迭代次数加一，重置一下边的序号,counter计数值重置为0
                            iteration_times <= iteration_times+1;
                            counter_rst <= 'd0;
                            check_number_encoder <= 'd0;
                            check_flag <= 'd0;
                            decoder_read_H_matrix <= 'd1;
                            decode_state <= 3'd1;
                        end
                    end
                    
                    // 如果到这里说明BF译码没有成功，但已经超了迭代次数了，所以对错误比特数进行计数
                    else if(check_flag)begin
                        // 一个个进行比较，如果不一样则计数值++
                        if(decoder_compare_number < CodeLen)begin
                            if(decoder_sequence_prototype[decoder_compare_number] != decoder_sequence[decoder_compare_number])begin
                                biterror_counter <= biterror_counter+1;
                            end
                            decoder_compare_number <= decoder_compare_number + 1;
                        end
                        // 计数完毕后开始对解码次数++
                        else begin
                            $display("解码序列 %d 失败",decoder_Code_counter);
                            decoder_Code_counter <= decoder_Code_counter+1;
                            decode_down <= 'd1;
                            decode_state <= 3'd4;
                        end
                    end
                    
                    // 到这里说明解码成功了，返回
                    else begin
                        $display("解码序列 %d 成功",decoder_Code_counter);
                        decoder_Code_counter <= decoder_Code_counter+1;
                        decode_down <= 'd1;
                        decode_state <= 3'd4;
                    end
                end
                
                
                3'd4: begin
                    // 如果解码序列稀疏小于Sigma_Iteration_Times，那么解码继续
                    if(decoder_Code_counter < Sigma_Iteration_Times)begin
                        demodulation_to_decoder_receive <= 1'd0;
                        check_flag <= 1'd0;
                        decode_state <= 3'd0;
                        counter_signal <= 'd0;
                        iteration_times <= 'd0;
                        check_number_encoder <= 'd0;
                        counter_rst <= 'd0;
                        decoder_compare_number <= 'd0;
                    end
                    else begin
                        decoder_sigma_down <= 'd1;
                    end
                end
                default: begin
                    decode_state <= 3'd0;
                end
                
            endcase
        end 
    end
    
endmodule
