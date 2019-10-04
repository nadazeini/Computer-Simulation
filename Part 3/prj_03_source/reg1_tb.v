`timescale 1ns/1ps
module reg1_tb;
	
reg D, C, L;
reg nP, nR;
wire Q,Qbar;
REG1 reg1(Q, Qbar, D, L, C, nP, nR);
	initial begin
		nR = 'b1;
		#5 L='b1;
		#5 D='b1; nP='b1;
		#5 C='b0; 
		#5 C='b1;
		#5 C='b0; 
		#5 C='b1;
		#5 
		#5 $write("\nC = %d L=%d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,L,nP,nR,D,Q,Qbar) ;

		#5 nR=0;
		#5 L='b1;
		#5 D='b1; nP='b0;
		#5 C='b0; 
		#5 C='b1;
		#5 C='b0; 
		#5 C='b1;
		#5 
	#5 $write("\nC = %d L=%d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,L,nP,nR,D,Q,Qbar) ;
		#5 nR=0;
		#5 L='b1;
		#5 D='b1; nP='b1;
		#5 C='b0; 
		#5 C='b1;
		#5 C='b0; 
		#5 C='b1;
		#5 
	#5 $write("\nC = %d L=%d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,L,nP,nR,D,Q,Qbar) ;



		#5 L='b1;
		#5 D='b0; nP='b1;
		#5 C='b0; 
		#5 C='b1;
		#5 C='b0; 
		#5 C='b1;
		#5 $write("\nC = %d L=%d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,L,nP,nR,D,Q,Qbar) ;
end
endmodule 
