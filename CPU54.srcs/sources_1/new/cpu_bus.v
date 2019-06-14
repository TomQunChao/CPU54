`timescale 1ns / 1ps

module cpu_bus(
    input clk_in,
    input rst,
    input [31:0]oram,
    
    output clk_out,
    output dataW,
    output dataE,
    output [31:0]iram,
    output [31:0]ramAddr,
    output [31:0]inst,
    output [31:0]pc_out
    );
    wire clk;
    wire [31:0]bus_in;
    wire [31:0]bus_out;
    wire [25:0]con_sig;
    wire [31:0]y_sData;
    wire [63:0]mul_div;
    wire [5:0]aluc;
    wire [1:0]alup;
    wire l_u;
    wire zero;
    wire neg;
    wire carry;
    wire negative;
    wire overflow;
    wire [2:0]alu_sel;
    wire [31:0]alu_exts;
    wire busy;
    wire [5:0]r1;
    wire [5:0]r2;
    wire [5:0]r3;
    wire [1:0]rs_sel;
    wire [1:0]rd_sel;
    wire cp0_sel;
    wire [4:0]rs;
    wire [4:0]rd;
    wire [4:0]cp0_r;
    wire [53:0]icode;
    wire mfc0,mtc0,exception,eret;
    wire [4:0]cause;
    wire [31:0]cp0_pc;
    wire [31:0]cp0_status;
    assign pc_out=cp0_pc;
    wire [31:0]debug=y_sData;
    
    clk_divider cd(clk_in,rst,clk);
    pcreg pc(clk,bus_in,rst,con_sig[0],con_sig[1],cp0_pc,bus_out);
    gernal_reg y(clk,con_sig[9],con_sig[10],bus_out,bus_in,y_sData);
    gernal_reg ar(clk,con_sig[6],1'b0,bus_in,bus_out,ramAddr);
//    gernal_reg dr(clk,con_sig[7],con_sig[8],bus_in,debug,iram);
    data_bus dr(clk,bus_in,con_sig[7],con_sig[8],oram,bus_out,iram);    
    hi_lo hi(clk,rst,con_sig[15],con_sig[25],con_sig[16],mul_div[63:32],bus_out,bus_in);
    hi_lo lo(clk,rst,con_sig[17],con_sig[25],con_sig[18],mul_div[31:0],bus_out,bus_in);
    //TODO ALU_out
    ALU_ext alu(con_sig[5],bus_out,alu_exts,aluc,alup,l_u,bus_in,zero,carry,negative,overflow);
    ALU_exters aluext(y_sData,alu_sel,alu_exts);
    DIV div(bus_out,y_sData,con_sig[20],clk,rst,l_u,mul_div[31:0],mul_div[63:32],busy);
    MUL mul(l_u,con_sig[19],bus_out,y_sData,mul_div);
    address adr(r1,r2,r3,rs_sel,rd_sel,cp0_sel,rs,rd,cp0_r);
    CP0 cp0(
        .clk(clk),
        .rst(rst),
        .mfc0(mfc0),
        .mtc0(mtc0),
        .rd(cp0_r),
        .pc(cp0_pc),
        .wdata(bus_in),
        .exception(exception),
        .eret(eret),
        .cause(cause),
        .status(cp0_status),
        .rdata(bus_out)
        );
    IR_Decoder id(clk,rst,con_sig[2],con_sig[3],bus_in,r1,r2,r3,alup,bus_out,icode,inst);
    RegFile cpu_ref(clk,1'b1,con_sig[4],rst,rs,rd,bus_in,bus_out);
    gernal_reg g(clk,con_sig[11],con_sig[12],bus_in,bus_out);
    Controler c(
        clk,
        rst,
        icode,
        zero,
        negative,
        busy,
        cp0_status,
        l_u,
        alu_sel,
        rd_sel,
        rs_sel,
        cp0_sel,
        aluc,
        con_sig,
        eret,
        exception,
        mfc0,
        mtc0,
        cause
        );
        
        assign clk_out=clk;
        assign dataW=con_sig[13];
        assign dataE=con_sig[14];
endmodule
