`timescale 1ns/1ps
module mult_tb;
reg[31:0] A,B;
wire [31:0] HI;
wire [31:0] LO;
 MULT32 signed_mult(HI, LO, A, B);
initial
begin
#5 $write("testing signed multiplier\n");
#5 A='b0; B='b0; //can write golden here CHANGE OPERATIONS
#5 $write("A is%d B is%d HI=%b LO=%b\n",A,B,HI,LO);
#5 A='b1; B='b0;
#5 $write("A is%d B is%d HI=%b LO=%b\n",A,B,HI,LO);
#5 A=5; B=3;
#5 $write("A is%d B is%d HI=%b LO=%b\n",A,B,HI,LO);
#5 A='b1; B='b1;
#5 $write("A is%d B is%d HI=%b LO=%b\n",A,B,HI,LO);
#5 A='b11; B='b1;
#5 $write("A is%d B is%d HI=%b LO=%b\n",A,B,HI,LO);
#5 A='hffffffff; B='b1;
#5 $write("A is%d B is%d HI=%d LO=%d\n",A,B,HI,LO);
#5 A='hFFFFFFF7; B='h00000001;
#5 $write("A is%h B is%h HI=%d LO=%d\n",A,B,HI,LO);
#5 A='b11; B='b11;
#5 $write("A is%d B is%d HI=%b LO=%b\n",A,B,HI,LO);
#5 A='hffffffff;B='hfffffffe;
#5 $write("A is%h B is%h HI=%b LO=%b\n",A,B,HI,LO);
#5 A='hfffffff4;B='h00000002;
#5 $write("A is%h B is%h HI=%b LO=%b\n",A,B,HI,LO);
#5 A='hfffffffb;B='hfffffffe;
#5 $write("A is%h B is%h HI=%b LO=%b\n",A,B,HI,LO);
#5 A='hfffffff6;B='hfffffffb;
#5 $write("A is%h B is%h HI=%b LO=%b\n",A,B,HI,LO);


end
endmodule

