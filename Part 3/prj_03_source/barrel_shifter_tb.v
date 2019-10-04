
/*`timescale 1ns/1ps
module barrel_shifter_tb;
reg [31:0] A;
reg [31:0] S;
reg LnR;
wire[31:0] Y;
SHIFT32 shift32(.Y(Y),.A(A),.S(S),.LnR(LnR));
initial begin */
`timescale 1ns/1ps
module barrel_shifter_tb;
	reg [31:0] A;
	reg [31:0] shift;
	reg leftNotRight;
	wire [31:0] result;
	SHIFT32 ls(.Y(result), .D(A), .shift(shift),
		.LnR(leftNotRight));
	initial begin
		#5;
		#5 A='b1; shift='b1; leftNotRight='b0;
		#5 golden(result,'b0, A, shift, leftNotRight);
		
		#5 A='b11000; shift='b11; leftNotRight='b0;
		#5 golden(result,'b11, A, shift, leftNotRight);
		
		#5 A='b100; shift='b10; leftNotRight='b0;
		#5 golden(result,'b1, A, shift, leftNotRight);
		#5 A='b100; shift='b11; leftNotRight='b0;
		#5 golden(result,'b0, A, shift, leftNotRight);
		
		
	
		
		
		
		
		
		
	end

	task golden;
		input [31:0] calculated;
		input [31:0] expected;
		input [31:0] operand;
		input [31:0] shift;
		input leftNotRight; begin
			if (calculated==expected) begin
				$write("[PASSED]");
			end else begin
				if(leftNotRight) begin
					$write("%d << %d = %d got %d", operand, shift, expected, calculated);
					$write("[FAILED]");
				end else begin
					$write("%d >> %d = %d got %d", operand, shift, expected, calculated);
					$write("[FAILED]");
				end
			end 
			$write("\n");
			$write("Run barrel shift TB\n");
		end
	endtask
endmodule 