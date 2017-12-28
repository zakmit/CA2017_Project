module FORWARD_MUX
(
 data_i,
 select_i,
 exmem_i,
 memwb_i,
 
 data_o
);

input [31:0] data_i;
input [1:0]  select_i;
input [31:0] exmem_i;
input [31:0] memwb_i;
output[31:0] data_o;

reg [31:0] out;

assign data_o = out;

always@(*)begin
  case(select_i)
		2'b00: out = data_i;
		2'b10: out = exmem_i;
		2'b01: out = memwb_i;
        default: out = data_i;
	endcase
end

endmodule
