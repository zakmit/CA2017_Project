module FORWARDUNIT
(
  idex_rs_i, 
	idex_rt_i,   
	exmem_mux3_i,
	exmem_wb_i,  
	memwb_mux3_i,
	memwb_wb_i,  

	to_mux6_o,   
	to_mux7_o   

);

input [4:0] idex_rs_i;
input [4:0] idex_rt_i;
input [4:0] exmem_mux3_i;
input exmem_wb_i;
input [4:0] memwb_mux3_i;
input memwb_wb_i;

output [1:0] to_mux6_o;
output [1:0] to_mux7_o;

reg [1:0] to_mux6_o;
reg [1:0] to_mux7_o;

always@(*)begin
    to_mux6_o=2'b00;
    to_mux7_o=2'b00;
   if( ((exmem_wb_i) && (exmem_mux3_i != 0)) && (exmem_mux3_i == idex_rs_i) )
      begin
		    to_mux6_o = 2'b10;
		  end
    if( ((exmem_wb_i) && (exmem_mux3_i != 0)) && (exmem_mux3_i == idex_rt_i) )
      begin
		    to_mux7_o = 2'b10;
    end
    if( ((memwb_wb_i) && (memwb_mux3_i != 0)) && (memwb_mux3_i == idex_rs_i )  )
	  	begin
        to_mux6_o = 2'b01;
	  	end
    if( ((memwb_wb_i) && (memwb_mux3_i != 0)) && (memwb_mux3_i == idex_rt_i ) )
      begin
	      to_mux7_o = 2'b01;
	    end
end

endmodule
