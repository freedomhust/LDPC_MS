/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: 将LDPC各部分分模块
*/

module LDPC_v3#(parameter
    CodeLen = 256,                                               // 码长
    ChkLen = 128,                                                // 校验方程个数，也是H矩阵行数
    row_weight = 6,                                              // 行重，不过没啥用
    column_weight = 3,                                           // 列重，也没啥用
    Iteration_Times = 50,                                        // 一段序列进行BF翻转的次数
    Sigma_Iteration_Times = 20,                                   // 解码了多少序列了
    Length = 6,
    CodeLen_bits = 8,
    ChkLen_bits = 7
    `define InfoLen (CodeLen - ChkLen)                          // 信息比特的长度
)(
    input rst,                                                 
    input clk,
    input AWGN_enable,
    input [9:0] sigma,
    input modulation_rst,
    input [95:0] s0,
    input [95:0] s1,
    // output decoder_sigma_down,
    // output [31:0] biterror_counter,
    // output [31:0] decoder_Code_counter
    output decoder_begin,
    output [CodeLen-1:0]prototype_sequence,
    output [CodeLen-1:0]decision_information,
    output decoder_down
    );
    
    

    // 随机序列生成部分
    wire random_sequence_ready_receive;
    wire random_sequence_ready;
    wire [`InfoLen-1:0] random_sequence;
    
    //******************************************* 信息序列的生成
    random_sequence #(.sequence_length(`InfoLen))u_random_sequence(
        .clk(clk),
        .rst(rst),
        
        .random_sequence_ready_receive(random_sequence_ready_receive),
        .random_sequence(random_sequence),
        .random_sequence_ready(random_sequence_ready)
    );
    
    // ROM_PI 部分的信号
    wire encoder_read_PI_matrix;
    wire PI_read_receive;
    wire PI_valid;
    wire [CodeLen-1:0] dout_PI;
    
    // 读取PI_ROM
    ROM_PI#(
    .CodeLen(CodeLen),
    .CodeLen_bits(CodeLen_bits),
    .ChkLen(ChkLen),
    .ChkLen_bits(ChkLen_bits),
    .row_weight(row_weight),
    .column_weight(column_weight),
    .Iteration_Times(Iteration_Times)
    ) u_PI_ROM (
        .clk(clk),
        .rst(rst),
        
        .encoder_read_PI_matrix(encoder_read_PI_matrix),
        .PI_read_receive(PI_read_receive),
        .PI_valid(PI_valid),
        .dout_PI(dout_PI)
    );
    
    wire generate_code_down_receive;
    wire generate_code_down;
    wire [CodeLen-1:0] Code_sequence;
    
    // 进行编码
    Encoder#(
    .CodeLen(CodeLen),
    .CodeLen_bits(CodeLen_bits),
    .ChkLen(ChkLen),
    .ChkLen_bits(ChkLen_bits),
    .row_weight(row_weight),
    .column_weight(column_weight),
    .Iteration_Times(Iteration_Times)
    ) u_encoder(
        .clk(clk),
        .rst(rst),
    
        .random_sequence_ready(random_sequence_ready),
        .random_sequence(random_sequence),
        .random_sequence_ready_receive(random_sequence_ready_receive),
        
        .PI_read_receive(PI_read_receive),
        .PI_valid(PI_valid),
        .dout_PI(dout_PI),
        .encoder_read_PI_matrix(encoder_read_PI_matrix),
        
        .generate_code_down_receive(generate_code_down_receive),
        .generate_code_down(generate_code_down),
        .Code_sequence(Code_sequence) 
    );
    
    
    wire AWGN_valid;
    wire [14:0] noise0_fix5p10;
    wire [14:0] noise1_fix5p10;
    
    // AWGN
    AWGN u_AWGN(
        .clk(clk),
        .rst(rst),
        .modulation_rst(modulation_rst),
        .enable(AWGN_enable),
        .pop(1'd1),
        .sigma(sigma),
        .s0(s0),
        .s1(s1),
        .valid(AWGN_valid),
        .noise0_fix5p10(noise0_fix5p10),
        .noise1_fix5p10(noise1_fix5p10)
    );
    
    wire write_enable_a;
    wire write_enable_b;
    wire modulation_write_down;
    wire [CodeLen_bits:0] modulation_i;
    wire [14:0] modulation_sequence_after_a;
    wire [14:0] modulation_sequence_after_b;
    
    wire demodulation_receive;
    wire demodulation_down_to_modulation;
    wire modulation_down;
    wire demodulation_down_to_modulation_receive;
    wire [CodeLen-1:0] modulation_sequence_before;
    
    // 进行调制
    Modulation #(
    .CodeLen(CodeLen),
    .CodeLen_bits(CodeLen_bits),
    .ChkLen(ChkLen),
    .ChkLen_bits(ChkLen_bits),
    .row_weight(row_weight),
    .column_weight(column_weight),
    .Iteration_Times(Iteration_Times)
    ) u_modulation(
        .clk(clk),
        .rst(rst),
        .modulation_rst(modulation_rst),
        
        .generate_code_down(generate_code_down),
        .Code_sequence(Code_sequence),
        .generate_code_down_receive(generate_code_down_receive),
        
        .write_enable_a(write_enable_a),
        .write_enable_b(write_enable_b),
        .modulation_write_down(modulation_write_down),
        .modulation_i(modulation_i),
        .modulation_sequence_after_a(modulation_sequence_after_a),
        .modulation_sequence_after_b(modulation_sequence_after_b),
        
        .AWGN_valid(AWGN_valid),
        .noise0_fix5p10(noise0_fix5p10),
        .noise1_fix5p10(noise1_fix5p10),
        
        .demodulation_receive(demodulation_receive),
        .demodulation_down_to_modulation(demodulation_down_to_modulation),
        .modulation_down(modulation_down),
        .demodulation_down_to_modulation_receive(demodulation_down_to_modulation_receive),
        .modulation_sequence_before(modulation_sequence_before)
    );
    
    wire demodulation_read_RAM;
    wire RAM_read_receive;
    wire demodulation_valid_a;
    wire demodulation_valid_b;
    wire [CodeLen-1:0] douta;
    wire [CodeLen-1:0] doutb;
    
    // RAM
    RAM_Modulation#(
    .CodeLen(CodeLen),
    .CodeLen_bits(CodeLen_bits),
    .ChkLen(ChkLen),
    .ChkLen_bits(ChkLen_bits),
    .row_weight(row_weight),
    .column_weight(column_weight),
    .Iteration_Times(Iteration_Times)                        // 信息比特的长度
    ) u_ram(
        .clk(clk),
        .rst(rst),
        .modulation_rst(modulation_rst),
        
        .write_enable_a(write_enable_a),
        .write_enable_b(write_enable_b),
        .modulation_write_down(modulation_write_down),
        .modulation_i(modulation_i),
        .modulation_sequence_after_a(modulation_sequence_after_a),
        .modulation_sequence_after_b(modulation_sequence_after_b),
        
        .demodulation_read_RAM(demodulation_read_RAM),
        .RAM_read_receive(RAM_read_receive),
        .demodulation_valid_a(demodulation_valid_a),
        .demodulation_valid_b(demodulation_valid_b),
        .douta(douta),
        .doutb(doutb)
    );
    
    
    wire demodulation_to_decoder_receive;
    wire demodulation_down_to_decoder;
    wire [Length*CodeLen-1:0]demodulation_sequence;
    wire [CodeLen-1:0]demodulation_sequence_prototype;
    // 进行解调
    Demodulation #(
    .CodeLen(CodeLen),
    .CodeLen_bits(CodeLen_bits),
    .ChkLen(ChkLen),
    .ChkLen_bits(ChkLen_bits),
    .row_weight(row_weight),
    .column_weight(column_weight),
    .Iteration_Times(Iteration_Times)                        // 信息比特的长度
    ) u_demodulation(
        .clk(clk),
        .rst(rst),
        .modulation_rst(modulation_rst),
        
        .modulation_down(modulation_down),
        .modulation_sequence_before(modulation_sequence_before),
        .demodulation_down_to_modulation_receive(demodulation_down_to_modulation_receive),
        .demodulation_down_to_modulation(demodulation_down_to_modulation),
        .demodulation_receive(demodulation_receive),
        
        .RAM_read_receive(RAM_read_receive),
        .demodulation_valid_a(demodulation_valid_a),
        .demodulation_valid_b(demodulation_valid_b),
        .douta(douta),
        .doutb(doutb),
        .demodulation_read_RAM(demodulation_read_RAM),
        
        .demodulation_to_decoder_receive(demodulation_to_decoder_receive),
        .demodulation_down_to_decoder(demodulation_down_to_decoder),
        .demodulation_sequence(demodulation_sequence),
        .demodulation_sequence_prototype(demodulation_sequence_prototype)
    );

    assign decoder_begin = demodulation_to_decoder_receive;
    
    // 进行解码
    Decoder u_decoder(
        .clk(clk),
        .rst(rst & modulation_rst),
        .demodulation_down_to_decoder(demodulation_down_to_decoder),
        .demodulation_to_decoder_receive(demodulation_to_decoder_receive),
        .initial_value_input(demodulation_sequence),
        .demodulation_prototype_sequence(demodulation_sequence_prototype),
        .prototype_sequence(prototype_sequence),
        .decision_information(decision_information),
        .decoder_down(decoder_down)
    );
    
endmodule
