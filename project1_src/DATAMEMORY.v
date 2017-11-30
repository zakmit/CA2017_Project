module DATAMEMORY
(
  exmem_alu_i,
	exmem_mux7_i,
	exmem_m_MW_i,
	exmem_m_MR_i,

	read_data_o
);

input [31:0] exmem_alu_i;
input [31:0] exmem_mux7_i;
input exmem_m_MW_i;//write
input exmem_m_MR_i;//read //??

output [31:0] read_data_o;

reg [7:0] out [0:31];
assign read_data_o[31:24] = out[exmem_alu_i+3];
assign read_data_o[23:16] = out[exmem_alu_i+2];
assign read_data_o[15:8] = out[exmem_alu_i+1];
assign read_data_o[7:0] = out[exmem_alu_i];

always@(*)begin
   if( exmem_m_MW_i )
     begin
		     out[exmem_alu_i+3] = exmem_mux7_i[31:24];
         out[exmem_alu_i+2] = exmem_mux7_i[23:16];
			   out[exmem_alu_i+1] = exmem_mux7_i[15:8];
				 out[exmem_alu_i] = exmem_mux7_i[7:0];
		 end
   end
endmodule
