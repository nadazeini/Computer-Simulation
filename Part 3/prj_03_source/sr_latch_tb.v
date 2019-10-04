`timescale 1ns/1ps
module sr_latch_tb;
	reg S,C,nP,nR,R;
	wire Q,Qbar;
	SR_LATCH sr(Qbar,Q,S,R,C,nP,nR);
	initial begin

#5 S='b0; R='b1; nP='b1; nR=0; 
#5 C=1'b0;
#5 C=1'b1;

#5 $write("\n RESET C = %d np=%d nR=%d S=%d R=%d Q=%d Qbar=%d\n",C,nP,nR,S,R,Q,Qbar) ;

#5 S='b1; R='b0; nP='b0; nR=1; //prereset
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n PRESET C = %d np=%d nR=%d S=%d R=%d Q=%d Qbar=%d\n",C,nP,nR,S,R,Q,Qbar) ;

#5 S='b1; R='b0; nP='b1; nR=1; //normal
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n NORMAL C = %d np=%d nR=%d S=%d R=%d Q=%d Qbar=%d\n",C,nP,nR,S,R,Q,Qbar) ;
#5  S='b0; R='b1; nP='b1; nR=1; //normal
#5 C=1'b0;
#5 C=1'b1;
#5 $write("\n NORMAL C = %d np=%d nR=%d S=%d R=%d Q=%d Qbar=%d\n",C,nP,nR,S,R,Q,Qbar) ;



end

endmodule
