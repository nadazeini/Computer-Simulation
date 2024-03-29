// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B, CI);
output S,CO;
input A,B, CI;

wire sum_1, carry_01, carry_02;

HALF_ADDER ha_inst_1(.S(sum_1), .C(carry_01), .A(A), .B(B));
HALF_ADDER ha_inst_2(.S(S), .C(carry_02), .A(sum_1), .B(CI));

or or_inst(CO,carry_01,carry_02);


endmodule
