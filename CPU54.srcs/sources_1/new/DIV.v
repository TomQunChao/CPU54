`timescale 1ns / 1ps

module DIV(
    input [31:0]dividend,
    input [31:0]divisor,
    input en,
    input clock,
    input reset,
    input alu_u,
    output [31:0]o_q,
    output [31:0]o_r,
    output busy
    );
    wire ready;
    reg [4:0]count;
    reg [31:0]reg_q;//商
    reg [31:0]reg_r;//余数
    reg [31:0]reg_b;//除数
    reg busy2,busy1,r_sign;
    assign busy=busy1|busy2;
    //adder
    wire [32:0]sub_add=r_sign?({reg_r,reg_q[31]}+{1'b0,reg_b}):({reg_r,reg_q[31]}-{1'b0,reg_b});
    wire [31:0]r=r_sign?reg_r+reg_b:reg_r;
    wire [31:0]q=reg_q;
    always @ (posedge clock or posedge reset)
    begin
        if(reset==1)
        begin
            reg_r<=0;
            reg_q<=0;
            count<=5'b0;
            busy1<=0;
            busy2<=0;
        end
        else
        begin
            if(en)
            begin
                reg_r=8'b0;
                r_sign<=0;
                reg_q<=dividend[31]?-dividend:dividend;
                reg_b<=divisor[31]?-divisor:divisor;
                count<=5'b0;
                busy1<=1'b1;
            end
            else if(busy1)
            begin
                reg_r=sub_add[31:0];
                r_sign<=sub_add[32];
                reg_q<={reg_q[30:0],~sub_add[32]};
                count<=count+5'b1;
                if(count==5'h1f)begin
                    busy1<=0;
                    busy2<=1;
                end
            end
            else if(busy2)begin
                busy2<=0;
            end
        end
    end
    assign o_q=busy?((~alu_u&(dividend[31]^divisor[31]))?-q:q):32'bz;
    assign o_r=busy?((~alu_u&dividend[31])?-r:r):32'bz;
endmodule
