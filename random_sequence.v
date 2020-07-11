/*
 * Author: neidong_fu
 * Time  : 2019/12/31
 * function: create random_sequence
*/
module random_sequence #(parameter sequence_length = 6) (
    // clk and rst
    input clk,
    input rst,
    
    input random_sequence_ready_receive,                   // random sequence ready signal receive

    output reg [sequence_length-1:0] random_sequence,          // random sequence
    output reg                       random_sequence_ready     // random sequence is ready
    
    );

// manual reg
reg [10:0] regPN;           // random number 
reg        regPN_extra;

reg [1:0]  state;           // FSM state
/*
    2'b00 : idle,waiting enable signal
    2'b01 : generate random sequence
    2'b10 : random sequence ready enable
    2'b11 : default
*/

reg [15:0] i;


// FSM comtroller
always @(posedge clk, negedge rst) begin
    if(~rst) begin
        regPN <= 11'b10011000101;
        state <= 2'b01;
        random_sequence_ready <= 1'b0;
        random_sequence <= 11'b0;
        regPN_extra <= 1'b0;
        i <= 0;
    end else begin
        case(state)
        /* 发现初始状态其实可以不要，就让它在生成序列和等待receive信号之间循环就可以了
        // 如果可以开始进行信息序列的产生那么就可是进行
        2'b00: begin
            if(random_sequence_enable) begin
                state <= 2'b01;
            end
            else begin
                state <= 2'b00;
            end
        end
        */
        // 循环左移，直到满足信息序列的长度
        2'b01: begin
            if(i != sequence_length-1) begin
                random_sequence[i] <= regPN[10];
                regPN_extra <= regPN[10] ^ regPN[3];
                regPN <= {regPN[9:0],regPN_extra};
                i <= i+1;
                state <= 2'b01;
            end
            else begin
                random_sequence_ready <= 1'b1;
                state <= 2'b10;
            end
        end

        // 相当于握手机制，只有等那边说已经接收到了信息序列才能开始进行下一个信息序列的产生
        2'b10: begin
            if(random_sequence_ready_receive)begin
                random_sequence_ready <= 1'b0;
                i <= 1'b0;
                state <= 2'b01;
            end
            else state <= 2'b10;
        end

        default: begin
            state <= 2'b01;
        end

        endcase


    end

end

endmodule
