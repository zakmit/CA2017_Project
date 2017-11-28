module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input	[5:0]	funct_i;
input	[1:0]	ALUOp_i;
output	[2:0]	ALUCtrl_o;
wire	[2:0]	ALUCtrl_t;

assign ALUCtrl_t = (
	(funct_i == 6'b100000) ? 3'b010 : //add
	(funct_i == 6'b100010) ? 3'b110 : //subtract
	(funct_i == 6'b100100) ? 3'b000 : //and
	(funct_i == 6'b100101) ? 3'b001 : //or
	(funct_i == 6'b011000) ? 3'b111 : //mul
	3'bxxx
); 

assign ALUCtrl_o = (
	(ALUOp_i == 2'b00) ? 3'b010 :
	(ALUOp_i == 2'b11) ? ALUCtrl_t :
	3'bxxx
);

endmodule