module Control
(
	Op_i,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o
);

input [5:0] Op_i;
output RegDst_o, ALUSrc_o, RegWrite_o;
output [1:0] ALUOp_o;
parameter R_TYPE = 6'b000000;
parameter ADDI = 6'b001000;

assign RegDst_o = (Op_i == R_TYPE);
assign ALUSrc_o = (Op_i == ADDI);
assign RegWrite_o = (Op_i == R_TYPE) | (Op_i == ADDI);
assign ALUOp_o = ((Op_i == ADDI) ? 2'b00 : (Op_i == R_TYPE) ? 2'b11 : 2'bxx);

endmodule