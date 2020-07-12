/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: 解调部分
*/

module Demodulation#(parameter
    CodeLen = 256,                                               // 码长
    CodeLen_bits = 8,                                            // 码长一共占多少个比特，RAM地址用
    ChkLen = 128,                                                // 校验方程个数，也是H矩阵行数
    ChkLen_bits = 7,                                            // 校验长度，用来定位ROM地址
    row_weight = 6,                                              // 行重，不过没啥用
    column_weight = 3,                                           // 列重，也没啥用
    Iteration_Times = 50,                                        // 一段序列进行BF翻转的次数
    Length = 6,                                                  // 比特位宽
    Sigma_Iteration_Times = 20                                   // 解码了多少序列了
    `define InfoLen (CodeLen - ChkLen)                          // 信息比特的长度
)(
    input clk,
    input rst,
    input modulation_rst,
    
    // 与调制部分的交互
    input modulation_down,
    input [CodeLen-1:0] modulation_sequence_before,
    input demodulation_down_to_modulation_receive,
    output reg demodulation_down_to_modulation,
    output reg demodulation_receive,
    
    // 与RAM之间的交互
    input RAM_read_receive,
    input demodulation_valid_a,
    input demodulation_valid_b,
    input [14:0] douta,
    input [14:0] doutb,
    output reg demodulation_read_RAM,
    
    // 与解码部分的交互
    input demodulation_to_decoder_receive,
    output reg demodulation_down_to_decoder,
    output [Length*CodeLen-1:0] demodulation_sequence,
    output reg [CodeLen-1:0] demodulation_sequence_prototype
    );
    
    
    reg [2:0] demodulation_state;
    reg [Length-1:0] demodulation_sequence_reg[CodeLen-1:0];
    reg [CodeLen_bits:0] demodulation_a;
    reg [CodeLen_bits:0] demodulation_b;
    

    // 对输出进行整合
    genvar i;
    generate
        for(i = 0; i<CodeLen; i=i+1)begin
            assign demodulation_sequence[Length*(i+1)-1 : Length*i] = demodulation_sequence_reg[i];
        end
    endgenerate

    always@(posedge clk or negedge rst or negedge modulation_rst) begin
        if(~rst || ~modulation_rst) begin
            demodulation_down_to_modulation <= 'd0;
            demodulation_down_to_decoder <= 'd0;
            // demodulation_sequence <= 'd0;
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
                            demodulation_sequence_reg[demodulation_a] <= {Length*douta[14]};
                            demodulation_a <= demodulation_a + 2;
                        end
                        if(demodulation_valid_b)begin
                            demodulation_sequence_reg[demodulation_b] <= {Length*doutb[14]};
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
                        // demodulation_sequence <= 'd0;
                        demodulation_state <= 3'd0;
                    end

                end
                default: begin
                    demodulation_state <= 3'd0;
                end
                
            endcase
        end
    end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule
