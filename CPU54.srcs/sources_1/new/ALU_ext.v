`timescale 1ns / 1ps

module ALU_ext(
    input ALU_out,
    input [31:0]a,
    input [31:0]b,
    input [4:0]aluc,
    input [1:0]alup,
    input l_u,
    
    output [31:0]r_out,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow
    );
    reg [31:0]r;
    parameter FUNC_V_ADD    =5'b00010;
    parameter FUNC_V_ADDU   =5'b00000;
    parameter FUNC_V_SUBU   =5'b00001;
    parameter FUNC_V_SUB    =5'b00011;
    parameter FUNC_V_AND    =5'b00100;
    parameter FUNC_V_OR     =5'b00101;
    parameter FUNC_V_XOR    =5'b00110;
    parameter FUNC_V_NOR    =5'b00111;
    parameter FUNC_V_LUI    =5'b0100x;//load low 16 bits of B?
    parameter FUNC_V_SLT    =5'b01010;//a<b?
    parameter FUNC_V_SLTU   =5'b01011;//a<b?
    parameter FUNC_V_SRA    =5'b01100;
    parameter FUNC_V_SLL    =5'b0111x;
    parameter FUNC_V_SRL    =5'b01101;
    
    parameter FUNC_I_PC     =5'b10000,
              FUNC_I_SRA    =5'b10001,
              FUNC_I_SLL    =5'b10010,
              FUNC_I_SRL    =5'b10011,
              FUNC_V_CLZ    =5'b10100,
              FUNC_I_EXT28  =5'b10101,
              FUNC_SI_BYTE  =5'b10110,
              FUNC_SI_HALF  =5'b10111,
              FUNC_LI_BYTE  =5'b11000,
              FUNC_LI_HALF  =5'b11001,
              FUNC_DRAM=5'b11010,
              FUNC_PC_EXCE=5'b11011;
    
    always @(*)
    begin
        casex(aluc)
            FUNC_V_ADDU:
            begin
                r=a+b;
                negative<=r[31];
                if(a+b>32'hffff)carry<=1;
                else carry<=0;
                zero<=r==0;
             end
             FUNC_V_ADD:
             begin
                r=a+b;
                negative<=r[31];
                if(r[31]==1&&a[31]==0&&b[31]==0)overflow<=1;
                else overflow<=0;
                zero<=r[31];
             end
             FUNC_V_SUBU:
             begin
                r<=a-b;
                negative<=a<b;
                carry<=b>a;
                zero<=a==b;
             end
             FUNC_V_SUB:
             begin
                r<=a-b;
                negative<=a[31]^b[31];
                if(r[31]==0&&a[31]==1&&b[31]==0||r[31]==1&&a[31]==0&&b[31]==1)overflow<=1;
                else overflow<=0;
                negative<=a[31]&&~b[31]||a[31]==b[31]&&a<b;
                zero<=a==b;
             end
             FUNC_V_AND:
             begin
                r<=a&b;
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_V_OR:
             begin
                r<=a|b;
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_V_XOR:
             begin
                r<=a^b;
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_V_NOR://~(a|b)
             begin
                r<=~(a|b);
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_V_LUI://ȡb��16λ
             begin
                r<={b[15:0],16'b0};
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_V_SLT:
             begin
                if(a[31]==1&&b[31]==0||a[31]==b[31]&&a<b)r<=31'h0001;
                else r<=0;
                negative<=a[31]==1&&b[31]==0||a[31]==b[31]&&a<b;
                zero<=a==b;
             end
             FUNC_V_SLTU:
             begin
                r<=a<b;
                carry<=a<b;
                negative<=a<b;
                zero<=a==b;
             end
             FUNC_V_SRA:
             begin
                r<=$signed(b)>>>a;
                if(a<=32'h0020)carry<=b[a];
                else carry<=b[31];
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_V_SLL:
             begin
                r<=b<<a;
                if(a<=32'h0020)carry<=b[32-a];
                else carry<=0;
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_V_SRL:
             begin
                r<=b>>a;
                if(a<=32'h0020)carry<=b[a];
                else carry<=0;
                negative<=r[31];
                zero<=r==0;
             end
             FUNC_I_SRL:
             begin
                r<=b>>(a[10:6]);
             end
             FUNC_I_SRA:
             begin
               r<=$signed(b)>>>(a[10:6]);
             end
             FUNC_I_SLL:
             begin
                r<=b<<a[10:6];
             end
             FUNC_I_PC:
             begin
                r<=a+4;
             end
             FUNC_V_CLZ:
             begin
                casex(a)
                    32'b1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h0;
                    32'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h1;
                    32'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h2;
                    32'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h3;
                    32'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h4;
                    32'b000001xxxxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h5;
                    32'b0000001xxxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h6;
                    32'b00000001xxxxxxxxxxxxxxxxxxxxxxxx:r<=32'h7;
                    32'b000000001xxxxxxxxxxxxxxxxxxxxxxx:r<=32'h8;
                    32'b0000000001xxxxxxxxxxxxxxxxxxxxxx:r<=32'h9;
                    32'b00000000001xxxxxxxxxxxxxxxxxxxxx:r<=32'ha;
                    32'b000000000001xxxxxxxxxxxxxxxxxxxx:r<=32'hb;
                    32'b0000000000001xxxxxxxxxxxxxxxxxxx:r<=32'hc;
                    32'b00000000000001xxxxxxxxxxxxxxxxxx:r<=32'hd;
                    32'b000000000000001xxxxxxxxxxxxxxxxx:r<=32'he;
                    32'b0000000000000001xxxxxxxxxxxxxxxx:r<=32'hf;
                    32'b00000000000000001xxxxxxxxxxxxxxx:r<=32'h10;
                    32'b000000000000000001xxxxxxxxxxxxxx:r<=32'h11;
                    32'b0000000000000000001xxxxxxxxxxxxx:r<=32'h12;
                    32'b00000000000000000001xxxxxxxxxxxx:r<=32'h13;
                    32'b000000000000000000001xxxxxxxxxxx:r<=32'h14;
                    32'b0000000000000000000001xxxxxxxxxx:r<=32'h15;
                    32'b00000000000000000000001xxxxxxxxx:r<=32'h16;
                    32'b000000000000000000000001xxxxxxxx:r<=32'h17;
                    32'b0000000000000000000000001xxxxxxx:r<=32'h18;
                    32'b00000000000000000000000001xxxxxx:r<=32'h19;
                    32'b000000000000000000000000001xxxxx:r<=32'h1a;
                    32'b0000000000000000000000000001xxxx:r<=32'h1b;
                    32'b00000000000000000000000000001xxx:r<=32'h1c;
                    32'b000000000000000000000000000001xx:r<=32'h1d;
                    32'b0000000000000000000000000000001x:r<=32'h1e;
                    32'b00000000000000000000000000000001:r<=32'h1f;
                    32'b00000000000000000000000000000000:r<=32'h20;
                    default:;
                endcase
             end
             FUNC_I_EXT28:
             begin
                r<={b[31:28],a[25:0],2'b0};
             end
             FUNC_SI_BYTE:
             begin
                case(alup)
                    0:r<={b[31:8],a[7:0]};
                    1:r<={b[31:16],a[7:0],b[7:0]};
                    2:r<={b[31:24],a[7:0],b[15:0]};
                    3:r<={a[7:0],b[23:0]};
                    default:;
                endcase
             end
             FUNC_SI_HALF:
             begin
                r<=alup?{a[15:0],b[15:0]}:{b[31:16],a[15:0]};
             end
             FUNC_LI_BYTE:
             begin
                 case(alup)
                    0:r<={~l_u&a[7]?24'hffffff:24'b0,a[7:0]};
                    1:r<={~l_u&a[15]?24'hffffff:24'b0,a[15:8]};
                    2:r<={~l_u&a[23]?24'hffffff:24'b0,a[23:16]};
                    3:r<={~l_u&a[31]?24'hffffff:24'b0,a[31:24]};
                    default:;
                 endcase
             end
             FUNC_LI_HALF:
             begin
                r<=alup?{~l_u&a[31]?16'hffff:16'b0,a[31:16]}:{~l_u&a[15]?16'hffff:16'h0,a[15:0]};
             end
             FUNC_DRAM:
             begin
                r<=a+b-32'h0fc0c000;
             end
             FUNC_PC_EXCE:
             begin
                r<=32'h00400004;
             end
        endcase
    end
    assign r_out=ALU_out?r:32'bz;
endmodule
