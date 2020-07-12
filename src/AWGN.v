/*
 * Author: neidong_fu
 * Time  : 2020/01/21
 * function: create noise sample 
*/


module AWGN(
    // clk and rst
    input clk,
    input rst,
    input modulation_rst,
    
    input enable,
    input pop,
    input [9:0]sigma,
    input [95:0] s0,
    input [95:0] s1,
    
    output reg valid,
    output reg [14:0]noise0_fix5p10,
    output reg [14:0]noise1_fix5p10
    );
    
    /*
    wire [31:0] a,b;
    wire [47:0] u0;
    wire [15:0] u1;
    

    
    URNG URNG_A(
        .clk(clk),
        .rst(rst),
        .s0(s0_A),
        .s1(s1_A),
        .s2(s2_A),
        .out(a)
    );
    
    URNG URNG_B(
        .clk(clk),
        .rst(rst),
        .s0(s0_B),
        .s1(s1_B),
        .s2(s2_B),
        .out(b)
    );
    
    assign u0 = {a,b[31:16]};
    assign u1 = b[15:0];
    
    */
    
    wire [31:0] a;                      // URNG0 out (0,32,0)
    wire [31:0] b;                      // URNG0 out (0,32,0)
    wire [47:0] u0;                             // (0,0,48)
    wire [15:0] u1;                             // (0,0,16)
    wire [13:0] u1_14bits;                      // (0,0,14)
    
    reg pop_d1,pop_d2;                          // delay pop signal for 1 cycle
    
    wire u_sign;
    wire [6:0] u_exp;
    wire [9:0] u_man;
    
    wire [14:0] u_exp_out;
    wire [13:0] u_man_out;
    wire [15:0] u_out;                          // the result of -2ln(u0)
    
    wire log_sign;                              // -2ln(u0) = (-1)^log_sign * log_man * log_exp
    wire [6:0] log_exp;
    wire [9:0] log_man;
    
    wire [11:0] buff1;                          // sqrt(log_exp)
    wire [11:0] buff2;                          // sqrt(log_man)
    reg [11:0] buff1_reg;
    reg [11:0] buff2_reg;
    
    wire [23:0] sqrt_out_4p20;                  // buff1 * buff2
    wire [24:0] sqrt_out_5p20;                  // extand a sign bit
    wire [16:0] sqrt_out_5p12;                  // cut 8 bits
    
    reg [1:0] seg;                              // select a quadrant
    reg [1:0] seg_d1;                           // delay 1 cycle
    
    wire [9:0] index1;                          // cos LUT index
    wire [10:0] index1_inv;                      // sin LUT index
    
    reg [10:0] index_cos;                       // cos LUT index
    reg [10:0] index_sin;                       // sin LUT index
    
    wire [13:0] cos_LUT_out_pre;                       // delay cos LUT for one cycle
    wire [13:0] sin_LUT_out_pre;
    reg [13:0] cos_LUT_out;
    reg [13:0] sin_LUT_out;
    
    reg [30:0] buff_fix5p26_noise0;
    reg [30:0] buff_fix5p26_noise1;
    wire [16:0] buff_fix5p12_noise0;
    wire [16:0] buff_fix5p12_noise1;
    
    wire [26:0] noise0_abs_fix4p23;
    wire [26:0] noise1_abs_fix4p23;
    wire [27:0] noise0_abs_fix5p23;
    wire [27:0] noise1_abs_fix5p23;
    
    
    reg enable_d;
    reg enable_dd;
    
    //------------------------                      
    // logic design
    //------------------------
    
    //------------------------
    // seed init
    //------------------------
    
    wire [31:0] s0_0 = s0[31:0];
    wire [31:0] s1_0 = s0[63:32];
    wire [31:0] s2_0 = s0[95:64];
    wire [31:0] s0_1 = s1[31:0];
    wire [31:0] s1_1 = s1[63:32];
    wire [31:0] s2_1 = s1[95:64];
    
    //------------------------
    // pipeline control
    // -----------------------
    
    always@(posedge clk or negedge rst or negedge modulation_rst)begin
        if(~rst || ~modulation_rst) begin
            {pop_d2,pop_d1} <= 2'd0;
        end
        else begin
            {pop_d2,pop_d1} <= {pop_d1,pop};
        end
    end
    
    URNG URNG_A(
        .clk(clk),
        .rst(rst),
        .s0(s0_0),
        .s1(s1_0),
        .s2(s2_0),
        .out(a)
    );
    
    URNG URNG_B(
        .clk(clk),
        .rst(rst),
        .s0(s0_1),
        .s1(s1_1),
        .s2(s2_1),
        .out(b)
    );

    assign u0 = {a,b[31:16]};
    assign u1 = b[15:0];
    assign u1_14bits = u1[15:2];

    //---------------------------------------------
    // log_u0 = -2ln(u0)
    //---------------------------------------------

    // fix2float(u0):
    // u0(0,0,48)
    // u0_exp(1,6,0)
    // u0_man(0,0,10)
    // u0 = (-1)^u0_sign * u0_man * 2^u0_exp

    FIX_to_FLOAT_48 FIX_to_FLOAT_48(
        //outputs
        .sign                     (u_sign),
        .exp                      (u_exp),
        .mantissa                 (u_man),
        // inputs
        .in                       (u0)
    );

    // -2ln(u0)
    // = -2ln(2^(u0_exp)*u0_man)
    // = -2ln2 * u0_exp + (-2ln(u0_man))
    // u0_exp_out(1,0,14)

    exp_log exp_log(
        //outputs
        .out                       (u_exp_out),
        //inputs
        .in                        (u_exp)
    );

    // u0_man_out(0,0,14)

    man_log man_log(
        //outputs
        .out                       (u_man_out),
        //inputs
        .in                        (u_man)
    );

    assign u_out = u_exp_out + u_man_out;

    //-----------------------------
    // sqrt(log_u0)
    //-----------------------------

    // fix2float(log):
    // u0_out(0,0,15) -> log_u0(0,2,15)
    // log_u0_exp(1,6,0)
    // log_u0_man(0,0,10)

    FIX_to_FLOAT_7 FIX_to_FLOAT_7(
        //outputs
        .sign                      (log_sign),
        .exp                       (log_exp),
        .mantissa                  (log_man),
        //inputs
        .in                        (u_out[14:0])
    );

    // sqrt(log_u0)
    // = sqrt(2^(log_u0_exp) * log_u0_man)
    // = sqrt(2^(log_u0_exp) * sqrt(log_u0_man))
    // sqrt_log_u0_exp(0,0,12)

    exp_sqrt exp_sqrt(
        //outputs
        .out                       (buff1),
        //inputs
        .in                        (log_exp)
    );

    // sqrt_log_u0_man(0,0,12)

    man_sqrt man_sqrt(
        //outputs
        .out                        (buff2),
        //inputs
        .in                         (log_man)
    );

    //delay buff one cycle for timing
    always@(posedge clk or negedge rst or negedge modulation_rst)begin
        if(~rst || ~modulation_rst) begin
            buff1_reg[11:0] <= 12'd0;
            buff2_reg[11:0] <= 12'd0;
        end
        else if(pop_d1) begin
            buff1_reg[11:0] <= buff1;        
            buff2_reg[11:0] <= buff2;        
        end
    end

    // Firstly multiply: (0,0,12)*(0,0,12) -> (1,4,20)
    // Then cut 8bits: (1,4,20) -> (1,4,12)

    assign sqrt_out_4p20 = buff1_reg * buff2_reg;
    assign sqrt_out_5p20 = {1'b0,sqrt_out_4p20};
    assign sqrt_out_5p12 = sqrt_out_5p20[24:8];

    //-----------------------------------------
    // sin/cos(2*pi*u1)
    //-----------------------------------------

    // u1(0,14,0) for 0~2pi
    // index1 [9:0]
    // index_inv [10:0]

    assign index1 = u1_14bits[11:2];
    assign index1_inv = 1024 - {1'b0,index1};

    always@(*)begin
        index_cos = {1'b0,index1};
        index_sin = index1_inv;
    end

    // LUT in (0,10,0)
    // LUT out (0,0,14)

    cos_quad_LUT cos (
        //outputs
        .out                               (cos_LUT_out_pre),
        //inputs
        .in                                (index_cos)
    );

    cos_quad_LUT sin (
        // outputs
        .out                               (sin_LUT_out_pre),
        // inputs
        .in                                (index_sin)
    );

    // 'cos/sin_LUT_out' be aliased to 'sqrt_out_5p12'
    always@(posedge clk or negedge rst or negedge modulation_rst)begin
        if(~rst || ~modulation_rst) begin
            cos_LUT_out[13:0] <= 14'd0;
            sin_LUT_out[13:0] <= 14'd0;
        end
        else if(pop_d1) begin
            cos_LUT_out[13:0] <= cos_LUT_out_pre;
            sin_LUT_out[13:0] <= sin_LUT_out_pre;
        end
    end

    //------------------------------------------
    // (cos_out,in_out)*sqrt_out
    //------------------------------------------

    // Multiply: (0,0,14)*(1,4,12)->(1,4,26)
    always@(posedge clk or negedge rst or negedge modulation_rst) begin
        if(~rst || ~modulation_rst) begin
            buff_fix5p26_noise0 <= 'd0;
            buff_fix5p26_noise1 <= 'd0;
        end
        else if(pop_d2)begin
            buff_fix5p26_noise0 <= cos_LUT_out[13:0]*sqrt_out_5p12;
            buff_fix5p26_noise1 <= sin_LUT_out[13:0]*sqrt_out_5p12;
        end
    end

    // cut and saturate (sat 1bit and cut 13bits) : (1,4,26) -> (0,5,12)
    assign buff_fix5p12_noise0 = buff_fix5p26_noise0[30] ? {(17){1'b1}} : buff_fix5p26_noise0[29:13];
    assign buff_fix5p12_noise1 = buff_fix5p26_noise1[30] ? {(17){1'b1}} : buff_fix5p26_noise1[29:13];

    // (0,5,12)*(0,0,10)->(1,4,23)
    assign noise0_abs_fix4p23 = sigma*buff_fix5p12_noise0;
    assign noise0_abs_fix5p23 = {1'b0,noise0_abs_fix4p23};

    assign noise1_abs_fix4p23 = sigma*buff_fix5p12_noise1;
    assign noise1_abs_fix5p23 = {1'b0,noise1_abs_fix4p23};

    // delay 'seg_d1' one more cycle to alias with 'buff_fix5p26_noise'
    always@(posedge clk or negedge rst or negedge modulation_rst)begin
        if(~rst || ~modulation_rst)begin
            seg <= 2'd0;
        end
        else if(pop_d1)begin
            seg <= u1_14bits[13:12];
        end
    end
    
    always@(posedge clk or negedge rst or negedge modulation_rst)begin
        if(~rst || ~modulation_rst)begin
            seg_d1 <= 'd0;
        end
        else if(pop_d2)begin
            seg_d1 <= seg;
        end
    end

    // phase segment selection and bit cut
    // (1,4,23)->(1,4,10)
    always@(*)begin
        case (seg_d1)
            2'd0: begin
                noise0_fix5p10 = noise0_abs_fix5p23[27:13];
                noise1_fix5p10 = noise1_abs_fix5p23[27:13];
            end
            2'd1: begin
                noise0_fix5p10 = ~noise1_abs_fix5p23[27:13]+1;
                noise1_fix5p10 = noise0_abs_fix5p23[27:13];
            end
            2'd2: begin
                noise0_fix5p10 = ~noise0_abs_fix5p23[27:13]+1;
                noise1_fix5p10 = ~noise1_abs_fix5p23[27:13]+1;
            end
            2'd3: begin
                noise0_fix5p10 = noise1_abs_fix5p23[27:13];
                noise1_fix5p10 = ~noise0_abs_fix5p23[27:13]+1;
            end
         endcase
    end

    //------------------------------------
    // output valid control
    //------------------------------------

    always@(posedge clk or negedge rst or negedge modulation_rst)begin
        if(~rst || ~modulation_rst) begin
            valid <= 1'b0;
            enable_d <= 1'b0;
            enable_dd <= 1'b0;
        end
        else begin
            enable_d <= enable;
            enable_dd <= enable_d;
            valid <= enable_dd;
        end
    end
      
    
    
    
//    always@(posedge clk, negedge rst)begin
//    if(valid)begin
//            //$display("a = %b",a);
//            //$display("b = %b",b);
//            $display("noise0_fix5p10 = %b",noise0_fix5p10);
//            $display("noise1_fix5p10 = %b",noise1_fix5p10);
//    end
//    end  

    
endmodule
