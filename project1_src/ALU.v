module ALU
(
	data1_i,
	data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [2:0]   ALUCtrl_i;
output  [31:0]  data_o;
output          Zero_o;

assign data_o = (
  (ALUCtrl_i == 3'b010) ? data1_i + data2_i : //add
  (ALUCtrl_i == 3'b110) ? data1_i - data2_i : //subtract
  (ALUCtrl_i == 3'b001) ? data1_i | data2_i : //or
  (ALUCtrl_i == 3'b000) ? data1_i & data2_i : //and
  (ALUCtrl_i == 3'b111) ? data1_i * data2_i : //mul
  32'd0
);
assign Zero_o = (data_o == 0) ? 1 : 0;

endmodule