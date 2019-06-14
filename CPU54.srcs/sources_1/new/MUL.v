`timescale 1ns / 1ps
module MUL(
    input alu_u,
    input mul_en,
    input [31:0]a,
    input [31:0]b,
    output [63:0]z
    );
wire [31:0]mula=~alu_u&a[31]?-a:a;
wire [31:0]mulb=~alu_u&b[31]?-b:b;

wire[63:0]r0=mulb[0]?{32'b0,mula}:63'b0;
wire[63:0]r1=mulb[1]?{31'b0,mula,1'b0}:63'b0;
wire[63:0]r2=mulb[2]?{30'b0,mula,2'b0}:63'b0;
wire[63:0]r3=mulb[3]?{29'b0,mula,3'b0}:63'b0;
wire[63:0]r4=mulb[4]?{28'b0,mula,4'b0}:63'b0;
wire[63:0]r5=mulb[5]?{27'b0,mula,5'b0}:63'b0;
wire[63:0]r6=mulb[6]?{26'b0,mula,6'b0}:63'b0;
wire[63:0]r7=mulb[7]?{25'b0,mula,7'b0}:63'b0;
wire[63:0]r8=mulb[8]?{24'b0,mula,8'b0}:63'b0;
wire[63:0]r9=mulb[9]?{23'b0,mula,9'b0}:63'b0;
wire[63:0]r10=mulb[10]?{22'b0,mula,10'b0}:63'b0;
wire[63:0]r11=mulb[11]?{21'b0,mula,11'b0}:63'b0;
wire[63:0]r12=mulb[12]?{20'b0,mula,12'b0}:63'b0;
wire[63:0]r13=mulb[13]?{19'b0,mula,13'b0}:63'b0;
wire[63:0]r14=mulb[14]?{18'b0,mula,14'b0}:63'b0;
wire[63:0]r15=mulb[15]?{17'b0,mula,15'b0}:63'b0;
wire[63:0]r16=mulb[16]?{16'b0,mula,16'b0}:63'b0;
wire[63:0]r17=mulb[17]?{15'b0,mula,17'b0}:63'b0;
wire[63:0]r18=mulb[18]?{14'b0,mula,18'b0}:63'b0;
wire[63:0]r19=mulb[19]?{13'b0,mula,19'b0}:63'b0;
wire[63:0]r20=mulb[20]?{12'b0,mula,20'b0}:63'b0;
wire[63:0]r21=mulb[21]?{11'b0,mula,21'b0}:63'b0;
wire[63:0]r22=mulb[22]?{10'b0,mula,22'b0}:63'b0;
wire[63:0]r23=mulb[23]?{9'b0,mula,23'b0}:63'b0;
wire[63:0]r24=mulb[24]?{8'b0,mula,24'b0}:63'b0;
wire[63:0]r25=mulb[25]?{7'b0,mula,25'b0}:63'b0;
wire[63:0]r26=mulb[26]?{6'b0,mula,26'b0}:63'b0;
wire[63:0]r27=mulb[27]?{5'b0,mula,27'b0}:63'b0;
wire[63:0]r28=mulb[28]?{4'b0,mula,28'b0}:63'b0;
wire[63:0]r29=mulb[29]?{3'b0,mula,29'b0}:63'b0;
wire[63:0]r30=mulb[30]?{2'b0,mula,30'b0}:63'b0;
wire[63:0]r31=mulb[31]?{1'b0,mula,31'b0}:63'b0;

wire[63:0]all=r0+r1+r2+r3+r4+r5+r6+r7+
         r8+r9+r10+r11+r12+r13+r14+r15+
         r16+r17+r18+r19+r20+r21+r22+r23+
         r24+r25+r26+r27+r28+r29+r30+r31;
assign z=mul_en?((a[31]^b[31])&~alu_u?-all:all):63'bz;

endmodule