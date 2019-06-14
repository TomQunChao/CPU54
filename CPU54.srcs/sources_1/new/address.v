`timescale 1ns / 1ps

module address(
    input [4:0]r1,
    input [4:0]r2,
    input [4:0]r3,
    input [1:0]rs_sel,
    input [1:0]rd_sel,
    input cp0_sel,
    
    output [4:0]rs,
    output [4:0]rd,
    output [4:0]cp0_r
    );
    
    parameter EPC=14;
    
    assign rs=~rs_sel[0]&~rs_sel[1]?r1:32'bz;
    assign rs=rs_sel[0]&~rs_sel[1]?r2:32'bz;
    assign rs=~rs_sel[0]&rs_sel[1]?r3:32'bz;
    assign rs=rs_sel[0]&rs_sel[1]?5'b0:5'bz;
    
    assign rd=~rd_sel[1]&~rd_sel[0]?5'b00000:32'bz;
    assign rd=~rd_sel[1]&rd_sel[0]?r2:32'bz;
    assign rd=rd_sel[1]&~rd_sel[0]?r3:32'bz;
    assign rd=rd_sel[1]&rd_sel[0]?5'b11111:32'bz;
    
    assign cp0_r=cp0_sel?r3:EPC;
endmodule
