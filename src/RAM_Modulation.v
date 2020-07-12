/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: �洢���ƽ����RAM
*/

module RAM_Modulation#(parameter
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
    
    // ����Ʋ��ֽ��н���
    input write_enable_a,
    input write_enable_b,
    input modulation_write_down,
    input [CodeLen_bits:0] modulation_i,
    input [14:0] modulation_sequence_after_a,
    input [14:0] modulation_sequence_after_b,
    
    
    // �������ֽ��н���
    input demodulation_read_RAM,
    output reg RAM_read_receive,
    output reg demodulation_valid_a,
    output reg demodulation_valid_b,
    output [CodeLen-1:0] douta,
    output [CodeLen-1:0] doutb
    
    );
    
    wire [CodeLen_bits-1:0] addra,addrb;
    wire [14:0] dina,dinb;
    wire ena,enb;
    wire wea,web;
    
    reg [2:0] modulation_after_state;
    reg demodulation_RAM_read_enable_a;
    reg demodulation_RAM_read_enable_b;
    reg [CodeLen_bits:0] demodulation_addr_a;
    reg [CodeLen_bits:0] demodulation_addr_b;
    //reg RAM_read_receive;
    
    // ��ȡ���ƺ������
    always@(posedge clk, negedge rst, negedge modulation_rst)begin
        if(~rst || ~modulation_rst)begin
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
                // ������û�п����볤Ϊ���������������˵�����ſ����˵�ûд����
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
    
    // ��������
    always@(posedge clk, negedge rst, negedge modulation_rst) begin
        if(~rst || ~modulation_rst) begin
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

    assign addra = modulation_write_down ? demodulation_addr_a[CodeLen_bits-1:0] : modulation_i[CodeLen_bits-1:0]-'d2;
    assign addrb = modulation_write_down ? demodulation_addr_b[CodeLen_bits-1:0] : modulation_i[CodeLen_bits-1:0]-'d1;
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
    
endmodule
