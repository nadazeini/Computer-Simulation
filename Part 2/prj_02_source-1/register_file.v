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

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;


// a) add registers for corresponding output ports 
// not same as output
// in memory it's reg  data_ret

reg [`DATA_INDEX_LIMIT:0] data_ret_R1, data_ret_R2;  // return data registers


// b) add 32x3 memory storage  similar to 32x64M memory in memory.v
// memory bank


reg [`DATA_INDEX_LIMIT:0] reg_32x32 [0:`REG_INDEX_LIMIT]; // memory storage, REG INDEX LIMIT instead of mem index limit
integer i; // index for reset operation


assign DATA_R1 = 
((READ===1'b1)&&(WRITE===1'b0))?data_ret_R1:{`DATA_WIDTH{1'bz} }; //return registers assigned
assign DATA_R2 = 
((READ===1'b1)&&(WRITE===1'b0))?data_ret_R2:{`DATA_WIDTH{1'bz} };


// c) add initial block for initializing content of all 32 registers as 0 
// set initial state and will use for loop

initial
begin
for(i=0; i<`DATA_INDEX_LIMIT ; i = i + 1)
 reg_32x32[i]={`DATA_WIDTH{1'b0}}; //REPLICATION 
end


// d) register block  is always reset on negative edge of RST signal 
// same memory.v code
always @ (negedge RST or posedge CLK)

begin
if (RST === 1'b0)
begin
for(i=0; i<`DATA_INDEX_LIMIT ; i = i + 1)
 reg_32x32[i]={`DATA_WIDTH{1'b0}}; 
end 

// start reading
else 
begin
   if ((READ===1'b1)&&(WRITE===1'b0)) // read operation
begin
	data_ret_R1 =  reg_32x32[ADDR_R1]; // read the value from the address for data 1 and 2
	data_ret_R2 =  reg_32x32[ADDR_R2];
end 
   else if ((READ===1'b0)&&(WRITE===1'b1)) // write operation
reg_32x32[ADDR_W] = DATA_W; // f ) on write request ADDR_W content is modified to DATA_W
end 
end
// do not handle 00 or 11 for such configuration the the RF holds the previous data
endmodule
