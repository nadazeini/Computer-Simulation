// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

//wire for xor result
wire [63:0] xor_result;
//wire to connec tfull adders Sna,CO,CI
wire [63:0] next_connect;
genvar i;
generate 
for (i=0;i<64;i=i+1)
begin:  rc_add_sub_64_loop

xor xor_inst(xor_result[i],SnA,B[i]); //connecting SnA with input B to get output Y 

if(i==0) //if lsb connect snA to fa, input B(xor result)m op1 (input A), next >CO, output Y
	begin FULL_ADDER fa(Y[i],next_connect[i],A[i],xor_result[i],SnA);
	end
else if(i==63)
	begin FULL_ADDER fa(Y[i],CO,A[i],xor_result[i],next_connect[i-1]); //CO intsead of SnA and next_connect[i-1] instead of next_connect[i]
	end
else if(i !=0 && i!=63)
	begin FULL_ADDER fa(Y[i],next_connect[i],A[i],xor_result[i],next_connect[i-1]);
	end
else
	begin
	end

end
endgenerate

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;


//add wires

//wire for xor result
wire [31:0]xor_result;
//wire to connec tfull adders Sna,CO,CI
wire [31:0] next_connect;
genvar i;
generate 
for (i=0;i<32;i=i+1)
begin:  rc_add_sub_32_loop
xor xor_inst(xor_result[i],SnA,B[i]);
if(i==0) //if lsb connect snA to fa, input B(xor result)m op1 (input A), next >CO, output Y
	begin FULL_ADDER fa(Y[i],next_connect[i],A[i],xor_result[i],SnA);
	end
else if(i==31)
	begin FULL_ADDER fa(Y[i],CO,A[i],xor_result[i],next_connect[i-1]); //CO intsead of SnA and next_connect[i-1] instead of next_connect[i]
	end
else if(i !=0 && i!=31)
	begin FULL_ADDER fa(Y[i],next_connect[i],A[i],xor_result[i],next_connect[i-1]);
	end


end
endgenerate


endmodule


