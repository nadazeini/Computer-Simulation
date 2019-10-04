// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

//add wires
wire [31:0] pc_load,ir_load,sp_load, alu_out;
wire[31:0] op1_sel_1,md_sel_1;
wire [31:0] op2_sel_1,op2_sel_2,op2_sel_3,op2_sel_4;
wire [31:0] wd_sel_1,wd_sel_2,wd_sel_3;
wire [25:0] pc_sel_1,pc_sel_2,pc_sel_3;
wire[25:0] ma_sel_1;
wire[31:0] ma_sel_2;
wire [31:0] reg1, reg2;
wire [4:0] r1_sel_1,wa_sel_1,wa_sel_2,wa_sel_3;
wire[31:0] add_out1,add_out2;
wire not_needed;

RC_ADD_SUB_32 adder1(.Y(add_out1), .CO(not_needed), .A(32'h01), .B(pc_load), .SnA(1'b0));
 
RC_ADD_SUB_32 adder2(.Y(add_out2), .CO(not_needed), .A(add_out1), .B({{16{ir_load[15]}},ir_load[15:0]}), .SnA(1'b0));

//26 bit multiplexer done in mux.v 2x1
MUX26_2x1 pc1_mux(.Y(pc_sel_1), .I0(reg1[25:0]), .I1(add_out2[25:0]), .S(CTRL[0])); //0
MUX26_2x1 pc2_mux(.Y(pc_sel_2),.I0(pc_sel_1),.I1(add_out1[25:0]),.S(CTRL[1]));//1
MUX26_2x1 pc3_mux(.Y(pc_sel_3),.I0(ir_load[25:0]),.I1(pc_sel_2),.S(CTRL[2]));//2
//r1_sel_1
MUX5_2x1 r1_sel1mux(.Y(r1_sel_1), .I0(ir_load[25:21]), .I1(5'b0), .S(CTRL[3]));//3

//op1_sel_1
MUX32_2x1 op1_mux(.Y(op1_sel_1),.I0(reg1),.I1(sp_load),.S(CTRL[4])); //4
//op2_sel_#
MUX32_2x1 op2_sel_1mux(.Y(op2_sel_1),.I0(1),.I1({27'b0,ir_load[10:6]}),.S(CTRL[5])); //5
MUX32_2x1 op2_sel_2mux(.Y(op2_sel_2),.I0({{16'b0},ir_load[15:0]}),.I1({{16{ir_load[15]}},ir_load[15:0]}),.S(CTRL[6]));//6
MUX32_2x1 op2_sel_3mux(.Y(op2_sel_3),.I0(op2_sel_2),.I1(op2_sel_1),.S(CTRL[7]));//7
MUX32_2x1 op2_sel_4mux(.Y(op2_sel_4),.I0(op2_sel_3),.I1(reg2),.S(CTRL[8]));//8
//wa_sel_#

MUX5_2x1  wa1_mux(.Y(wa_sel_1),.I0(ir_load[15:11]/*rd*/),.I1(ir_load[20:16]/*rt*/),.S(CTRL[9]));
MUX5_2x1 wa2_mux(.Y(wa_sel_2),.I0(0),.I1(31),.S(CTRL[10]));
MUX5_2x1 wa3_mux(.Y(wa_sel_3),.I0(wa_sel_2),.I1(wa_sel_1),.S(CTRL[11]));

//PC REGISTER
defparam PC.PATTERN=32'h00001000;
REG32_PP PC(.Q(pc_load),.D({6'b0,pc_sel_3}),.LOAD(CTRL[12]),.CLK(CLK),.RESET(RST));
//SP 
defparam SP.PATTERN=32'h03fffffff;
REG32_PP SP(.Q(sp_load),.D(alu_out),.LOAD(CTRL[23]),.CLK(CLK),.RESET(RST));

//IR 
REG32 inst_loadreg(.Q(ir_load), .D(DATA_IN),.LOAD(CTRL[13]), .CLK(CLK), .RESET(RST));

//Register file
REGISTER_FILE_32x32 regfile(.DATA_R1(reg1), .DATA_R2(reg2), .ADDR_R1(r1_sel_1), .ADDR_R2(ir_load[20:16]/*rt*/), 
                            .DATA_W(wd_sel_3), .ADDR_W(wa_sel_3), .READ(CTRL[14]), .WRITE(CTRL[15]), .CLK(CLK), .RST(RST));

//ALU
ALU alu(.OUT(alu_out), .ZERO(ZERO), .OP1(op1_sel_1), .OP2(op2_sel_4), .OPRN(CTRL[21:16]));

//md_sel_1

MUX32_2x1 md_mux(.Y(DATA_OUT),.I0(reg2),.I1(reg1),.S(CTRL[22]));



//ma_sel_#
MUX32_2x1 ma_sel1mux(.Y(ma_sel_1),.I0(alu_out),.I1(sp_load),.S(CTRL[24]));
MUX26_2x1 ma_sel2mux(.Y(ma_sel_2),.I0(ma_sel_1),.I1(pc_load[25:0]),.S(CTRL[25]));

//wd_sel_#
MUX32_2x1 wd_sel_1mux(.Y(wd_sel_1),.I0(alu_out),.I1(DATA_IN),.S(CTRL[26]));
MUX32_2x1 wd_sel2mux(.Y(wd_sel_2),.I0(wd_sel_1),.I1({ir_load[15:0],{16{ir_load[15]}}}),.S(CTRL[27]));
MUX32_2x1 wd_sel3mux(.Y(wd_sel_3),.I0(add_out2),.I1(wd_sel_2),.S(CTRL[28]));







endmodule
