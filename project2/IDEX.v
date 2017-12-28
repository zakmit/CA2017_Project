module IDEX
(
  clk_i, 
  wb_i,       
  m_i,        
  ex_i,        
  add_pc_i,    
  data1_i,     
  data2_i,     
  signextend_i,
  rs_i,        
  rt_i,        
  rd_i,        
  stall_i,
  
  wb_o,        
  m_o,        
  ex_o,        
  data1_o,     
  data2_o,     
  signextend_o,
  rs_o,        
  rt_o,        
  rd_o         
);

input clk_i;
input [1:0] wb_i;
input [1:0] m_i;
input [3:0] ex_i;
input [31:0] add_pc_i;
input [31:0] data1_i;
input [31:0] data2_i;
input [31:0] signextend_i;
input [4:0]  rs_i;
input [4:0]  rt_i;
input [4:0]  rd_i;

output [1:0] wb_o;
output [1:0] m_o;
output [3:0] ex_o;
output [31:0] data1_o;
output [31:0] data2_o;
output [31:0] signextend_o;
output [4:0]  rs_o;
output [4:0]  rt_o;
output [4:0]  rd_o;
input stall_i;
reg [1:0] wb_o;
reg [1:0] m_o;
reg [3:0] ex_o;
reg [31:0] data1_o;
reg [31:0] data2_o;
reg [31:0] signextend_o;
reg [4:0]  rs_o;
reg [4:0]  rt_o;
reg [4:0]  rd_o;

initial begin #10
  wb_o = 0;
	m_o = 0;
	ex_o = 0;
	data1_o = 0;
	data2_o = 0;
	signextend_o = 0;
	rs_o = 0;
	rt_o = 0;
	rd_o = 0;
end

always@(posedge clk_i) begin
	if(!stall_i)
	begin
	  wb_o <= wb_i;
		m_o <= m_i;
		ex_o <= ex_i;
		data1_o <= data1_i;
		data2_o <= data2_i;
		signextend_o <= signextend_i;
		rs_o <= rs_i;
		rt_o <= rt_i;
		rd_o <= rd_i;
	end
end

endmodule
