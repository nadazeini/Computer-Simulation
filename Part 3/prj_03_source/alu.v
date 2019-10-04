// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [5:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;
wire notZERO;

//add wires
wire [31:0] and32_wire;
wire [31:0] or32_wire;
wire [31:0]nor32_wire;
wire[31:0] add_sub_out;
 wire[31:0] co_wire;
wire[31:0] hi_wire;
wire[31:0]lo_wire;
wire or_out,and_out,LnR;
wire[31:0] shifter_out;
wire[31:0] mux_wire;
wire[31:0] slt_out;

///32 bit logic gates
AND32_2x1 and32_inst(and32_wire,OP1,OP2);
OR32_2x1 or32_inst(or32_wire,OP1,OP2);
NOR32_2x1 nor32_inst(nor32_wire,OP1,OP2);


//1 bit logic gates
and and_inst(and_out,OPRN[0],OPRN[3]);
not not_inst(not_out,OPRN[0]);
or or_inst(or_out,and_out,not_out); //noy out is lnr



//adder/sub
RC_ADD_SUB_32 adder_sub(add_sub_out, co_wire[0], OP1, OP2, or_out);
//setless than
SET_LESS_THAN slt(slt_out,OP1,OP2);
//shifter
SHIFT32 barrel_shifter(shifter_out,OP1,OP2,OPRN[0]);
//multiplier
MULT32 multiplier(hi_wire,lo_wire,OP1,OP2);

//16x1 mux
MUX32_16x1 muxx(mux_wire, add_sub_out,add_sub_out,add_sub_out,lo_wire, shifter_out, shifter_out, and32_wire, or32_wire, nor32_wire,slt_out, slt_out, slt_out,slt_out,slt_out, slt_out,slt_out, OPRN[3:0]);
//final

or32x1 nor31(notZERO,mux_wire);
not notzero(ZERO,notZERO);


BUF32_1x1 buf_inst(OUT,mux_wire);



endmodule

`include "prj_definition.v"
module SET_LESS_THAN(result,Op1,Op2);
output [31:0]result;
reg [31:0] result;
input [31:0] Op1;
input [31:0] Op2;

always @(Op1 or Op2 or result)
begin
result = (Op1<Op2)?1:0;
end

/*
assign result = (rc_out<0)?result_one:result_zero; //return registers assigned
/*assign DATA_R2 = 
((READ===1'b1)&&(WRITE===1'b0))?data_ret_R2:{`DATA_WIDTH{1'bz} };



always @( Op1 or Op2 or result)
begin
if(rc_out>=0)
begin
result=0;
end
else if(rc_out<0)
begin
result=1;
end
end */
endmodule






module or32x1(Y, A);
	input [31:0] A;
	wire [29:0] Wire;//2 less than op
	output Y;
	or o0(Wire[0], A[0], A[1]);
	or o1(Wire[1], Wire[0], A[2]);
	or o2(Wire[2], Wire[1], A[3]);
	or o3(Wire[3], Wire[2], A[4]);
	or o4(Wire[4], Wire[3], A[5]);
	or o5(Wire[5], Wire[4], A[6]);
	or o6(Wire[6], Wire[5], A[7]);
	or o8(Wire[8], Wire[7], A[9]);
	or o9(Wire[9], Wire[8], A[10]);
	or o10(Wire[10], Wire[9], A[11]);
	or o11(Wire[11], Wire[10], A[12]);
	or o12(Wire[12], Wire[11], A[13]);
	or o13(Wire[13], Wire[12], A[14]);
	or o14(Wire[14], Wire[13], A[15]);
	or o15(Wire[15], Wire[14], A[16]);
	or o16(Wire[16], Wire[15], A[17]);
	or o17(Wire[17], Wire[16], A[18]);
	or o18(Wire[18], Wire[17], A[19]);
	or o19(Wire[19], Wire[18], A[20]);
	or o20(Wire[20], Wire[19], A[21]);
	or o21(Wire[21], Wire[20], A[22]);
	or o22(Wire[22], Wire[21], A[23]);
	or o23(Wire[23], Wire[22], A[24]);
	or o24(Wire[24], Wire[23], A[25]);
	or o25(Wire[25], Wire[24], A[26]);
	or o26(Wire[26], Wire[25], A[27]);
	or o27(Wire[27], Wire[26], A[28]);
	or o28(Wire[28], Wire[27], A[29]);
	or o29(Wire[29], Wire[28], A[30]);
	or o30(Y, Wire[29], A[31]);
endmodule
module NOR32_1x1(Y,A);
//output 
output [31:0] Y;
//input
input [31:0] A;


genvar i;
generate
for(i=0;i<32;i=i+1)
begin : nor32_gen
	nor nor32_inst(Y[i],A[i]);
end

endgenerate

endmodule

