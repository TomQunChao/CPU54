`timescale 1ns / 1ps

module hi_lo(
    input clk,
    input rst,
    input we,
    input sel,
    input ena,
    input [31:0]sData,
    input [31:0]iData,
    
    output [31:0]oData
    );
    reg [31:0]data;
    always @(posedge clk or posedge rst)begin
        if(rst)data<=0;
        else begin
            if(sel)data<=sData;//MULT/DIV
            else if(we)data<=iData;
        end
    end
    assign oData=ena?data:32'bz;
endmodule
