/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: �������
*/

module Demodulation#(parameter
    CodeLen = 256,                                               // �볤
    CodeLen_bits = 8,                                            // �볤һ��ռ���ٸ����أ�RAM��ַ��
    ChkLen = 128,                                                // У�鷽�̸�����Ҳ��H��������
    ChkLen_bits = 7,                                            // У�鳤�ȣ�������λROM��ַ
    row_weight = 6,                                              // ���أ�����ûɶ��
    column_weight = 3,                                           // ���أ�Ҳûɶ��
    Iteration_Times = 50,                                        // һ�����н���BF��ת�Ĵ���
    Length = 6,                                                  // ����λ��
    Sigma_Iteration_Times = 20                                   // �����˶���������
    `define InfoLen (CodeLen - ChkLen)                          // ��Ϣ���صĳ���
)(
    input clk,
    input rst,
    input modulation_rst,
    
    // ����Ʋ��ֵĽ���
    input modulation_down,
    input [CodeLen-1:0] modulation_sequence_before,
    input demodulation_down_to_modulation_receive,
    output reg demodulation_down_to_modulation,
    output reg demodulation_receive,
    
    // ��RAM֮��Ľ���
    input RAM_read_receive,
    input demodulation_valid_a,
    input demodulation_valid_b,
    input [14:0] douta,
    input [14:0] doutb,
    output reg demodulation_read_RAM,
    
    // ����벿�ֵĽ���
    input demodulation_to_decoder_receive,
    output reg demodulation_down_to_decoder,
    output [Length*CodeLen-1:0] demodulation_sequence,
    output reg [CodeLen-1:0] demodulation_sequence_prototype
    );
    
    
    reg [2:0] demodulation_state;
    reg [Length-1:0] demodulation_sequence_reg[CodeLen-1:0];
    reg [CodeLen_bits:0] demodulation_a;
    reg [CodeLen_bits:0] demodulation_b;
    

    // �������������
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
                // ���ƽ�������ô���Կ�ʼ�����
                3'd0: begin
                    if(modulation_down) begin
                        demodulation_receive <= 'd1;
                        demodulation_state <= 3'd1;
                        demodulation_read_RAM <= 'd1;
                        demodulation_sequence_prototype <= modulation_sequence_before;
                    end
                end
                
                // ��ʼһ�������н��
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
                        // ����������ͽ�������ź�
                        demodulation_a <= 'd0;
                        demodulation_b <= 'd1;
                        demodulation_down_to_modulation <= 'd1;
                        demodulation_down_to_decoder <= 'd1;
                        demodulation_state <= 3'd3;
                    end
                end

                // �ȴ����Ʋ��ֺͽ��벿�ֵ��ź�
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
