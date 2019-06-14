`timescale 1ns / 1ps

module CP0(
    input clk,
    input rst,
    input mfc0,
    input mtc0,
    input [31:0]pc,
    input [4:0]rd,
    input [31:0]wdata,
    input exception,
    input eret,
    input [4:0]cause,
    input intr,
    
    output [31:0]rdata,
    output [31:0]status,
    output reg timerInt,
    output [31:0]execAddr
    );
    
    parameter STATUS=12,
                CAUSE=13,
                EPC=14;
    parameter  STATUS_SYSCALL=8,
                STATUS_BREAK=9,
                STATUS_TEQ=10;
    reg [31:0]rf[31:0];
    parameter    SYSCALL     =   5'b1000,
                BREAK       =   5'b1001,
                TEQ            =   5'b1101;
    assign rdata=mfc0|eret?rf[rd]:32'bz;
    assign status=rf[STATUS];
    assign execAddr=rf[EPC];
    wire excep=exception/*&rf[STATUS][0]&
        (cause==SYSCALL&rf[STATUS][STATUS_SYSCALL]
        |cause==BREAK&rf[STATUS][STATUS_BREAK]
        |cause==TEQ&rf[STATUS][STATUS_TEQ])*/;
    //regfiles epc
    always @ (negedge clk or posedge rst)begin
        if(rst)begin
            rf[0]<=32'b0;
            rf[1]<=32'b0;
            rf[2]<=32'b0;
            rf[3]<=32'b0;
            rf[4]<=32'b0;
            rf[5]<=32'b0;
            rf[6]<=32'b0;
            rf[7]<=32'b0;
            rf[8]<=32'b0;
            rf[9]<=32'b0;
            rf[10]<=32'b0;
            rf[11]<=32'b0;
            rf[12]<=32'b0000000011100000001;
            rf[13]<=32'b0;
            rf[14]<=32'b0;
            rf[15]<=32'b0;
            rf[16]<=32'b0;
            rf[17]<=32'b0;
            rf[18]<=32'b0;
            rf[19]<=32'b0;
            rf[20]<=32'b0;
            rf[21]<=32'b0;
            rf[22]<=32'b0;
            rf[23]<=32'b0;
            rf[24]<=32'b0;
            rf[25]<=32'b0;
            rf[26]<=32'b0;
            rf[27]<=32'b0;
            rf[28]<=32'b0;
            rf[29]<=32'b0;
            rf[30]<=32'b0;
            rf[31]<=32'b0;
        end
        else begin
            if(mtc0)rf[rd]<=wdata;
            if(excep)begin
                rf[EPC]<=pc-32'h4;
                rf[STATUS]<=rf[STATUS]<<5;
                rf[CAUSE][6:2]<=cause;
            end
            else if(eret)begin
                rf[STATUS]<=rf[STATUS]>>5;
            end
        end
    end
endmodule
