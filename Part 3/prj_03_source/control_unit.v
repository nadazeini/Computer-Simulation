// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
// Output signals
output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
output READ, WRITE;

// input signals
input ZERO, CLK, RST;
input [`DATA_INDEX_LIMIT:0] INSTRUCTION;


// State nets
wire [2:0] proc_state;

PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

//control signal generation  

// a) add registers for corresponding outputs 
reg [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
reg READ, WRITE;

reg [`DATA_INDEX_LIMIT:0] INST_REG;
//initialize
initial 
begin
PC_REG = `INST_START_ADDR; //32'h00001000 from prj_definition
SP_REF = `INIT_STACK_POINTER; // 32'h03ffffff from prj_definition
end
reg [5:0] opcode;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;


always @ (proc_state)
begin

case(proc_state)
	
	`PROC_FETCH : begin
		READ=1; WRITE=0;
//at this stage ma_sel_2 and mem_r are 1 >READ is 1
		CTRL=32'b00000000000000000000000001000000;
		      end
	`PROC_DECODE : begin
			INST_REG = INSTRUCTION ;
//ctrl 14 for reg read is on
CTRL=32'b00000000000000100000000000000000;
			// Store the memory read data into INST_REG
			// parse the instruction 
			// R-type 
			{opcode, rs, rt, rd, shamt, funct} = INST_REG; 
			// I-type
			{opcode, rs, rt, immediate } = INST_REG; 
			// J-type 
			{opcode, address} = INST_REG; 
			/*calculate and store sign extended value of immediate 
			IMM_SIGN_EXT = {{16{immediate[15]}},immediate};
			// same for zero extension
			IMM_ZERO_EXT = {{16{1'b0}},immediate};
			//lui value for I type
			LUI= {immediate,{16{1'b0}}};
			//For j-type inst store 32 bit jump address from the address field
			JumpAddr = {6'b0,address};
			//set the read address of RF as rs and rt field value 
			RF_ADDR_R1 = rs;
			RF_ADDR_R2 = rt; */
			//with RF operation set to reading.
			READ = 1; WRITE = 0;
			print_instruction(INST_REG);
			end

				`PROC_EXE : begin
				READ = 1; WRITE = 0;
				case(opcode) //depends on ALU control
				//R type
		
				6'h00: //addition
				begin
				//ALU_OP1 = RF_DATA_R1; >>replace reg1
				//ALU_OP2 = RF_DATA_R2;>> replace reg2
				if(funct === 6'h20)
				begin   //ALU_OPRN='h01;	
				//op2 sel 4 is 1 except for shift
				//21 to 16 for alu oprn 
				CTRL='b00000000100000000000010000000000;  
				end
				else if(funct === 6'h22) //substraction
				begin   
					CTRL='b00000000100000000000100000000000;
					end
				else if(funct === 6'h2c) //multiply
				begin 
					CTRL='b00000000100000000000110000000000;	
					end
				else if(funct === 6'h24) //bitwise and
				begin 
					CTRL='b00000000100000000001100000000000;//6
					end
				else if(funct === 6'h25) //bitwise or
				begin  
					 CTRL='b00000000100000000001110000000000;//7
					end
				else if(funct === 6'h27) //logical nor
				begin   
					CTRL='b00000000100000000010000000000000;//8
					
					end
				else if(funct === 6'h2a) //set less than
				begin   
					CTRL='b00000000100000000010010000000000;//9	
					
					end
				else if(funct === 6'h01) //shift left //op2 sel 1 and 3 are active
				begin  
					CTRL='b00000101000000000001010000000000;//5
					end
				else if(funct === 6'h02) //shift right
				begin 
					CTRL='b00000101000000000001000000000000;//4
					end
				 else if(funct === 6'h08)   //jump
				 begin 
	    			 end
				 else
				 begin
				 $write("Operation of R type not found or no operation was called\n");
				 end
end

       
				//for the else 
				// for this op code and so for R type
			//I type
			// differs by opcode not by funct like R-type

			//
			//op2_sel_2 and oprn alu
			6'h08:	//imm addition
			begin 		
			     CTRL=32'b00000010000000000000010000000000;//1
			end
			6'h1d: //muli	
			begin 		
			       CTRL=32'b00000010000000000000110000000000;//3
			end
			6'h0c: //andi 	
			begin 		
			     //op2_sel_2 is 0 oprn is 6
			   CTRL=32'b00000000000000000001100000000000;//6
			end
			6'h0d: //ori	
			begin 		
			     	
			    CTRL=32'b00000000000000000001110000000000;//7
			end
			6'h0f: 
			begin
			end //lui //no need for alu operation	
			6'h0a: //set less than imm	
			begin 		
			    //sign extend //9
			 CTRL=32'b00000010000000000010010000000000;//9
			end
			6'h23: //load word
			begin 		
			     //sign
			     CTRL=32'b00000010000000000000010000000000;//1
			end
		
			6'h04: //beq //to later specify in wb addr sel 2 in wb
			begin
			CTRL='b00000000100000000000100000000000; //r type sub op2_sel4 is 1 and sub
			end
			
			6'h05: //bne
			begin
			CTRL='b00000000100000000000100000000000; 
			end
			6'h2b: //store word
			begin 		
			    
			       CTRL=32'b00000010000000000000010000000000;//1 op2 sel2 is 1
			end //end for I type

			6'h02: //jmp
			begin
			
			end
			6'h03: //jal
			begin
			
			end

			//J-type
			//jmp and jal empty no need begin end 
			6'h1b: //PUSH TO STACK	
			begin 		//op2_sel_3 should be 1 //op1_sel_1 should be 1
			  CTRL='b00001001000000000000100000000000;

			//reg set to read //oprn to substract
			end
			6'h1c: //POP FROM STACK
			begin
			//add 1 to sp; 1 is first operand 
			//sp load on 23 and add on 21
			CTRL=32'b00001001000000000000010100000000;
			end
			
			default:$write("No operation of I or J type found or no operation was called\n");
		endcase 
	end

	`PROC_MEM : begin
/*Only sw lw push pop instructions are involved 
by default set memory to 00 or 11 hiZ
for the four memory related operation set mem read or write mode accordingly 
the address for the stack operation needs to be set carefully following the ISA specification*/
			READ=0;
			WRITE=0; //set to HiZ
			case(opcode)
	
			//Load Word
			6'h23:
			begin
			
			READ = 1;
			WRITE=0; 
			//sign
			     CTRL=32'b00000010000000000000010000000000;//1
			end
			//Store Word
			6'h2b:
			begin
			  READ = 0;
            WRITE = 1;
            CTRL=32'b00000010000000000000010000000000;
			end
			//Push
			6'h1b:
			begin
			 READ = 0;
            WRITE = 1;
           CTRL='b00001001000000000000100000000000;
			end
			//pop
			6'h1c:
			begin
			  READ = 1;
            WRITE = 0;
            //SP_REF+1;
            CTRL=32'b00001001000000000000010100000000;
		
			end
	default: $write("memory default");
			endcase
			end
	`PROC_WB: begin
		/*write back to RF or PC_REG is done here*/
		//increase PC_REG by 1
		
		//set RF writing address, data and control to write back into register file>>needed for most of the intsructions
		RF_READ = 0; 
		RF_WRITE=1;
		//for each ctrl 15 is 1
		
case(opcode)

//r type
6'h00: 
	begin
		if(funct==6'h08)
		begin
		PC_REG=RF_DATA_R1;
		end
		else 
			begin
				CTRL=32'b00000000000000010000000000000000;
				
			end
	end 

//I type
6'h08: //addi
	begin
	RF_ADDR_W=rt;
	RF_DATA_W=ALU_RESULT;

	end

6'h1d: //muli
	begin
	RF_ADDR_W=rt;
	RF_DATA_W=ALU_RESULT;

	end
6'h0c: //andi
	begin
	RF_ADDR_W=rt;
	RF_DATA_W=ALU_RESULT;

	end
6'h0d: //ori
	begin
	RF_ADDR_W=rt;
	RF_DATA_W=ALU_RESULT;

	end

6'h0a: //set less than imm
	begin
	RF_ADDR_W=rt;
	RF_DATA_W = ALU_RESULT; 
	end 
6'h04: //branch on equal beq 
	//beq and bne need to modify the PC_REG accordingly to the instruction specification
	begin
	if(RF_DATA_R1 === RF_DATA_R2)
	begin
	ALU_OP1=PC_REG;
	ALU_OP2=IMM_SIGN_EXT;
	ALU_OPRN='h01; //add
	PC_REG=ALU_RESULT;
	end
	end
6'h05: //branch on not equal beq
	begin
	if(RF_DATA_R1 !== RF_DATA_R2)
	begin
	ALU_OP1=PC_REG;
	ALU_OP2=IMM_SIGN_EXT;
	ALU_OPRN='h01; //add
	PC_REG=ALU_RESULT;
	end
	end
6'h23: //load word
	begin
	end
6'h2b: //unnecessary sw
	begin
	end
//J type
//to modify the PC_REG accordingly to the instruction specification
6'h02: //jump to address jmp
	begin
	PC_REG=JumpAddr-1; //pc=jump address //-1 cause 1 added
	end
6'h03: //jal jump and link 
	begin
	
	RF_ADDR_W=31;
	RF_DATA_W=PC_REG+1; // incremented by 1
	PC_REG=JumpAddr-1; 

	end
6'h1b: //push to stack 
	begin
	SP_REF=ALU_RESULT;
	end
6'h1c: //pop from stack
	begin
	RF_ADDR_W=0;
	RF_DATA_W=MEM_DATA;

	end
6'h0f: //lui
begin
RF_ADDR_W=rt;
RF_DATA_W=LUI;
end

default: 
begin
RF_ADDR_W=rt;
RF_DATA_W=ALU_RESULT;
end
endcase
PC_REG = PC_REG +1;
end
endcase
end

task print_instruction; 
input [`DATA_INDEX_LIMIT:0] inst; 
reg [5:0]   opcode; 
reg [4:0]   rs; 
reg [4:0]   rt; 
reg [4:0]   rd; 
reg [4:0]   shamt; 
reg [5:0]   funct; 
reg [15:0]  immediate; 
reg [25:0]  address;
 begin 
// parse the instruction 
// R-type
 {opcode, rs, rt, rd, shamt, funct} = inst;
 // I-type
 {opcode, rs, rt, immediate } = inst;
 // J-type
 {opcode, address} = inst; 
$write("@ %6dns -> [0X%08h] ", $time, inst); 
case(opcode) 
// R-Type 
6'h00 : begin            
	case(funct)               
 	6'h20: $write("add  r[%02d], r[%02d], r[%02d];", rs, rt, rd);   
        6'h22: $write("sub  r[%02d], r[%02d], r[%02d];", rs, rt, rd);                
	6'h2c: $write("mul  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
	6'h24: $write("and  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
	6'h25: $write("or   r[%02d], r[%02d], r[%02d];", rs, rt, rd);                
	6'h27: $write("nor  r[%02d], r[%02d], r[%02d];", rs, rt, rd);                
	6'h2a: $write("slt  r[%02d], r[%02d], r[%02d];", rs, rt, rd);                
	6'h01: $write("sll  r[%02d], %2d, r[%02d];", rs, shamt, rd);                
	6'h02: $write("srl  r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);                
	6'h08: $write("jr   r[%02d];", rs);                
	default: $write("");            
      endcase        
    end 
// I-type 
6'h08 : $write("addi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h1d : $write("muli  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h0c : $write("andi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h0d : $write("ori   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h0f : $write("lui   r[%02d], 0X%04h;", rt, immediate); 
6'h0a : $write("slti  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
6'h04 : $write("beq   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h05 : $write("bne   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h23 : $write("lw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
6'h2b : $write("sw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate); 
// J-Type 
6'h02 : $write("jmp   0X%07h;", address); 
6'h03 : $write("jal   0X%07h;", address); 
6'h1b : $write("push;"); 
6'h1c : $write("pop;"); 
default: $write(""); 
endcase $write("\n"); 
end 
endtask 
endmodule




//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------

module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

// state machine implementation
//define state and next_state registers
reg [2:0] STATE;
reg [2:0] next_state;

//assign state to output STATE

//reset on negative edge of the RST 
//set the next state to fetch
//state to 2'bxx 2 bit unknown
// initiation of state > lab 8 referral
//`define STATE_X = 2'bxx;
initial 
begin
STATE= 2'bxx;
 next_state= `PROC_FETCH;
end

//reset signal handling

always @ (negedge RST)
begin 
STATE= 2'bxx;
 next_state=`PROC_FETCH;
end

//upon each positive edge of the clk
//assign state with next_state value 
//also determine next_state depending on state current value

/*so we use case (current state) 
to determine next state*/ 
//state switching
always @ (posedge CLK)

begin 
	case(next_state)
	`PROC_FETCH :
begin
STATE=next_state;
next_state = `PROC_DECODE;
end
	`PROC_DECODE : 
begin
STATE=next_state;
next_state= `PROC_EXE;
end
	`PROC_EXE :
begin 
STATE=next_state;
next_state= `PROC_MEM;
end
	`PROC_MEM : begin
STATE=next_state;
next_state= `PROC_WB;
end
	`PROC_WB : begin 
STATE=next_state;
next_state= `PROC_FETCH;
end
	default : 
begin
STATE=2'bxx;
next_state= `PROC_FETCH;
end
endcase

end


 




endmodule 
