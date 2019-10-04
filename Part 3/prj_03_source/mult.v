// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A; //multiplicand
input [31:0] B; //multiplier
//add necessary wires
wire [31:0] wire_out[3:0];
wire [63:0] unsigned_out; //to be divided between LO and HI
wire xor_out;
wire [63:0] comp_out, product;

//instantiation following schematic order

// instantiate 2s complement twice

TWOSCOMP32 inst_2scomp1(wire_out[0],A);
TWOSCOMP32 inst_2scomp2(wire_out[2],B);

//instantiate 2 32bit 2x1 multiplexers

MUX32_2x1 mux1 (wire_out[1],A,wire_out[0],A[31]);
MUX32_2x1 mux2 (wire_out[3],B,wire_out[2],B[31]);

//instantiate 32bit unsigned multiplier

MULT32_U unsigned_multiplier(unsigned_out[63:32],unsigned_out[31:0], wire_out[3], wire_out[1]);

//instantiate xor
xor xor_inst(xor_out,A[31],B[31]);
//instantiate 3rs 2s complement
TWOSCOMP64 inst_2scomp3(comp_out,unsigned_out);
//instantiate a 64  bit 2x1 mux
MUX64_2x1 mult64(product,  unsigned_out,comp_out, xor_out);
 //divide Lo and Hi product
BUF32_1x1 buflo(LO,product[31:0]);
BUF32_1x1 bufhi(HI,product[63:32]); //review


endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A; //multiplicand
input [31:0] B; //multiplier
wire [31:0] and_out1 [31:0] ;

wire CO [31:0]; //carry out
AND32_2x1 and32_2x1(and_out1[0],A,{32{B[0]}});
buf CO_zero(CO[0],1'b0);
buf LO_zero(LO[0],and_out1[0][0]);
genvar i;
generate 
for(i=1;i<32;i=i+1)
begin : loop_mult
wire [31:0] and_out2; 
AND32_2x1 and32_2x1(and_out2,A,{32{B[i]}});
RC_ADD_SUB_32 adder(and_out1[i], CO[i], and_out2,{CO[i-1],{and_out1[i-1][31:1]}},1'b0 );//Sna is zero
buf LO_out(LO[i],and_out1[i][0]);
end
endgenerate
BUF32_1x1 buf32_1x1(HI,{CO[31],{and_out1[31][31:1]}});


//lab 12 explanation





endmodule
