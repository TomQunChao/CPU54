`timescale 1ns / 1ps

module RegFile(
    input clk,
    input w,
    input ena,
    input rst,
    input [4:0]rAddr,
    input [4:0]wAddr,
    input [31:0]iData,
    
    output [31:0]oData
    );
    reg [31:0]array_reg[31:0];
    always @(posedge clk)begin
        if(rst)begin
            array_reg[0]<=0;
            array_reg[1]<=0;
            array_reg[2]<=0;
            array_reg[3]<=0;
            array_reg[4]<=0;
            array_reg[5]<=0;
            array_reg[6]<=0;
            array_reg[7]<=0;
            array_reg[8]<=0;
            array_reg[9]<=0;
            array_reg[10]<=0;
            array_reg[11]<=0;
            array_reg[12]<=0;
            array_reg[13]<=0;
            array_reg[14]<=0;
            array_reg[15]<=0;
            array_reg[16]<=0;
            array_reg[17]<=0;
            array_reg[18]<=0;
            array_reg[19]<=0;
            array_reg[20]<=0;
            array_reg[21]<=0;
            array_reg[22]<=0;
            array_reg[23]<=0;
            array_reg[24]<=0;
            array_reg[25]<=0;
            array_reg[26]<=0;
            array_reg[27]<=0;
            array_reg[28]<=0;
            array_reg[29]<=0;
            array_reg[30]<=0;
            array_reg[31]<=0;
        end
        else begin
            if(w&&wAddr)array_reg[wAddr]<=iData;
            else array_reg[0]<=0;
        end
    end
    
    assign oData=ena?array_reg[rAddr]:32'bz;
endmodule
