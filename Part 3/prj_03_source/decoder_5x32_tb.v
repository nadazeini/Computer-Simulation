module decoder_5x32_tb;
wire[31:0] D; 
reg[4:0] I;
DECODER_5x32 decoder(D,I);
initial begin
#5 I='b00000;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b00001;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b00010;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b00011;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b00100;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b00101;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b00110;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b00111;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01000;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01001;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01010;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01011;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01100;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01101;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01110;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b01111;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b10000;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b11111;
#5 $write("\nI=%b , D=%b\n",I,D);
#5 I='b100000;
#5 $write("\nI=%b , D=%b\n",I,D);

end

endmodule