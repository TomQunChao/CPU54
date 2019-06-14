`timescale 1ns / 1ps

module gernal_reg(
    input clk,
    input w,
    input ena,
    input [31:0]iData,
    output [31:0]oData,
    output [31:0]sData
    );
    //At rising edge of clk
    reg [31:0]data;
    always @(posedge clk)begin
        if(w)data<=iData;
    end
    assign oData=ena?(w?iData:data):32'bz;
    assign sData=w?iData:data;
endmodule
