/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: �洢PI�����ROM
*/

module ROM_PI#(parameter
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
    
    // ���벿����ROM�Ľ���
    input encoder_read_PI_matrix,                                // ���벿����Ҫ��ȡROM�е���Ϣ
    output reg PI_read_receive,                                  // ROM���յ��˱��벿�ִ������ź�
    output reg PI_valid,                                         // ROM��������Ч
    output [CodeLen-1:0] dout_PI                                 // ROM����������
    
    );
    
    reg [2:0] PI_state;
    reg PI_ROM_read_enable;
    reg PI_enable_d;
    reg [ChkLen_bits-1:0] ROM_PI_addr;
    
    
    // ��ȡPI����
    always@(posedge clk, negedge rst)begin
        if(~rst)begin
            PI_ROM_read_enable <= 'd0;
            ROM_PI_addr <= 'd0;
            PI_state <= 'd0;
            PI_read_receive <= 0;
        end
        else begin
            case(PI_state)
            // ��ʼ״̬�������벿�ַ��Ͷ��ź�ʱ����ʼ���ж�����
            3'd0: begin
                if(encoder_read_PI_matrix)begin
                    PI_read_receive <= 1;
                    PI_ROM_read_enable <= 1;
                    PI_state <= 3'd1;
                end
            end
            // ���ϸ��ݵ�ַ������ֱ����ROM�е�ֵȫ������һ��
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
            // ������ROM���ź�Ϊ0����ַ��0���ع��ʼ״̬
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

    // �������ģ���ΪROM�Ķ��������ӳ�
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
    
    // ����ROM
    PI_ROM u_PI(
        .addra(ROM_PI_addr),
        .clka(clk),
        .douta(dout_PI),
        .ena(PI_ROM_read_enable)
    );
    
endmodule
