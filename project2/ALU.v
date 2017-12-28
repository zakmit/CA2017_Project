module ALU
(
 data1_i,
 data2_i,
 ALUCtrl_i,
 data_o,
 Zero_o
 );
   
   // Ports
   input [31:0]    data1_i;
   input [31:0]    data2_i;
   input [2:0] 	   ALUCtrl_i;
   output [31:0]   data_o;
   output          Zero_o;
 
   reg [31:0]      data_o;
   reg             Zero_o;

/*
assign data_o = (ALUCtrl_i == 3'b010) ? (data1_i + data2_i) :
		((ALUCtrl_i == 3'b110) ? (data1_i - data2_i) :
		 ((ALUCtrl_i == 3'b000) ? (data1_i & data2_i ) :
		  ((ALUCtrl_i == 3'b001) ? (data1_i | data2_i) :
		   (data1_i * data2_i))));
*/ 
    always @(data1_i or data2_i or ALUCtrl_i) begin
       // ALUCtrl = 010 add,lw,sw
       if( ~ALUCtrl_i[2] & ALUCtrl_i[1] & ~ALUCtrl_i[0] )
    	begin
    	   data_o = data1_i + data2_i;
    	   if( data_o == 32'b0 )
    	     begin
    		Zero_o = 1'b1;
    	     end
    	   else
    	     begin
    		Zero_o = 1'b0;
    	     end	   
    	end
       // ALUCtrl = 110 sub,beq
       if( ALUCtrl_i[2] & ALUCtrl_i[1] & ~ALUCtrl_i[0] )
    	begin
    	   data_o = data1_i - data2_i;
    	   if( data_o == 32'b0 )
    	     begin
    		Zero_o = 1'b1;
    	     end
    	   else
    	     begin
    		Zero_o = 1'b0;
    	     end	   
    	end
       // ALUCtrl = 000 and

       if( ~ALUCtrl_i[2] & ~ALUCtrl_i[1] & ~ALUCtrl_i[0] )
    	begin
    	   data_o = data1_i & data2_i;
    	   if( data_o == 32'b0 )
    	     begin
    		Zero_o = 1'b1;
    	     end
    	   else
    	     begin
    		Zero_o = 1'b0;
    	     end	   
    	end

       // ALUCtrl = 001 or
       if( ~ALUCtrl_i[2] & ~ALUCtrl_i[1] & ALUCtrl_i[0] )
    	begin
    	   data_o = data1_i | data2_i;
    	   if( data_o == 32'b0 )
    	     begin
    		Zero_o = 1'b1;
    	     end
    	   else
    	     begin
    		Zero_o = 1'b0;
    	     end	   
    	end

       // ALUCtrl = 100 mul
    	  if( ALUCtrl_i[2] & ~ALUCtrl_i[1] & ~ALUCtrl_i[0] )
    	    begin
    	       data_o = data1_i * data2_i;
    	       if( data_o == 32'b0 )
    		 begin
    		    Zero_o = 1'b1;
    		 end
    	       else
    		 begin
    		    Zero_o = 1'b0;
    		 end	   
    	    end
    
    end
   
endmodule 
