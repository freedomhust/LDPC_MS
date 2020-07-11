/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: 调制部分
*/

module Modulation#(parameter
    CodeLen = 256,                                               // 码长
    CodeLen_bits = 8,                                            // 码长一共占多少个比特，RAM地址用
    ChkLen = 128,                                                // 校验方程个数，也是H矩阵行数
    ChkLen_bits = 7,                                            // 校验长度，用来定位ROM地址
    row_weight = 6,                                              // 行重，不过没啥用
    column_weight = 3,                                           // 列重，也没啥用
    Iteration_Times = 50,                                        // 一段序列进行BF翻转的次数
    Sigma_Iteration_Times = 20                                   // 解码了多少序列了
    `define InfoLen (CodeLen - ChkLen)                          // 信息比特的长度
)(
    input clk,
    input rst,
    input modulation_rst,
    
    // 与调制部分的交互
    input generate_code_down,
    input [CodeLen-1:0] Code_sequence,
    output reg generate_code_down_receive,
    
    // 与RAM之间的交互
    output reg write_enable_a,
    output reg write_enable_b,
    output reg modulation_write_down,
    output reg [CodeLen_bits:0] modulation_i,
    output reg [14:0] modulation_sequence_after_a,
    output reg [14:0] modulation_sequence_after_b,
    
    // 与AWGN之间的交互
    input AWGN_valid,
    input [14:0] noise0_fix5p10,
    input [14:0] noise1_fix5p10,
    
    // 与解调部分的交互
    input demodulation_receive,
    input demodulation_down_to_modulation,
    output reg modulation_down,
    output reg demodulation_down_to_modulation_receive,
    output reg [CodeLen-1:0] modulation_sequence_before
    
    );
    
    reg [2:0] modulation_state;
    //reg [CodeLen-1:0] modulation_sequence_before;
    
    
    always@(posedge clk, negedge rst, negedge modulation_rst)begin : modulation
        if(~rst || ~modulation_rst)begin
            modulation_i <= 0;
            modulation_state <= 'd0;
            demodulation_down_to_modulation_receive <= 'd0;
            modulation_down <= 0;
            modulation_sequence_before <= 'd0;
            write_enable_a <= 0;
            write_enable_b <= 0;
            modulation_sequence_after_a <= 'd0;
            modulation_sequence_after_b <= 'd0;
            modulation_write_down <= 'd0;
            generate_code_down_receive <= 'd0;
        end
        else begin
            case(modulation_state)
                3'd0: begin
                    modulation_down <= 0;
                    demodulation_down_to_modulation_receive <= 'd0;
                    // 如果编码结束，那么就可以进行调制了
                    if(generate_code_down && AWGN_valid) begin
                        modulation_i <= 0;
                        modulation_sequence_before <= Code_sequence;
                        generate_code_down_receive <= 'd1;
                        modulation_state <= 'd1;
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

    
endmodule
