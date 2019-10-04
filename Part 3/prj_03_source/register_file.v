// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);
// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;
wire [31:0] reg_wire [31:0];
wire [31:0] decoder_wire;
wire [31:0] and_wire;
wire [31:0] reg_out1;
wire [31:0] reg_out2;
wire notRST;
DECODER_5x32 decoder(decoder_wire, ADDR_W);
		//not(notRST,RST);
genvar i;
for (i=0; i<32; i=i+1)
begin : reg32_loop
		and and_inst(and_wire[i], decoder_wire[i], WRITE);
		 REG32 reg32(.Q(reg_wire[i]),.D(DATA_W) ,.LOAD(and_wire[i]), .CLK(CLK),.RESET(RST));
	end
MUX32_32x1 mux1(reg_out1, reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], 
reg_wire[4],  reg_wire[5],  reg_wire[6],  reg_wire[7],  reg_wire[8],  
reg_wire[9],  reg_wire[10], reg_wire[11], reg_wire[12],reg_wire[13], 
reg_wire[14], reg_wire[15], reg_wire[16],reg_wire[17], reg_wire[18], 
reg_wire[19], reg_wire[20], reg_wire[21], reg_wire[22], reg_wire[23], 
reg_wire[24], reg_wire[25], reg_wire[26], reg_wire[27], reg_wire[28],
reg_wire[29], reg_wire[30], reg_wire[31], ADDR_R1);
	MUX32_32x1 mux2(reg_out2, reg_wire[0], reg_wire[1], reg_wire[2], reg_wire[3], 
reg_wire[4],  reg_wire[5],  reg_wire[6],  reg_wire[7],  reg_wire[8],  
reg_wire[9],  reg_wire[10], reg_wire[11], reg_wire[12],reg_wire[13], 
reg_wire[14], reg_wire[15], reg_wire[16],reg_wire[17], reg_wire[18], 
reg_wire[19], reg_wire[20], reg_wire[21], reg_wire[22], reg_wire[23], 
reg_wire[24], reg_wire[25], reg_wire[26], reg_wire[27], reg_wire[28],
reg_wire[29], reg_wire[30], reg_wire[31], ADDR_R2);
	MUX32_2x1 mux3(DATA_R1, 32'bZ, reg_out1, READ);
	MUX32_2x1 mux4(DATA_R2, 32'bZ, reg_out2, READ);
endmodule
