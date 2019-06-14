`timescale 1ns / 1ps

module clk_divider(
    input clk_in,
    input rst,
    
    output clk_out
    );
    reg [7:0]clk_d;
    always @(posedge clk_in)begin
        if(rst)clk_d<=0;
        else clk_d<=clk_d+1;
    end
    assign clk_out=clk_in;
endmodule
