module EXMEM
(
  clk_i,
	wb_i,
	m_i,
	alu_i,
	mux7_i,
	mux3_i,
	stall_i,
	wb_o,
	m_o,
	alu_o,
	mux7_o,
	mux3_o

);

input  clk_i;
input [1:0]  wb_i;
input [1:0]  m_i;
input [31:0] alu_i;
input [31:0] mux7_i;
input [4:0]  mux3_i;

output [1:0]  wb_o;
output [1:0]  m_o;
output [31:0] alu_o;
output [31:0] mux7_o;
output [4:0]  mux3_o;

reg [1:0]  wb_o;
reg [1:0]  m_o;
reg [31:0] alu_o;
reg [31:0] mux7_o;
reg [4:0]  mux3_o;

initial begin #15
  wb_o = 0;
	m_o  = 0;
	alu_o = 0;
	mux7_o = 0;
	mux3_o = 0;
end

always@(posedge clk_i) begin
	if(!stall_i)
	begin
		wb_o <= wb_i;
		m_o  <= m_i;
		alu_o <= alu_i;
		mux7_o <= mux7_i;
		mux3_o <= mux3_i;
	end
end

endmodule
