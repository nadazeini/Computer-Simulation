`timescale 1ns/1ps
module d_latch_tb;
	reg D,C,nP,nR,R;
	wire Q,Qbar;
	D_LATCH dl(Q, Qbar, D, C, nP, nR);
	initial begin

#5 D=1'b0; nP='b1; nR=0; //reset
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n RESET C = %d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,nP,nR,D,Q,Qbar) ;
#5 D=1'b1; nP='b1; nR=0; //reset
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n RESET C = %d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,nP,nR,D,Q,Qbar) ;
#5 D=1'b1; nP='b0; nR=1; //preset
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n PRESET C = %d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,nP,nR,D,Q,Qbar) ;
#5 D=1'b0; nP='b0; nR=1; //preset
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n PRESET C = %d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,nP,nR,D,Q,Qbar) ;

#5 D=1'b0; nP='b1; nR=1; //normal
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n Normal C = %d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,nP,nR,D,Q,Qbar) ;
#5 D=1'b1; nP='b1; nR=1; //normal
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n Normal C = %d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,nP,nR,D,Q,Qbar) ;
#5 D=1'b1; nP='b0; nR=0; //normal
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n Undefined C = %d nP=%d nR=%d D=%d Q=%d Qbar=%d\n",C,nP,nR,D,Q,Qbar) ;

end
endmodule
