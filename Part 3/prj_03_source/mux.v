// Name: mux.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
input [31:0] I8, I9, I10, I11, I12, I13, I14, I15;
input [31:0] I16, I17, I18, I19, I20, I21, I22, I23;
input [31:0] I24, I25, I26, I27, I28, I29, I30, I31;
input [4:0] S;

// done last
//need 2 32-bit 16x1 mux and 1 32-bit 
//add wires
wire [31:0] mux16x1_out1,mux16x1_out2;

MUX32_16x1 mux16x1_1(mux16x1_out1,I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,S[3:0]);
MUX32_16x1 mux16x1_2(mux16x1_out2, I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31,S[3:0]);
MUX32_2x1 mux2x1(Y,mux16x1_out1,mux16x1_out2,S[4]); 


endmodule

// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [31:0] I8;
input [31:0] I9;
input [31:0] I10;
input [31:0] I11;
input [31:0] I12;
input [31:0] I13;
input [31:0] I14;
input [31:0] I15;
input [3:0] S;
//need 2 32-bit 8x1 and 1 32-bit 2x1 mux
//add wires
wire [31:0] mux8x1_out1,mux8x1_out2;
MUX32_8x1 mux8x1_1(mux8x1_out1,I0,I1,I2,I3,I4,I5,I6,I7,S[2:0]);
MUX32_8x1 mux8x1_2(mux8x1_out2,I8,I9,I10,I11,I12,I13,I14,I15,S[2:0]);
MUX32_2x1 mux2x1(Y,mux8x1_out1,mux8x1_out2,S[3]);
endmodule

// 32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [2:0] S;
//done 4th
// need 2 32 bit 4x1 mux and 1 32-bit 2x1
//add wires
wire [31:0] mux4x1_out1,mux4x1_out2;
MUX32_4x1 mux4x1_1(mux4x1_out1,I0,I1,I2,I3,S[1:0]);
MUX32_4x1 mux4x1_2(mux4x1_out2,I4,I5,I6,I7,S[1:0]);
MUX32_2x1 mux2x1(Y,mux4x1_out1,mux4x1_out2,S[2]); //review

endmodule

// 32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [1:0] S;

// done third
//use 3 of MUX32_2x1 to implement 32_4x1
//add wires to connect them
wire [31:0] mux1out, mux2out;

MUX32_2x1 mux2x1_1(mux1out,I0,I1,S[0]);
MUX32_2x1 mux2x1_2(mux2out,I2,I3,S[0]);
MUX32_2x1 mux2x1_3(Y,mux1out,mux2out,S[1]); //review
endmodule






//added by myself
//64bit mux
module MUX64_2x1(Y, I0, I1, S);
// output list
output [63:0] Y;
//input list
input [63:0] I0;
input [63:0] I1;
input S;

genvar i;
generate
for(i=0;i<64;i=i+1)
begin: mux64_loop
MUX1_2x1 mux64_2x1(Y[i],I0[i],I1[i],S);
end
endgenerate

endmodule
// 32-bit mux
module MUX32_2x1(Y, I0, I1, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input S;

///done second
genvar i;
generate
for(i=0;i<32;i=i+1)
begin: mux32_2x1_loop
MUX1_2x1 mux32_2x1(Y[i],I0[i],I1[i],S);
end
endgenerate

endmodule

// 1-bit mux
module MUX1_2x1(Y,I0, I1, S);
//output list
output Y;
//input list
input I0, I1, S;
//S is control
//done first 
wire not_output,and_output1,and_output2;
not not_inst(not_output,S);
and and_inst1(and_output1,not_output,I0);
and and_inst2(and_output2,S,I1);
or or_inst(Y,and_output1,and_output2);

endmodule


// 26-bit mux
module MUX26_2x1(Y, I0, I1, S);
// output list
output [25:0] Y;
//input list
input [25:0] I0;
input [25:0] I1;
input S;

genvar i;
generate
for(i=0;i<26;i=i+1)
begin: mux26_2x1_loop
MUX1_2x1 mux26_2x1(Y[i],I0[i],I1[i],S);
end
endgenerate

endmodule


//5 bit 2x1 mux
module MUX5_2x1(Y, I0, I1, S);
// output list
output [4:0] Y;
//input list
input [4:0] I0;
input [4:0] I1;
input S;

genvar i;
generate
for(i=0;i<5;i=i+1)
begin: mux5_2x1_loop
MUX1_2x1 mux5_2x1(Y[i],I0[i],I1[i],S);
end
endgenerate

endmodule
