/*
 * Author: neidong_fu
 * Time  : 2020/01/20
 * function: create GDF random number 
*/

module URNG(
    // clk and rst
    input clk,
    input rst,
    
    input [31:0] s0,
    input [31:0] s1,
    input [31:0] s2,
    
    output [31:0] out
    );
    
    reg [31:0]b0;
    reg [31:0]b1;
    reg [31:0]b2;
    reg [31:0]s0_reg;
    reg [31:0]s1_reg;
    reg [31:0]s2_reg;
    reg [31:0]s0_tmp;
    reg [31:0]s1_tmp;
    reg [31:0]s2_tmp;
    
    
    always@(*)begin
        s0_tmp = s0_reg & 32'hFFFFFFFE;
        s1_tmp = s1_reg & 32'hFFFFFFF8;
        s2_tmp = s2_reg & 32'hFFFFFFF0;
    end
    
    always@(*)begin
        b0 = (((s0_reg<<13)^s0_reg)>>19);
        b1 = (((s1_reg<<2)^s1_reg)>>25);
        b2 = (((s2_reg<<3)^s2_reg)>>11);
    end
    
    always@(posedge clk, negedge rst)begin
        if(~rst) begin
            s0_reg <= s0;
            s1_reg <= s1;
            s2_reg <= s2;
        end
        else begin
                s0_reg <= (((s0_tmp)<<12)^b0);
                s1_reg <= (((s1_tmp)<<4)^b1);
                s2_reg <= (((s2_tmp)<<17)^b2);
        end
    end
    
    assign out = s0_reg ^ s1_reg ^s2_reg;
    
endmodule
