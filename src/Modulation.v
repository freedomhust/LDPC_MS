/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: ���Ʋ���
*/

module Modulation#(parameter
    CodeLen = 256,                                               // �볤
    CodeLen_bits = 8,                                            // �볤һ��ռ���ٸ����أ�RAM��ַ��
    ChkLen = 128,                                                // У�鷽�̸�����Ҳ��H��������
    ChkLen_bits = 7,                                            // У�鳤�ȣ�������λROM��ַ
    row_weight = 6,                                              // ���أ�����ûɶ��
    column_weight = 3,                                           // ���أ�Ҳûɶ��
    Iteration_Times = 50,                                        // һ�����н���BF��ת�Ĵ���
    Sigma_Iteration_Times = 20                                   // �����˶���������
    `define InfoLen (CodeLen - ChkLen)                          // ��Ϣ���صĳ���
)(
    input clk,
    input rst,
    input modulation_rst,
    
    // ����Ʋ��ֵĽ���
    input generate_code_down,
    input [CodeLen-1:0] Code_sequence,
    output reg generate_code_down_receive,
    
    // ��RAM֮��Ľ���
    output reg write_enable_a,
    output reg write_enable_b,
    output reg modulation_write_down,
    output reg [CodeLen_bits:0] modulation_i,
    output reg [14:0] modulation_sequence_after_a,
    output reg [14:0] modulation_sequence_after_b,
    
    // ��AWGN֮��Ľ���
    input AWGN_valid,
    input [14:0] noise0_fix5p10,
    input [14:0] noise1_fix5p10,
    
    // �������ֵĽ���
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
                    // ��������������ô�Ϳ��Խ��е�����
                    if(generate_code_down && AWGN_valid) begin
                        modulation_i <= 0;
                        modulation_sequence_before <= Code_sequence;
                        generate_code_down_receive <= 'd1;
                        modulation_state <= 'd1;
                    end
                end
                // BPSK����+����
                3'd1: begin
                    // �Ѿ���ʼ�����ˣ���ô��У���Ǳߵ��ź�Ӧ������Ϊ0��
                    generate_code_down_receive <= 'd0;
                    // ���ֵΪ0����ô����Ϊ15'd1����ֵΪ1������Ϊ-15'd1��������Ϊnoisesample��(1,4,10)������С����Ҫ��Ӧ��������10λ
                    if(modulation_i < CodeLen) begin
                        modulation_sequence_after_a <= modulation_sequence_before[modulation_i] ? ((-15'd1<<10) + noise0_fix5p10) : ((15'd1<<10) + noise0_fix5p10);
                        write_enable_a <= 1;
                        //$display("modulation_i = %d noise0_sample = %b",modulation_i,noise0_fix5p10);
                        modulation_sequence_after_b <= modulation_sequence_before[modulation_i+1] ?((-15'd1<<10) + noise1_fix5p10) : ((15'd1<<10) + noise1_fix5p10);
                        write_enable_b <= 1;
                        //$display("modulation_i = %d noise1_sample = %b",modulation_i,noise1_fix5p10);
                        modulation_i <= modulation_i+2;
                    end
                    // ����ȫ��������down�ź���Ϊ1������2״̬
                    else begin
                        modulation_i <= 0;
                        write_enable_a <= 0;
                        write_enable_b <= 0;
                        modulation_write_down <= 1;
                        modulation_down <= 1'd1;
                        modulation_state <= 3'd2;
                    end
                end
                // �ȴ�������ֽ���
                3'd2: begin
                    // ���������ֽ��յ��ˣ���ôdown�ź���Ϊ0����ú������鷳
                    if(demodulation_receive)begin
                        modulation_down <= 1'd0;
                    end
                    // ���յ�������ֵĽ�������źź������¿�ʼ���е���
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
