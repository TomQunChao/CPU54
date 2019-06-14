`timescale 1ns / 1ps

module Controler(
    input clk,
    input rst,
    input [53:0]icode,
    input zero,
    input neg,
    input div_busy,
    input [31:0]cp0_status,
    
    output alu_u,
    output [2:0]alu_sel,
    output [1:0]rd,
    output [1:0]rs,
    output cp0_sel,
    output [5:0]aluc,
    output [25:0]con_sig,//Control Signal
    output eret,
    output exception,
    output mfc0,
    output mtc0,
    output [5:0]cause
    );
    /*PC_in	PC_out	rs,rt	rd	IR_in	IR_out	Reg_out	ALU_out	AR_in	
    DR_in	DR_out	Y_in	Y_out	G_in	G_out	MEM_in	MEM_out	
    HI_in	HI_out	LO_in	LO_out	MUL_en	DIV_en	exceprion	eret	
    mfc0	mtc0
    */
    reg [5:0]status;
    //status wire
    wire [63:0]stw={
                (status[5]&status[4]&status[3]&status[2]&status[1]&status[0]),
                (status[5]&status[4]&status[3]&status[2]&status[1]&~status[0]),
                (status[5]&status[4]&status[3]&status[2]&~status[1]&status[0]),
                (status[5]&status[4]&status[3]&status[2]&~status[1]&~status[0]),
                
                (status[5]&status[4]&status[3]&~status[2]&status[1]&status[0]),
                (status[5]&status[4]&status[3]&~status[2]&status[1]&~status[0]),
                (status[5]&status[4]&status[3]&~status[2]&~status[1]&status[0]),
                (status[5]&status[4]&status[3]&~status[2]&~status[1]&~status[0]),
                
                (status[5]&status[4]&~status[3]&status[2]&status[1]&status[0]),
                (status[5]&status[4]&~status[3]&status[2]&status[1]&~status[0]),
                (status[5]&status[4]&~status[3]&status[2]&~status[1]&status[0]),
                (status[5]&status[4]&~status[3]&status[2]&~status[1]&~status[0]),
                
                (status[5]&status[4]&~status[3]&~status[2]&status[1]&status[0]),
                (status[5]&status[4]&~status[3]&~status[2]&status[1]&~status[0]),
                (status[5]&status[4]&~status[3]&~status[2]&~status[1]&status[0]),
                (status[5]&status[4]&~status[3]&~status[2]&~status[1]&~status[0]),
                
                (status[5]&~status[4]&status[3]&status[2]&status[1]&status[0]),
                (status[5]&~status[4]&status[3]&status[2]&status[1]&~status[0]),
                (status[5]&~status[4]&status[3]&status[2]&~status[1]&status[0]),
                (status[5]&~status[4]&status[3]&status[2]&~status[1]&~status[0]),
                
                (status[5]&~status[4]&status[3]&~status[2]&status[1]&status[0]),
                (status[5]&~status[4]&status[3]&~status[2]&status[1]&~status[0]),
                (status[5]&~status[4]&status[3]&~status[2]&~status[1]&status[0]),
                (status[5]&~status[4]&status[3]&~status[2]&~status[1]&~status[0]),
                
                (status[5]&~status[4]&~status[3]&status[2]&status[1]&status[0]),
                (status[5]&~status[4]&~status[3]&status[2]&status[1]&~status[0]),
                (status[5]&~status[4]&~status[3]&status[2]&~status[1]&status[0]),
                (status[5]&~status[4]&~status[3]&status[2]&~status[1]&~status[0]),
                
                (status[5]&~status[4]&~status[3]&~status[2]&status[1]&status[0]),
                (status[5]&~status[4]&~status[3]&~status[2]&status[1]&~status[0]),
                (status[5]&~status[4]&~status[3]&~status[2]&~status[1]&status[0]),
                (status[5]&~status[4]&~status[3]&~status[2]&~status[1]&~status[0]),
                
                (~status[5]&status[4]&status[3]&status[2]&status[1]&status[0]),
                (~status[5]&status[4]&status[3]&status[2]&status[1]&~status[0]),
                (~status[5]&status[4]&status[3]&status[2]&~status[1]&status[0]),
                (~status[5]&status[4]&status[3]&status[2]&~status[1]&~status[0]),
                
                (~status[5]&status[4]&status[3]&~status[2]&status[1]&status[0]),
                (~status[5]&status[4]&status[3]&~status[2]&status[1]&~status[0]),
                (~status[5]&status[4]&status[3]&~status[2]&~status[1]&status[0]),
                (~status[5]&status[4]&status[3]&~status[2]&~status[1]&~status[0]),
                
                (~status[5]&status[4]&~status[3]&status[2]&status[1]&status[0]),
                (~status[5]&status[4]&~status[3]&status[2]&status[1]&~status[0]),
                (~status[5]&status[4]&~status[3]&status[2]&~status[1]&status[0]),
                (~status[5]&status[4]&~status[3]&status[2]&~status[1]&~status[0]),
                
                (~status[5]&status[4]&~status[3]&~status[2]&status[1]&status[0]),
                (~status[5]&status[4]&~status[3]&~status[2]&status[1]&~status[0]),
                (~status[5]&status[4]&~status[3]&~status[2]&~status[1]&status[0]),
                (~status[5]&status[4]&~status[3]&~status[2]&~status[1]&~status[0]),
                
                (~status[5]&~status[4]&status[3]&status[2]&status[1]&status[0]),
                (~status[5]&~status[4]&status[3]&status[2]&status[1]&~status[0]),
                (~status[5]&~status[4]&status[3]&status[2]&~status[1]&status[0]),
                (~status[5]&~status[4]&status[3]&status[2]&~status[1]&~status[0]),
                
                (~status[5]&~status[4]&status[3]&~status[2]&status[1]&status[0]),
                (~status[5]&~status[4]&status[3]&~status[2]&status[1]&~status[0]),
                (~status[5]&~status[4]&status[3]&~status[2]&~status[1]&status[0]),
                (~status[5]&~status[4]&status[3]&~status[2]&~status[1]&~status[0]),
                
                (~status[5]&~status[4]&~status[3]&status[2]&status[1]&status[0]),
                (~status[5]&~status[4]&~status[3]&status[2]&status[1]&~status[0]),
                (~status[5]&~status[4]&~status[3]&status[2]&~status[1]&status[0]),
                (~status[5]&~status[4]&~status[3]&status[2]&~status[1]&~status[0]),
                
                (~status[5]&~status[4]&~status[3]&~status[2]&status[1]&status[0]),
                (~status[5]&~status[4]&~status[3]&~status[2]&status[1]&~status[0]),
                (~status[5]&~status[4]&~status[3]&~status[2]&~status[1]&status[0]),
                (~status[5]&~status[4]&~status[3]&~status[2]&~status[1]&~status[0])
                       };
    
    always @(posedge clk)begin
        if(rst)status<=0;
        else
        case(status)
            6'b000010:begin
                case(icode)
                    //ADD
                    54'b000000000000000000000000000000000000000001000000000000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000100000000000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000010000000000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000001000000000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000100000000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000010000000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000001000000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000000100000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000000010000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000000001000:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000000000100:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000000000010:status<=6'b000011;
                    54'b000000000000000000000000000000000000000000000000000001:status<=6'b000011;
                    //ADDI
                    54'b000000000000000000000000000000000100000000000000000000:status<=6'b000101;
                    54'b000000000000000000000000000000000010000000000000000000:status<=6'b000101;
                    54'b000000000000000000000000000000000001000000000000000000:status<=6'b000101;
                    54'b000000000000000000000000000000000000100000000000000000:status<=6'b000101;
                    54'b000000000000000000000000000000000000010000000000000000:status<=6'b000101;
                    54'b000000000000000000000000000000000000001000000000000000:status<=6'b000101;
                    54'b000000000000000000000000000000000000000100000000000000:status<=6'b000101;
                    //LUI
                    54'b000000000000000000000000000000001000000000000000000000:status<=6'b000111;
                    //BEQ
                    54'b000000000000000000000000001000000000000000000000000000:status<=6'b001000;
                    54'b000000000000000000000000000100000000000000000000000000:status<=6'b001000;
                    54'b000000000000000000000000000010000000000000000000000000:status<=6'b001000;
                    //J
                    54'b000000000000000000000000010000000000000000000000000000:status<=6'b001100;
                    //JAL
                    54'b000000000000000000000000100000000000000000000000000000:status<=6'b001110;
                    //JR
                    54'b000000000000000000000001000000000000000000000000000000:status<=6'b010000;
                    //JALR
                    54'b000000000000000000000010000000000000000000000000000000:status<=6'b010001;
                    //SRL
                    54'b000000000000000000000000000001000000000000000000000000:status<=6'b010011;
                    54'b000000000000000000000000000000100000000000000000000000:status<=6'b010011;
                    54'b000000000000000000000000000000010000000000000000000000:status<=6'b010011;
                    //CLZ
                    54'b000000000000000000000000000000000000000010000000000000:status<=6'b010101;
                    //LW
                    54'b000000000000000000000100000000000000000000000000000000:status<=6'b010110;
                    //SW
                    54'b000000000000000000001000000000000000000000000000000000:status<=6'b011001;
                    //LB
                    54'b000000000000000010000000000000000000000000000000000000:status<=6'b011100;
                    54'b000000000000000001000000000000000000000000000000000000:status<=6'b011100;
                    54'b000000000000000000100000000000000000000000000000000000:status<=6'b011100;
                    54'b000000000000000000010000000000000000000000000000000000:status<=6'b011100;
                    //SH
                    54'b000000000000001000000000000000000000000000000000000000:status<=6'b011111;
                    54'b000000000000000100000000000000000000000000000000000000:status<=6'b011111;
                    //BREAK
                    54'b001000000000000000000000000000000000000000000000000000:begin
                        if(cp0_status[0])status<=6'b100100;
                        else status<=6'b0;
                    end
                    //TEQ
                    54'b010000000000000000000000000000000000000000000000000000:begin
                        if(cp0_status[0])status<=6'b100101;
                        else status<=6'b0;
                    end
                    //SYSCALL
                    54'b000100000000000000000000000000000000000000000000000000:begin
                        if(cp0_status[0])status<=6'b101000;
                        else status<=6'b0;
                    end
                    //ERET
                    54'b100000000000000000000000000000000000000000000000000000:status<=6'b101001;
                    //MFC0
                    54'b000001000000000000000000000000000000000000000000000000:status<=6'b101010;
                    //MTC0
                    54'b000010000000000000000000000000000000000000000000000000:status<=6'b101011;
                    //MFLO
                    54'b000000000000100000000000000000000000000000000000000000:status<=6'b101100;
                    //MFHI
                    54'b000000000000010000000000000000000000000000000000000000:status<=6'b101101;
                    //MTLO
                    54'b000000000010000000000000000000000000000000000000000000:status<=6'b101110;
                    //MTHI
                    54'b000000000001000000000000000000000000000000000000000000:status<=6'b101111;
                    //MUL
                    54'b000000001000000000000000000000000000000000000000000000:status<=6'b110000;
                    //MULTU
                    54'b000000010000000000000000000000000000000000000000000000:status<=6'b110011;
                    //DIV
                    54'b000000000100000000000000000000000000000000000000000000:status<=6'b110101;
                    //DIVU
                    54'b000000100000000000000000000000000000000000000000000000:status<=6'b110101;
                endcase
           end
           //end of each command
           6'b000100:status<=6'b0;
           6'b000110:status<=6'b0;
           6'b000111:status<=6'b0;
           6'b001011:status<=6'b0;
           6'b001101:status<=6'b0;
           6'b001111:status<=6'b0;
           6'b010000:status<=6'b0;
           6'b010010:status<=6'b0;
           6'b010100:status<=6'b0;
           6'b010101:status<=6'b0;
           6'b011000:status<=6'b0;
           6'b011011:status<=6'b0;
           6'b011110:status<=6'b0;
           6'b100010:status<=6'b0;
           6'b100100:status<=6'b0;
           6'b100111:status<=6'b0;
           6'b101000:status<=6'b0;
           6'b101001:status<=6'b0;
           6'b101010:status<=6'b0;
           6'b101011:status<=6'b0;
           6'b101100:status<=6'b0;
           6'b101101:status<=6'b0;
           6'b101110:status<=6'b0;
           6'b101111:status<=6'b0;
           6'b110010:status<=6'b0;
           6'b110100:status<=6'b0;
           //Special end
           6'b001001:begin
                if(icode[25]&zero|icode[26]&~zero|icode[27]&~neg)status<=status+1;
                else status<=6'b0;
           end
           6'b110111:begin
                if(div_busy)status<=status;
                else status<=6'b0;
           end
           6'b100110:begin
                if(zero)status<=status+1;
                else status<=6'b0;
           end
           default:status<=status+1;
        endcase
    end
    //(~status[5]&~status[4]&~status[3]&~status[2]&~status[1]&~status[0])
    assign con_sig[0]=stw[2]|stw[11]|stw[13]|stw[15]|stw[16]|stw[18]|stw[36]|stw[39]|stw[40]|stw[41];
    assign con_sig[1]=stw[0]|stw[2]|stw[11]|stw[12]|stw[14]|stw[17];
    assign con_sig[2]=stw[1];
    assign con_sig[3]=stw[5]|stw[7]|stw[10]|stw[13]|stw[15]|stw[20]|stw[22]|stw[25]|stw[28]|stw[31];
    assign con_sig[4]=stw[3]|stw[4]|stw[6]|stw[8]|stw[9]|stw[16]|stw[18]|stw[19]|stw[21]|stw[23]|stw[26]|stw[27]|stw[29]|stw[32]|stw[34]|stw[37]|
                stw[38]|stw[43]|stw[46]|stw[47]|stw[48]|stw[49]|stw[51]|stw[52]|stw[53]|stw[54]|stw[55];
    assign con_sig[5]=stw[2]|stw[4]|stw[6]|stw[7]|stw[11]|stw[13]|stw[15]|stw[20]|stw[21]|
                stw[23]|stw[26]|stw[29]|stw[30]|stw[32]|stw[34]|stw[36]|stw[39]|stw[40];
    assign con_sig[6]=stw[0]|stw[23]|stw[26]|stw[29]|stw[32];
    assign con_sig[7]=stw[27]|stw[34];
    assign con_sig[8]=stw[1]|stw[24]|stw[30]|stw[33];
    assign con_sig[9]=stw[0]|stw[1]|stw[3]|stw[5]|stw[8]|stw[10]|stw[14]|stw[16]|stw[17]|stw[18]|stw[19]|
                stw[22]|stw[24]|stw[25]|stw[27]|stw[28]|stw[30]|stw[31]|stw[33]|stw[37]|
                stw[41]|stw[42]|stw[43]|stw[44]|stw[46]|stw[47]|stw[48]|stw[51]|stw[53];
    assign con_sig[10]=stw[0]|stw[1]|stw[14]|stw[16]|stw[17]|stw[18]|stw[24]|stw[27]|
                stw[41]|stw[42]|stw[43]|stw[44]|stw[46]|stw[47];
    assign con_sig[11]=0;
    assign con_sig[12]=0;
    assign con_sig[13]=stw[27]|stw[34];
    assign con_sig[14]=stw[0]|stw[23]|stw[29]|stw[32];
    assign con_sig[15]=stw[47]|stw[49]|stw[52]|stw[54];
    assign con_sig[16]=stw[45];
    assign con_sig[17]=stw[46]|stw[49]|stw[52]|stw[54];
    assign con_sig[18]=stw[44]|stw[50];
    assign con_sig[19]=stw[49]|stw[52];
    assign con_sig[20]=stw[54];
    assign con_sig[21]=stw[36]|stw[39]|stw[40];
    assign con_sig[22]=stw[41];
    assign con_sig[23]=stw[42];
    assign con_sig[24]=stw[43];
    assign con_sig[25]=(stw[55])&div_busy|stw[49]|stw[52];
    
    //00 r1 01 r2 10 r3 11 0
    assign rs[0]=stw[3]|stw[8]|stw[19]|stw[27]|stw[34]|stw[37]|stw[43]|stw[48]|stw[51]|stw[53];
    assign rs[1]=(stw[8]&icode[27]);
    //00 00000 01 r2 10 r3 11 11111 
    assign rd[0]=(stw[6]|stw[7]|stw[14]|stw[24]|stw[30]|stw[42]);
    assign rd[1]=(stw[4]|stw[14]|stw[17]|stw[20]|stw[21]|stw[31]|stw[44]|stw[45]|stw[46]|stw[47]|stw[50]);
    //
    assign cp0_sel=stw[42]|stw[43];
    
    
    assign aluc[0]=stw[36]|stw[39]|stw[40]|(icode[3]|icode[2]|icode[5]|icode[17]|icode[7]|icode[9]|icode[20]|icode[11]|
        icode[23]|icode[24]|icode[28]|icode[29]|icode[39]|icode[36]|icode[37])
        &(stw[4]|stw[6]|stw[20]|stw[13]|stw[15]|stw[34]|stw[30]);
    assign aluc[1]=stw[36]|stw[39]|stw[40]|
        (icode[0]|icode[2]|icode[6]|icode[7]|icode[8]|icode[9]|icode[10]|icode[14]|icode[18]|icode[19]|icode[20]|icode[22]|
        icode[23]|icode[25]|icode[26]|icode[27]|icode[32]|icode[33]|icode[34]|icode[35]|icode[36]|icode[37]|icode[38]|icode[39]|icode[52])
        &(stw[4]|stw[6]|stw[9]|stw[11]|stw[20]|stw[23]|stw[26]|stw[29]|stw[32]|stw[34]|stw[38]);
    assign aluc[2]=(icode[4]|icode[5]|icode[6]|icode[7]|icode[10]|icode[11]|icode[12]|icode[16]|icode[17]|icode[18]|icode[13]|icode[28]|icode[29]|icode[38]|icode[39])
        &(stw[4]|stw[6]|stw[13]|stw[15]|stw[21]|stw[34]);
    assign aluc[3]=stw[36]|stw[39]|stw[40]|(icode[8]|icode[9]|icode[10]|icode[11]|icode[12]|icode[19]|icode[20]|icode[21]|icode[25]|icode[26]|icode[27]|
        icode[32]|icode[33]|icode[34]|icode[35]|icode[36]|icode[37]|icode[38]|icode[39]|icode[52])
        &(stw[4]|stw[6]|stw[7]|stw[9]|stw[23]|stw[26]|stw[29]|stw[30]|stw[32]|stw[38]);
    assign aluc[4]=stw[36]|stw[39]|stw[40]|((icode[13]|icode[22]|icode[23]|icode[24]|icode[28]|icode[29]|
        icode[32]|icode[33]|icode[34]|icode[35]|icode[36]|icode[37]|icode[38]|icode[39])
        &(stw[13]|stw[15]|stw[20]|stw[21]|stw[23]|stw[26]|stw[29]|stw[30]|stw[32]|stw[34]))|stw[2];

    assign alu_sel[2]=0;
    assign alu_sel[1]=stw[11]|stw[23]|stw[26]|stw[29]|stw[32]|(icode[14]|icode[15]|icode[19]|icode[20])&stw[6];
    assign alu_sel[0]=stw[11]|(icode[16]|icode[17]|icode[18])&stw[6];
    
    assign alu_u=icode[1]|icode[3]|icode[9]|icode[15]|icode[20]|icode[35]|icode[36]|icode[46]|icode[47];
    
    assign eret=stw[41];
    assign mfc0=stw[42];
    assign mtc0=stw[43];
    assign exception=stw[36]|stw[39]|stw[40];
    assign cause=stw[40]?5'b01000:5'bz;
    assign cause=stw[36]?5'b01001:5'bz;
    assign cause=stw[37]|stw[38]|stw[39]?5'b01101:5'bz;
    
    
    
endmodule
