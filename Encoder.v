/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: ���벿��
*/

// ���벿��״̬��״̬
`define STATE_GenCode_IDLE          3'd0
`define STATE_GenCode_ING0          3'd1
`define STATE_GenCode_ING1          3'd2
`define STATE_GenCode_CHANGE_COLUMN 3'd3
`define STATE_GenCode_END           3'd4


module Encoder#(parameter
    CodeLen = 256,                                               // �볤
    ChkLen = 128,                                                // У�鷽�̸�����Ҳ��H��������
    row_weight = 6,                                              // ���أ�����ûɶ��
    column_weight = 3,                                           // ���أ�Ҳûɶ��
    Iteration_Times = 50,                                        // һ�����н���BF��ת�Ĵ���
    Sigma_Iteration_Times = 20,                                   // �����˶���������
    CodeLen_bits = 8,
    ChkLen_bits = 7
    `define InfoLen (CodeLen - ChkLen)                          // ��Ϣ���صĳ���
)(
    input clk,
    input rst,
    
    // ������з���������벿�ֵĽ���
    input random_sequence_ready,                                // ��Ϣ�����Ѿ����ɣ��ȴ����벿�ֽ���
    input [`InfoLen-1:0] random_sequence,                       // ����������������ɵ���Ϣ����
    output reg random_sequence_ready_receive,                  // ���벿�ֽ��յ���������з��������ɵ���Ϣ����
    
    
    // PI_ROM����벿�ֵĽ���
    input PI_read_receive,                                     // PI_ROM���յ��˱��벿�ָ��Ķ��ź�
    input PI_valid,                                            // ��ʱ���PI_ROM�ж�����������Ч
    input [CodeLen-1:0] dout_PI,                               // PI_ROM�ж�ȡ����������
    output reg encoder_read_PI_matrix,                         // ���벿�ָ�PI_ROM�Ķ��ź�
    
    
    // ���Ʋ�������벿�ֵĽ���
    input generate_code_down_receive,                          // ���Ʋ��ֽ��յ��˱��벿�ָ��ı�������ź�
    output reg generate_code_down,                             // �������
    output reg [CodeLen-1:0] Code_sequence                     // ����õ������ձ�������
    );



    reg [10:0] column_change_1[9:0];           // �������е����1
    reg [10:0] column_change_2[9:0];           // �������е����2
    reg [10:0] column_change_times;            // �����еĴ���
    
    // ������Ϣ�����Լ�����������
    reg [2:0] generate_code_sequence_state;               // ����״̬��
    reg random_sequence_enable;                           // ����������Ϣ������
    reg  [`InfoLen-1:0]Info_sequence;                     // ���벿�ֵ���Ϣ����
    reg  [ChkLen-1:0]Check_sequence;                      // У������
    integer code_i,code_j;
    
    
    //******************************************* �������е�����
    // ��H����ת�����֮��Ϳ��Կ�ʼ����У�������
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
                        // ������Ϣ�����������Ѿ����յ�����Ϣ���У����Կ�ʼ������һ����Ϣ������
                        random_sequence_ready_receive <= 1;
                        Info_sequence <= random_sequence;
                        code_i <= 0;
                        // ��ʼ��ȡPI����
                        encoder_read_PI_matrix <= 1;
                        generate_code_sequence_state <= `STATE_GenCode_ING0;
                    end
                end
                
                `STATE_GenCode_ING0: begin
                    random_sequence_ready_receive <= 0;
                    // �����ȡ�����Ѿ����յ����źţ���ô����������0��
                    if(PI_read_receive)begin
                        //$display("��ʼ�ȴ�PI�����ȡ����");
                        encoder_read_PI_matrix <= 0;
                        generate_code_sequence_state <= `STATE_GenCode_ING1;
                    end
                end
                
                `STATE_GenCode_ING1: begin
                    // ��ʼ����У������
                    if(code_i != ChkLen)begin
                        if(PI_valid)begin
                            Check_sequence[code_i] <= ^(dout_PI[ChkLen-1:0] & Info_sequence);
                            code_i <= code_i+1;
                        end
                    end
                    
                    // ȫ����ɺ�ʼƴ�ӣ�Ȼ��ʼ��һ����û�з����б仯���еĻ�Ҫ���л�����
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
                
                // У������Ѿ�ȫ�����ɣ��ȴ�У����
                `STATE_GenCode_END: begin
                    generate_code_down <= 1;
                    // �������У��������ȷ�ģ���ô�ص���ʼ״̬���ȴ�������һ��У������
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
