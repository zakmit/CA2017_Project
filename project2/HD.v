module HD
(
   ifid_inst_i,
	 idex_rt_i,
	 idex_m_i,
	 ifid_o,
	 mux8_o,
	 pc_o
);

input [31:0] ifid_inst_i;
input [4:0]  idex_rt_i;
input        idex_m_i;
output       ifid_o;
output       mux8_o;
output       pc_o;

reg out[2:0];
assign ifid_o = out[2];
assign mux8_o = out[1];
assign pc_o   = out[0];


wire RS,RT,HD;

assign RS = ( idex_rt_i == ifid_inst_i[25:21] )? 1:0; // [25:21] is RS
assign RT = ( idex_rt_i == ifid_inst_i[20:16] )? 1:0;
assign HD = !(( RS|RT )&idex_m_i);

always@(*)begin
  out[2] <= HD;
  out[1] <= HD;
  out[0] <= HD;
end

endmodule
