module Control
(
   Op_i,
	 branch_o,
	 jump_o,
	 mux8_o
);

// Ports
   input [5:0]   Op_i;
   output        jump_o;
	 output        branch_o;
	 output[7:0]   mux8_o;

	 reg [9:0]     out;
	 assign jump_o = out[9];
	 assign branch_o = out[8];
	 assign mux8_o = out[7:0];
	 //[7]      [6]      [5]     [4]     
	 //RegWrite MemtoReg MemRead MemWrite
   //[3]    [2]   [1]   [0]
	 //ALUSrc ALUOp[1:0]  RegDst
	 always @(*) begin
       case(Op_i)
		     6'b000000: out = 10'b0010000111; // r-type
				 6'b000100: out = 10'b0100000011; // beq
				 6'b001000: out = 10'b0010001000; // addi
				 6'b100011: out = 10'b0011101000; // lw
				 6'b101011: out = 10'b0000011000; // sw
				 default:   out = 10'b1000000000; // jump
			 endcase
	 end
	 /* 
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
  */
   
endmodule 
