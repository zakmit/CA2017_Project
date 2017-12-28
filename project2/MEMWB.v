module MEMWB
(
  clk_i,
	exmem_wb_i,
	data_memory_readdata_i,
	exmem_alu_i,
	exmem_mux3_i,
	stall_i,
	wb_o,
	read_data_o,
	alu_o,
	mux3_o
);

input clk_i;
input [1:0] exmem_wb_i;
input [31:0] data_memory_readdata_i;
input [31:0] exmem_alu_i;
input [4:0] exmem_mux3_i;
input stall_i;	
output [1:0] wb_o;
output [31:0] read_data_o;
output [31:0] alu_o;
output [4:0] mux3_o;

reg [1:0] wb_o;
reg [31:0] read_data_o;
reg [31:0] alu_o;
reg [4:0] mux3_o;

initial begin #20
  wb_o = 0;
	alu_o = 0;
	read_data_o = 0;
	mux3_o = 0;
end

always@(posedge clk_i) begin
 if(!stall_i)
 begin
  wb_o <= exmem_wb_i;
	read_data_o <= data_memory_readdata_i;
	alu_o <= exmem_alu_i;
	mux3_o <= exmem_mux3_i;
	end
end

endmodule

