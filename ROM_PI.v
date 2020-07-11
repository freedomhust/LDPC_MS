/*
 * Author: neidong_fu
 * Time  : 2020/03/31
 * function: 存储PI矩阵的ROM
*/

module ROM_PI#(parameter
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
    
    // 编码部分与ROM的交互
    input encoder_read_PI_matrix,                                // 编码部分想要读取ROM中的信息
    output reg PI_read_receive,                                  // ROM接收到了编码部分传来的信号
    output reg PI_valid,                                         // ROM的数据有效
    output [CodeLen-1:0] dout_PI                                 // ROM读出的数据
    
    );
    
    reg [2:0] PI_state;
    reg PI_ROM_read_enable;
    reg PI_enable_d;
    reg [ChkLen_bits-1:0] ROM_PI_addr;
    
    
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
            // 初始状态，当编码部分发送读信号时，开始进行读操作
            3'd0: begin
                if(encoder_read_PI_matrix)begin
                    PI_read_receive <= 1;
                    PI_ROM_read_enable <= 1;
                    PI_state <= 3'd1;
                end
            end
            // 不断根据地址递增，直到将ROM中的值全部遍历一遍
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
            // 结束后ROM读信号为0，地址归0，回归初始状态
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

    // 放慢两拍，因为ROM的读有两拍延迟
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
    
    // 调用ROM
    PI_ROM u_PI(
        .addra(ROM_PI_addr),
        .clka(clk),
        .douta(dout_PI),
        .ena(PI_ROM_read_enable)
    );
    
endmodule
