`timescale 1ns/1ps
`include "prj_definition.v"
module rc_add_sub_32_tb;

reg [`DATA_INDEX_LIMIT:0] A; //op1
reg [`DATA_INDEX_LIMIT:0] B; //op2
reg SnA; 
wire [`DATA_INDEX_LIMIT:0] Y; //result
wire CO; //carry out
RC_ADD_SUB_32 rc32_inst(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));
initial
begin
#5 A=0; B=0; SnA=0;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=0; B=0; SnA=1;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=9; B=8; SnA=0;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=9; B=8; SnA=1;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=5; B=5; SnA=1;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=5; B=5; SnA=0;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
end
endmodule

/*

module rc_add_sub_32_tb;

reg [63:0] A; //op1
reg [63:0] B; //op2
reg SnA; 
wire [63:0] Y; //result
wire CO; //carry out
 RC_ADD_SUB_64 rc64_inst(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));
initial
begin
#5 A=0; B=0; SnA=0;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=0; B=0; SnA=1;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=9; B=8; SnA=0;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=9; B=8; SnA=1;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=5; B=5; SnA=1;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
#5 A=7; B=10; SnA=1;
#5 $write("\n A=%d SnA=%d B=%d result is:%d  CO is %d\n",A,SnA,B,Y,CO);
end
endmodule
*/