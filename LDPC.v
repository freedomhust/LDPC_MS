/*
 * Author: neidong_fu
 * Time  : 2020/01/07
 * function: LDPC fraction
*/

// ��˹��ԪH�����״̬
`define STATE_HCHANGE_INIT          3'd0
`define STATE_HCHANGE_FINDI         3'd1
`define STATE_HCHANGE_CHANGE_COLUMN 3'd2
`define STATE_HCHANGE_CHANGE_ROW    3'd3
`define STATE_HCHANGE_END           3'd4

// ���벿��״̬��״̬
`define STATE_GenCode_IDLE          3'd0
`define STATE_GenCode_ING0          3'd1
`define STATE_GenCode_ING1          3'd2
`define STATE_GenCode_CHANGE_COLUMN 3'd3
`define STATE_GenCode_END           3'd4

module LDPC #(parameter
    CodeLen = 512,                                               // �볤
    ChkLen = 256,                                                // У�鷽�̸�����Ҳ��H��������
    row_weight = 6,                                              // ���أ�����ûɶ��
    column_weight = 3,                                           // ���أ�Ҳûɶ��
    Iteration_Times = 50,                                        // һ�����н���BF��ת�Ĵ���
    Sigma_Iteration_Times = 20                                   // �����˶���������
    `define InfoLen (CodeLen - ChkLen)                          // ��Ϣ���صĳ���
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
    
    reg [10:0] column_change_1[9:0];           // �������е����1
    reg [10:0] column_change_2[9:0];           // �������е����2
    reg [10:0] column_change_times[1:0];       // �����еĴ���
    
    // read H_matrix File
    initial begin
        $readmemb("H:/graduation_project/LDPC/change_column_times_512_256.txt",column_change_times);
        $readmemb("H:/graduation_project/LDPC/column_change_1_512_256.txt",column_change_1);
        $readmemb("H:/graduation_project/LDPC/column_change_2_512_256.txt",column_change_2);
    end
    
    reg [20:0] count;                          // debug ��

    integer i,j;
    
    // ������Ϣ�����Լ�����������
    reg [2:0] generate_code_sequence_state;               // ����״̬��
    reg random_sequence_enable;                           // ����������Ϣ������
    reg random_sequence_ready_receive;                    // ���벿�ֽ��յ���������з��������ɵ���Ϣ����
    reg encode_check_result_receive;                      // ���벿���Ѿ����յ���У��Ľ��
    wire [`InfoLen-1:0]random_sequence;                   // ����������������ɵ���Ϣ����
    reg  [`InfoLen-1:0]Info_sequence;                     // ���벿�ֵ���Ϣ����
    reg  [ChkLen-1:0]Check_sequence;                      // У������
    reg  [CodeLen-1:0]Code_sequence;                      // ���ı�������
    reg generate_code_down;                               // ���������Ѿ��������
    wire random_sequence_ready;                           // ��Ϣ�����Ѿ����ɣ��ȴ����벿�ֽ���
    reg encoder_read_PI_matrix;                           // ׼����ȡROM����
    reg generate_code_down_receive;                       // ���Ʋ����Ѿ����յ��˱��������
    
    // ������
    reg modulation_check_result_receive;                  // ���Ʋ��ֽ��յ���У�鲿�ֵĽ��
    
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
    
    //******************************************* ��Ϣ���е�����
    random_sequence #(.sequence_length(`InfoLen))u_random_sequence(
        .clk(clk),
        .rst(rst),
        
        .random_sequence_ready_receive(random_sequence_ready_receive),
        .random_sequence(random_sequence),
        .random_sequence_ready(random_sequence_ready)
    );
    
    integer code_i,code_j; 
    
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
    
    // ��������
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
    
    
    //******************************************* �������е�����
    // ��H����ת�����֮��Ϳ��Կ�ʼ����У�������
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
                        //$display("��ʼ����");
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
                    encode_check_result_receive <= 0;
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
                            //$display("%b",dout_PI);
                            code_i <= code_i+1;
                        end
                    end
                    
                    // ȫ����ɺ�ʼƴ�ӣ�Ȼ��ʼ��һ����û�з����б仯���еĻ�Ҫ���л�����
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
                
                // У������Ѿ�ȫ�����ɣ��ȴ�У����
                `STATE_GenCode_END: begin
                    generate_code_down <= 1;
                    // �������У��������ȷ�ģ���ô�ص���ʼ״̬���ȴ�������һ��У������
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
    
    //******************************************* ����
    reg [2:0]modulation_state;                                          // ����״̬��
    reg [CodeLen-1:0] modulation_sequence_before;                       // δ����ǰ��ԭ����
    reg [14:0] modulation_sequence_after_a;                             // ���ƺ������
    reg [14:0] modulation_sequence_after_b;
    reg [9:0] modulation_i;                                              // ���Ƽ�����                                             
    reg modulation_down;                                               // ���ƽ��������Կ�ʼ�����
    reg demodulation_down_to_modulation_receive;                       // ���Ʋ��ֽ��յ��˽�����ָ����Ľ�������ź�
    reg write_enable_a;
    reg write_enable_b;
    reg modulation_write_down;
    
    
    // ���
    reg demodulation_receive;                                          // ��������Ѿ����յ��˵��ƽ����ź�
    reg demodulation_down_to_modulation;                               // ������ַ������Ʋ��ֵĽ�������ź�
    reg demodulation_down_to_decoder;                                  // ������ַ������벿�ֵĽ�������ź�
    
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
            // afterҪ��ʼ���Ļ���Դ����̫���ˣ�����ʼ��Ҳû����
        end
        else begin
            case(modulation_state)
                3'd0: begin
                    modulation_down <= 0;
                    demodulation_down_to_modulation_receive <= 'd0;
                    // ���У����ȷ����ô��ʼ���е���
                    if(generate_code_down && AWGN_valid) begin
                        modulation_i <= 0;
                        modulation_sequence_before <= Code_sequence;
                        generate_code_down_receive <= 'd1;
                        modulation_state <= 'd1;
                        //write_enable_a <= 1;
                        //write_enable_b <= 1;
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
                        //$display("���ƽ���");
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

    //****************************************** AWGN
    // �������������Լ�ִ�оͺã�����ԴԴ���ϵ���������������
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
    
    // ��ȡ���ƺ������
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
    reg demodulation_valid_a;
    reg demodulation_valid_b;
    
    // ��������
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
    
    //****************************************** ���
    
    reg [CodeLen-1:0] demodulation_sequence;
    reg [CodeLen-1:0] demodulation_sequence_prototype;
    integer demodulation_i;
    reg [2:0] demodulation_state;
    reg [9:0] demodulation_a;
    reg [9:0] demodulation_b;
    
    
    // ����
    reg demodulation_to_decoder_receive;                                 // ���벿���Ѿ����յ��˽���������
    
    
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
                            demodulation_sequence[demodulation_a] <= douta[14];
                            demodulation_a <= demodulation_a + 2;
                        end
                        if(demodulation_valid_b)begin
                            demodulation_sequence[demodulation_b] <= doutb[14];
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


    // ROM��ȡ������Ҫ�������ڵ��ӳ�
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
    // ��ȡPI����
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


    //***************************************** ����
    reg [2:0] decode_state;                                              // ״̬��״̬
    reg [CodeLen-1:0] decoder_sequence;                                  // ��������
    reg check_flag;                                                      // ��������У�鷽���Ƿ�Ϊ0
    reg  check_result;                                       // ÿһ��У�鷽��У����ֵ
    reg [CodeLen-1:0] counter_signal;                                    // counter�ļ����ź�
    reg [10:0] iteration_times;                                          // ��¼�����Ĵ���
    integer check_number_encoder;                                        // ��¼һ��У���Ѿ����е����ĸ�λ��
    reg counter_rst;                                                     // counter��������rst�ź�
    integer FIND_MAX_i;                                                  // ����ֵ�����Ƚϴ�С�Ƚϵ��ĸ��ط���
    reg [10:0] max_value;                                                // �洢��couter�������е����ֵ
    reg [10:0] max_value_number;                                         // �洢��counter�����������ֵ�����
    reg decode_down;                                                     // �������
    reg [CodeLen-1:0]decoder_sequence_prototype;                         // ���ڽ�������еĳ�ʼ����
    integer decoder_compare_number;                                     // 

    reg [CodeLen-1:0] decoder_check;
    
    // counter���� ��ÿ���ڵ�Ĵ��󷽳̸������м���
    wire [2:0] sum[CodeLen-1:0];                                         // counter����ֵ
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
    
    // ״̬������
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
                    // ��������ˣ��������ַ���receive�źţ����ս���ı���
                    if(demodulation_down_to_decoder)begin
                        demodulation_to_decoder_receive <= 1'd1;
                        decoder_read_H_matrix <= 1'd1;
                        decoder_sequence <= demodulation_sequence;
                        // �洢��ʼ���У�Ϊ�˽���biterror����
                        decoder_sequence_prototype <= demodulation_sequence_prototype;
                        decode_state <= 3'd1;
                        counter_signal <= 'd0;
                        $display("���뿪ʼ �������� %d",decoder_Code_counter);
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
                    // ��ʼ���н���У�飬����ÿ��У�鷽���Ƿ�Ϊ0
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
                    // ���е�У�鷽�̶��Ѿ�У������
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
                    // ���ȿ�У���Ƿ�����ȷ��
                    if(check_flag && iteration_times < Iteration_Times)begin
                        // �������ȷ��ô��ʼ�ҵ����ļ���ֵ
                        if(FIND_MAX_i < CodeLen) begin
                            //$display("sum[%d] = %d, max_value = %d, max_value_number = %d",FIND_MAX_i,sum[FIND_MAX_i],max_value,max_value_number);
                            if(sum[FIND_MAX_i] > max_value)begin
                                max_value <= sum[FIND_MAX_i];
                                max_value_number <= FIND_MAX_i;
                            end
                            FIND_MAX_i <= FIND_MAX_i+1;
                        end
                        else begin
                            // �ȴ��������ֵ���ֽ����ֵ�ҵ��������ֵ����Ž��з�ת
                            decoder_sequence[max_value_number] <= ~decoder_sequence[max_value_number];
                            // ��ת���������У�飬����������һ������һ�±ߵ����,counter����ֵ����Ϊ0
                            iteration_times <= iteration_times+1;
                            counter_rst <= 'd0;
                            check_number_encoder <= 'd0;
                            check_flag <= 'd0;
                            decoder_read_H_matrix <= 'd1;
                            decode_state <= 3'd1;
                        end
                    end
                    
                    // ���������˵��BF����û�гɹ������Ѿ����˵��������ˣ����ԶԴ�����������м���
                    else if(check_flag)begin
                        // һ�������бȽϣ������һ�������ֵ++
                        if(decoder_compare_number < CodeLen)begin
                            if(decoder_sequence_prototype[decoder_compare_number] != decoder_sequence[decoder_compare_number])begin
                                biterror_counter <= biterror_counter+1;
                            end
                            decoder_compare_number <= decoder_compare_number + 1;
                        end
                        // ������Ϻ�ʼ�Խ������++
                        else begin
                            $display("�������� %d ʧ��",decoder_Code_counter);
                            decoder_Code_counter <= decoder_Code_counter+1;
                            decode_down <= 'd1;
                            decode_state <= 3'd4;
                        end
                    end
                    
                    // ������˵������ɹ��ˣ�����
                    else begin
                        $display("�������� %d �ɹ�",decoder_Code_counter);
                        decoder_Code_counter <= decoder_Code_counter+1;
                        decode_down <= 'd1;
                        decode_state <= 3'd4;
                    end
                end
                
                
                3'd4: begin
                    // �����������ϡ��С��Sigma_Iteration_Times����ô�������
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
