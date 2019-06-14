`timescale 1ns / 1ps

module pcreg(
    input clk,
    input [31:0]pc_in,
    input rst,
    input PC_in,
    input PC_out,
    
    output [31:0]cp0_pc,
    output [31:0]pc_out
    );
    reg [31:0]pc_r;
    parameter START_ADDR=32'h00400000;
    always @(posedge clk)begin
        if(rst)pc_r<=START_ADDR;
        else if(PC_in)pc_r<=pc_in;
    end
    assign pc_out=PC_out?pc_r:32'bz;
    assign cp0_pc=pc_r;
endmodule
