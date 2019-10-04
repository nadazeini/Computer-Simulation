`timescale 1ns/1ps
module half_adder_tb;

reg A;
reg B;
wire S,C;

HALF_ADDER ha_inst_tb(.S(S), .C(C), .A(A), .B(B));
initial
begin
A=0; B=0;
#5 A=1; B=0;
#5 A=0; B=1;
#5 A=1; B=1;
end
endmodule
