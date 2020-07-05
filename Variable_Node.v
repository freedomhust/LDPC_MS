/*
    description: Variable Node module
    author name: neidong_fu
    time       : 2020/6/30
*/

`define UPDATE_VARIABLE    2'd0
`define WAIT_DECISION      2'd1

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
    // 校验节点的更新值
    input [`total_length-1:0]check_value_input,
    // 校验节点更新值可用
    input [weight-1:0]check_enable_input,
    // 判决结束
    input decision_down,
    // 变量节点更新值
    output reg [length-1:0]variable_value,
    // 变量节点更新完毕
    output reg variable_enable
    );
    
    reg [1:0] variable_state;
    
    // 将输入的check_value一一分解
    wire [length-1:0]check_value[weight-1:0];
    genvar i;
    generate
        for(i = 0; i < weight; i=i+1)begin:split
          assign check_value[i]  = check_value_input[(length*(i+1)-1) : length*i];
        end
    endgenerate

    integer j;
    always@(posedge clk or negedge rst) begin
        if(~rst) begin
            j <= 0;
            variable_value <= 0;
            variable_enable <= 0;
            variable_state <= `UPDATE_VARIABLE;
        end
        else begin
            case(variable_state)
                `UPDATE_VARIABLE: begin
                    // 当所有的校验更新值都有效时，开始更新节点
                    if(~check_enable_input == 'b0)begin
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
                        variable_state    <= `UPDATE_VARIABLE;
                    end
                end
            endcase
        end
    end
endmodule
