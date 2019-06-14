`timescale 1ns / 1ps

module data_bus(
    input clk,
    input [31:0]data_in,
    input DR_in,
    input DR_out,
    input [31:0]isData,
    
    output [31:0]data_out,
    output [31:0]osData
    );
    reg [31:0]data;
    always @(posedge clk)begin
        if(DR_in)data<=data_in;
        else data<=isData;
    end
    assign osData=DR_in?data_in:data;
    assign data_out=DR_out?data:32'bz;
endmodule
