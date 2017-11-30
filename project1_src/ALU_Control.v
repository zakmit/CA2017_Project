module ALU_Control
(
 funct_i,
 ALUOp_i,
 ALUCtrl_o
 );
   
   // Ports
   input [5:0]  funct_i;
   input [1:0]  ALUOp_i;
   output [2:0] ALUCtrl_o;

   
   reg [2:0] 	ALUCtrl_o;
   
   
   always @(*)begin
      case(funct_i)
	6'b100000:ALUCtrl_o = 3'b010;//add
	6'b100010:ALUCtrl_o = 3'b110;//sub
	6'b100100:ALUCtrl_o = 3'b000;//and
	6'b100101:ALUCtrl_o = 3'b001;//or
	6'b011000:ALUCtrl_o = 3'b100;//mul
	default:ALUCtrl_o = 3'b010;	
      endcase // case (ALUCtrl_o)
   end
   
   
   
endmodule 
