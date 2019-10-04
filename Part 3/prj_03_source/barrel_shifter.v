// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,shift, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] shift;
input LnR;
wire[31:0] wire_out1,wire_out2,mux_out;
wire or_out;

SHIFT32_R sr(.Y(wire_out1),.D(D),.shift(shift[4:0]));

SHIFT32_L sl(.Y(wire_out2),.D(D),.shift(shift[4:0]));

MUX32_2x1 mux2x1(.Y(mux_out),.I0(wire_out1),.I1(wire_out2),.S(LnR));
MUX32_2x1 mux32_2x1(.Y(Y),.I0(mux_out),.I1(0),.S(or_out));

OR27_1x1 or27_inst(or_out,{5'b0,{shift[31:5]}});

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,shift, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] shift;
input LnR;
wire[31:0] wire_out1,wire_out2,mux_out;
wire or_out;

SHIFT32_R shift_right(.Y(wire_out1),.D(D),.shift(shift[4:0]));

SHIFT32_L shift_left(.Y(wire_out2),.D(D),.shift(shift[4:0]));

MUX32_2x1 mux1(.Y(mux_out),.I0(wire_out1),.I1(wire_out2),.S(LnR));
MUX32_2x1 mux2(.Y(Y),.I0(mux_out),.I1(0),.S(or_out));


OR27_1x1 or27_inst(or_out,{1'b0,{shift[4:1]}});


endmodule
//27 bit or
module OR27_1x1(Y,A);
//output 
output  Y;
//input
input [31:0] A;
wire [29:0] wire_out;
genvar i;
generate
for(i=0;i<31;i=i+1)
begin : or_gen_loop
if(i==0)
begin
	or orzero_inst(wire_out[0],A[0],A[1]);
end
else if(i==30)
begin
or or_inst30(Y,wire_out[29],A[31]);
end
else
begin
or or_inst(wire_out[i],wire_out[i-1],A[i+1]);
end


end


endgenerate
endmodule
// Right shifter
module SHIFT32_R(Y,D,shift);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] shift;

wire [31:0] wire_out[3:0];
genvar i, j,k,l;

generate
	for(i=0;i<32;i=i+1)
	begin : loop1
	
		if(i==31)
		begin
			MUX1_2x1 mux0(.Y(wire_out[0][i]),.I0(D[i]),.I1(1'b0),.S(shift[0]));
		end
		else
		begin
			MUX1_2x1 mux1(.Y(wire_out[0][i]),.I0(D[i]),.I1(D[i+1]),.S(shift[0]));
		end

	end //for loop

for(j=0;j<3;j=j+1)
begin : loop2
	for(k=0;k<32;k=k+1)
	begin : inner_loop
		if(k>=32-2**(j+1))
		begin
			
MUX1_2x1 mux4(.Y(wire_out[j+1][k]),.I0(wire_out[j][k]),.I1(1'b0),.S(shift[j+1]));
			
		end
		else
		begin
MUX1_2x1 mux3(.Y(wire_out[j+1][k]),.I0(wire_out[j][k]),.I1(wire_out[j][k+2**(j+1)]),.S(shift[j+1]));


		end
	end
end

for(l=0;l<32;l=l+1)
begin: loop3_final
	if(l>=16)
	begin
MUX1_2x1 mux6(.Y(Y[l]),.I0(wire_out[3][l]),.I1(1'b0),.S(shift[4]));
	
	end
	else
	begin
	MUX1_2x1 mux5(.Y(Y[l]),.I0(wire_out[3][l]),.I1(wire_out[3][l+16]),.S(shift[4]));
	end
end
endgenerate


endmodule

// Left shifter
module SHIFT32_L(Y,D,shift);
// output list
output [31:0] Y; //output
// input list
input [31:0] D; //operand
input [4:0] shift; //shift number of shifts
//add wire
wire [31:0] wire_out[3:0];
genvar i, j,k,l;
generate
	for(i=0;i<32;i=i+1)
	begin : loop1
	
		if(i==0)
		begin
			MUX1_2x1 mux0(.Y(wire_out[0][i]),.I0(D[i]),.I1(1'b0),.S(shift[0]));
		end
		else
		begin
			MUX1_2x1 mux1(.Y(wire_out[0][i]),.I0(D[i]),.I1(D[i-1]),.S(shift[0]));
		end

	end //for loop

for(j=0;j<3;j=j+1)
begin : loop2
	for(k=0;k<32;k=k+1)
	begin : inner_loop
		if(k<2**(j+1))
		begin

			MUX1_2x1 mux3(.Y(wire_out[j+1][k]),.I0(wire_out[j][k]),.I1(1'b0),.S(shift[j+1]));

		end
		else
		begin
			MUX1_2x1 mux4(.Y(wire_out[j+1][k]),.I0(wire_out[j][k]),.I1(wire_out[j][k-2**(j+1)]),.S(shift[j+1]));
		end
	end
end
for(l=0;l<32;l=l+1)
begin: loop3_final
	if(l<16)
	begin
MUX1_2x1 mux6(.Y(Y[l]),.I0(wire_out[3][l]),.I1(1'b0),.S(shift[4]));
	
	end
	else
	begin
	MUX1_2x1 mux5(.Y(Y[l]),.I0(wire_out[3][l]),.I1(wire_out[3][l-16]),.S(shift[4]));
	end
end
endgenerate


endmodule

