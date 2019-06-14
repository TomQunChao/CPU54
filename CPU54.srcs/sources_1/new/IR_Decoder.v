`timescale 1ns / 1ps

module IR_Decoder(
    input clk,
    input rst,
    input iR_in,
    input IR_out,
    input [31:0]inst,
    
    output [5:0]rc1,
    output [5:0]rc2,
    output [5:0]rc3,
    output [1:0]alup,
    output [31:0]inst_out,
    output [53:0]icode,
    output [31:0]instr
    );
    
    reg [31:0]cmd;
    always @(posedge clk)begin
        if(rst)/*cmd<=0*/;
        else if(iR_in)cmd<=inst;
    end
    assign rc1=cmd[25:21];
    assign rc2=cmd[20:16];
    assign rc3=cmd[15:11];
    assign alup=cmd[1:0];
    assign inst_out=IR_out?(iR_in?inst:cmd):32'bz;
    assign instr=cmd;
    //add
    assign   icode[0]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&~cmd[1]&~cmd[0];
    //addu
    assign   icode[1]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&~cmd[1]&cmd[0];
    //sub
    assign   icode[2]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&cmd[1]&~cmd[0];
    //subu
    assign   icode[3]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&cmd[1]&cmd[0];
    //and
    assign   icode[4]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&cmd[2]&~cmd[1]&~cmd[0];
    //or
    assign   icode[5]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&cmd[2]&~cmd[1]&cmd[0];
    //xor
    assign   icode[6]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&cmd[2]&cmd[1]&~cmd[0];
    //nor
    assign   icode[7]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&~cmd[3]&cmd[2]&cmd[1]&cmd[0];
    //slt
    assign   icode[8]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&cmd[3]&~cmd[2]&cmd[1]&~cmd[0];
    //sltu
    assign   icode[9]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&cmd[5]&~cmd[4]&cmd[3]&~cmd[2]&cmd[1]&cmd[0];
    //sllv
    assign   icode[10]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&~cmd[5]&~cmd[4]&~cmd[3]&cmd[2]&~cmd[1]&~cmd[0];
    //srlv
    assign   icode[11]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&~cmd[5]&~cmd[4]&~cmd[3]&cmd[2]&cmd[1]&~cmd[0];
    //srav
    assign   icode[12]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&~cmd[5]&~cmd[4]&~cmd[3]&cmd[2]&cmd[1]&cmd[0];
    //clz
    assign icode[13]=~cmd[31]&cmd[30]&cmd[29]&cmd[28]&~cmd[27]&~cmd[26]
                    &cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&~cmd[1]&~cmd[0];

    //addi
    assign   icode[14]=~cmd[31]&~cmd[30]&cmd[29]&~cmd[28]&~cmd[27]&~cmd[26];
    //addiu
    assign   icode[15]=~cmd[31]&~cmd[30]&cmd[29]&~cmd[28]&~cmd[27]&cmd[26];
    //andi
    assign   icode[16]=~cmd[31]&~cmd[30]&cmd[29]&cmd[28]&~cmd[27]&~cmd[26];
    //ori
    assign   icode[17]=~cmd[31]&~cmd[30]&cmd[29]&cmd[28]&~cmd[27]&cmd[26];
    //xori
    assign   icode[18]=~cmd[31]&~cmd[30]&cmd[29]&cmd[28]&cmd[27]&~cmd[26];
    //slti
    assign   icode[19]=~cmd[31]&~cmd[30]&cmd[29]&~cmd[28]&cmd[27]&~cmd[26];
    //sltiu
    assign   icode[20]=~cmd[31]&~cmd[30]&cmd[29]&~cmd[28]&cmd[27]&cmd[26];
    //lui
    assign   icode[21]=~cmd[31]&~cmd[30]&cmd[29]&cmd[28]&cmd[27]&cmd[26];
    //sll
    assign   icode[22]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&~cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&~cmd[1]&~cmd[0];
    //srl
    assign   icode[23]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&~cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&cmd[1]&~cmd[0];
    //sra
    assign   icode[24]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&~cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&cmd[1]&cmd[0];

    //beq
    assign   icode[25]=~cmd[31]&~cmd[30]&~cmd[29]&cmd[28]&~cmd[27]&~cmd[26];
    //bne
    assign   icode[26]=~cmd[31]&~cmd[30]&~cmd[29]&cmd[28]&~cmd[27]&cmd[26];
    //bgez
    assign  icode[27]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&cmd[26];

    //j
    assign   icode[28]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&cmd[27]&~cmd[26];
    //jal
    assign   icode[29]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&cmd[27]&cmd[26];
    //jr
    assign   icode[30]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]&~cmd[5]&~cmd[4]&cmd[3]&~cmd[2]&~cmd[1]&~cmd[0];
    //jalr
    assign  icode[31]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&~cmd[4]&cmd[3]&~cmd[2]&~cmd[1]&cmd[0];

    //lw
    assign   icode[32]=cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&cmd[27]&cmd[26];
    //sw
    assign   icode[33]=cmd[31]&~cmd[30]&cmd[29]&~cmd[28]&cmd[27]&cmd[26];
    //lb
    assign  icode[34]=cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26];
    //lbu
    assign  icode[35]=cmd[31]&~cmd[30]&~cmd[29]&cmd[28]&~cmd[27]&~cmd[26];
    //lhu
    assign  icode[36]=cmd[31]&~cmd[30]&~cmd[29]&cmd[28]&~cmd[27]&cmd[26];
    //lh
    assign  icode[37]=cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&cmd[26];
    //sb
    assign  icode[38]=cmd[31]&~cmd[30]&cmd[29]&~cmd[28]&~cmd[27]&~cmd[26];
    //sh
    assign  icode[39]=cmd[31]&~cmd[30]&cmd[29]&~cmd[28]&~cmd[27]&cmd[26];
    
    //mfhi
    assign  icode[40]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&cmd[4]&~cmd[3]&~cmd[2]&~cmd[1]&~cmd[0];
    //mflo 
    assign  icode[41]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&cmd[4]&~cmd[3]&~cmd[2]&cmd[1]&~cmd[0];
    //mthi
    assign  icode[42]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&cmd[4]&~cmd[3]&~cmd[2]&~cmd[1]&cmd[0];
    //mtlo
    assign  icode[43]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&cmd[4]&~cmd[3]&~cmd[2]&cmd[1]&cmd[0];
    //div
    assign  icode[44]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&cmd[4]&cmd[3]&~cmd[2]&cmd[1]&~cmd[0];
    //mul
    assign  icode[45]=~cmd[31]&cmd[30]&cmd[29]&cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&~cmd[4]&~cmd[3]&~cmd[2]&cmd[1]&~cmd[0];
    //multu
    assign  icode[46]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&cmd[4]&cmd[3]&~cmd[2]&~cmd[1]&cmd[0];
    //divu
    assign  icode[47]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&cmd[4]&cmd[3]&~cmd[2]&cmd[1]&cmd[0];
    
    //mfc0
    assign  icode[48]=~cmd[31]&cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[25]&~cmd[24]&~cmd[23]&~cmd[22]&~cmd[21];
    //mtc0
    assign  icode[49]=~cmd[31]&cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[25]&~cmd[24]&cmd[23]&~cmd[22]&~cmd[21];
     //syscall
     assign icode[50]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&~cmd[4]&cmd[3]&cmd[2]&~cmd[1]&~cmd[0];
     //break
     assign icode[51]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &~cmd[5]&~cmd[4]&cmd[3]&cmd[2]&~cmd[1]&cmd[0];
     //teq
     assign icode[52]=~cmd[31]&~cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &cmd[5]&cmd[4]&~cmd[3]&cmd[2]&~cmd[1]&~cmd[0];
     //eret
     assign icode[53]=~cmd[31]&cmd[30]&~cmd[29]&~cmd[28]&~cmd[27]&~cmd[26]
                    &cmd[25]&~cmd[24]&~cmd[23]&~cmd[22]&~cmd[21]
                    &~cmd[5]&cmd[4]&cmd[3]&~cmd[2]&~cmd[1]&~cmd[0];

endmodule
