`timescale 1ns / 1ps
module cpu_tb;
reg clk=0;
reg rst=1;
wire [31:0]pc_o;
wire [31:0]inst;
sccomp_dataflow sdf(clk,rst,inst,pc_o);

initial #10 rst=0;
always #1 clk=~clk;
endmodule
