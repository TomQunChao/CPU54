`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk_in,
    input reset,
    
    output [31:0]inst,
    output [31:0]pc
    );
    wire clk;
    wire rw,re;
    wire [31:0]raddr;
    wire [31:0]ridata;
    wire [31:0]rodata;
//    Ram ram(clk,rw,raddr[31:2]-32'h00100000,ridata,clk,raddr[31:2]-32'h00100000,rodata);
//    RAM ram(clk,rst,ridata,rw,1'b1,raddr,rodata);
    Ram ram(raddr[31:2]-32'h00100000,ridata,raddr[31:2]-32'h00100000,clk,rw,rodata);
    cpu_bus sccpu(clk_in,reset,rodata,clk,rw,re,ridata,raddr,inst,pc);
endmodule
