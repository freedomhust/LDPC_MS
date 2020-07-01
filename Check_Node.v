/*
    description: Variable Node module
    author name: neidong_fu
    time       : 2020/6/30
*/


`define WAIT_VARIABLE 2'd0
`define FIND_MIN      2'd1
`define UPDATE_CHECK  2'd2

module Check_Node #(parameter
  // 校验节点与多少个变量节点相连
  weight = 6,
  // 浮点数的位宽
  float_length = 15
  // 变量节点输入和校验节点输出的总位数
  `define total_length (weight*float_length)
)(
  // 时钟端
  input clk,
  // 清零端
  input rst,
  // 校验节点开始进行更新信号
  input check_begin,
  // 变量节点值
  input [`total_length-1:0] variable_value_input,
  // 变量节点值有效
  input [weight-1:0] variable_enable_input,
  // 判决结束
  input decision_down,
  // 判决是否成功
  input decision_success,
  // 这个暂时好像没用
  output reg decision_down_receive,
  // 校验节点给变量节点的更新值
  output [`total_length-1:0] check_value_output,
  // 更新值有效
  output [weight-1:0] check_enable_output
  );

  // 状态机
  reg  [1:0]check_state;
  // 最小和算法中的符号值
  reg  sign;
  // 最小值
  reg  [float_length-1:0] Minimum_value;
  // 次小值
  reg  [float_length-1:0] Second_Minimum_value;
  // 给不同变量节点的更新值
  reg  [float_length-1:0] check_value[weight-1:0];
  // 变量节点的绝对值
  wire [float_length-1:0] variable_value[weight-1:0];
  // 校验节点更新值有效
  reg  check_enable[weight-1:0];
  // 变量节点值有效
  wire variable_enable[weight-1:0];
  // 变量节点值的正负
  wire [weight-1:0]variable_value_sign;

  // 将变量节点值取绝对值,取出符号位
  genvar k;
  generate
    for (k = 0; k<weight; k=k+1) begin
      assign variable_value[k] = variable_value_input[float_length*(k+1) - 1] ? ~(variable_value_input[float_length*(k+1) - 1 : float_length*k])+'d1 : variable_value_input[float_length*(k+1) - 1 : float_length*k];
      assign variable_enable[k] = variable_enable_input[k];
      assign variable_value_sign[k] = variable_value_input[float_length*(k+1)-1];
    end
  endgenerate


  // 调整输出格式
  generate
    for (k = 0; k<weight; k=k+1) begin
      assign check_value_output[float_length*(k+1) - 1 : float_length*k] = check_value[k];
      assign check_enable_output[k] = check_enable[k];
    end
  endgenerate

  integer i,j;
  always@(posedge clk or negedge rst)begin
    if(~rst) begin
      // 初始化
      j <= 0;
      sign <= 0;
      check_state <= `WAIT_VARIABLE;
      Minimum_value <= 0;
      Second_Minimum_value <= 0;
      /*需要好好考虑一下要不要用generate*/
      for (i = 0; i<weight; i=i+1) begin
        check_value[i] <= 0;
        check_enable[i] <= 1'b1;
      end
    end
    else begin
      case(check_state)
        // 将check_enable重置为0
        `WAIT_VARIABLE: begin
          /*需要好好考虑一下要不要用generate*/
          for(i = 0; i < weight; i = i+1) begin
            if(variable_enable[i]) check_enable[i] <= 1'b0;
          end
          // 判决结束，发现校验不成功，开始更新变量节点的值
          /*需要考虑一下这个判决要不要放在top模块，然后只传一个check_begin进来*/
          if(decision_down & ~decision_success)begin
              // 这里为查找最小值和次小值做准备
              if(variable_value[0] < variable_value[1])begin
                Minimum_value <= variable_value[0];
                Second_Minimum_value <= variable_value[1];
              end
              else begin
                Minimum_value <= variable_value[1];
                Second_Minimum_value <= variable_value[0];
              end
              j <= 2;
              check_state <= `FIND_MIN;
          end
        end
        // 查找最小值和次小值
        `FIND_MIN: begin
          if(j == weight) begin
            // 所有值相乘后的正负
            sign <= ^variable_value_sign;
            check_state <= `UPDATE_CHECK;
            j <= 0;
          end
          else begin
            if(variable_value[j] < Minimum_value) begin
              Minimum_value <= variable_value[j];
            end
            else if(variable_value[j] < Second_Minimum_value) begin
              Second_Minimum_value <= variable_value[j];
            end
            j <= j+1;
          end
        end
        // 更新校验节点
        `UPDATE_CHECK: begin
          // 更新结束,变换状态，等待变量节点更新完毕
          if(j == weight)begin
            j <= 0;
            check_state <= `WAIT_VARIABLE;
          end
          else begin
            // 如果自己是最小值，那么更新值就是次最小值
            if(variable_value[j] == Minimum_value)begin
              // 如果是负数，取反加一
              if(sign^variable_value_sign[j])begin
                check_value[j] <= ~Second_Minimum_value + 'd1;
              end
              else begin
                check_value[j] <= Second_Minimum_value;
              end
            end
            // 否则一直是最小值
            else begin
              // 如果是负数，取反加一
              if(sign^variable_value_sign[j])begin
                check_value[j] <= ~Minimum_value + 'd1;
              end
              else begin
                check_value[j] <= Minimum_value;
              end
            end
            check_enable[j] <= 1;
            j <= j+1;
          end
        end
      endcase
    end
  end
endmodule
