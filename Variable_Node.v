/*
    description: Variable Node module
    author name: neidong_fu
    time       : 2020/6/30
*/

`define INITIAL            2'd0
`define UPDATE_VARIABLE    2'd1
`define WAIT_DECISION      2'd2

module Variable_Node #(parameter
    // 有多少个校验节点与该变量节点相连
    weight = 3,
    // 位宽
    length = 15
    // 校验节点更新值输入的总位数
    `define total_length (weight*length)
)(
    // 时钟端
    input clk,
    // 清零端
    input rst,
    // 初始值
    input [length-1:0]initial_value,
    // 初始值有效
    input initial_value_enable,
    // 接收到初始值
    output reg initial_down,
    // 校验节点的更新值
    input [`total_length-1:0]check_value_input,
    // 校验节点更新值可用
    input [weight-1:0]check_enable_input,
    // 该次判决结束
    input decision_down,
    // 译码结束
    input decoder_down,
    // 变量节点判决值
    output reg [length-1:0] variable_value,
    // 变量节点给校验节点的值
    output [length*weight-1:0] value_variable_to_check,
    // 变量节点更新完毕
    output reg variable_enable
    );
    
    reg [1:0] variable_state;
    reg [length-1:0]value_variable_to_check_reg[weight-1:0];
    
    
    wire [length-1:0]check_value[weight-1:0];
    genvar i;
    generate
        for(i = 0; i < weight; i=i+1) begin:split
          // 将输入的check_value一一分解
          assign check_value[i] = check_value_input[(length*(i+1)-1) : length*i];
          // 将输出给校验节点的值进行组合
          assign value_variable_to_check[(length*(i+1)-1) : length*i] = value_variable_to_check_reg[i];
        end
    endgenerate

    integer k;
    // 发给校验节点的值,组合逻辑,注意一下阻塞赋值和非阻塞赋值
    always@(posedge variable_enable) begin
        for(k = 0; k < weight; k=k+1) begin
            value_variable_to_check_reg[k] = variable_value - check_value[k];
        end
    end

    integer j;
    reg [length-1:0] initial_value_reg;
    always@(posedge clk or negedge rst) begin
        if(~rst) begin
            j <= 0;
            initial_down <= 0;
            variable_enable <= 0;
            variable_state <= `INITIAL;
        end
        else begin
            case(variable_state)
                // 赋初值
                `INITIAL: begin
                  if(initial_value_enable)begin
                    variable_value <= initial_value;
                    initial_value_reg <= initial_value;
                    initial_down <= 1;
                    variable_state <= `UPDATE_VARIABLE;
                  end
                end

                `UPDATE_VARIABLE: begin
                    initial_down <= 0;
                    // 当所有的校验更新值都有效时，开始更新节点
                    if(~check_enable_input == 0)begin
                        // 变量节点更新（可能需要考虑溢出的问题）TBD
                        variable_value <= variable_value+check_value[j];
                        j <= j+1;
                        if(j == weight) begin
                            variable_enable  <= 1;
                            variable_state   <= `WAIT_DECISION;
                            j <= 0;
                        end
                    end
                end
                
                `WAIT_DECISION: begin
                    if(decision_down) begin
                        variable_enable <= 0;
                        variable_value <= initial_value_reg;
                        if(decoder_down) begin
                          variable_state <= `INITIAL;
                        end
                        else begin
                          variable_state <= `UPDATE_VARIABLE;
                        end
                    end
                end
            endcase
        end
    end
endmodule
