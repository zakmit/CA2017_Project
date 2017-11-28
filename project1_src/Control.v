module Control
(
    Op_i,       
    RegDst_o,   
    ALUOp_o,   
    ALUSrc_o,   
    RegWrite_o 
);

// Ports
   input [5:0]   Op_i;
   
   output        RegDst_o;
   output        ALUSrc_o;
   output        RegWrite_o;
   output [2:0]  ALUOp_o;

   reg [5:0] 	 out;
   
   assign RegDst_o = out[5];
   assign ALUSrc_o = out[4];
   assign RegWrite_o = out[3];
   assign ALUOp_o = out[2:0];
   
   
   always @(*)begin
      case(Op_i)
	6'b000000: // r-type
	  out = 6'b101100;
	6'b001000: //addi
	  out = 6'b011010;		   
      endcase
   end

   
endmodule 
