module Shift_left_0_27__28_31
(
  data_i,
  data_o
);

input [25:0] data_i;
output [27:0] data_o;

assign data_o[27:2] = data_i;
assign data_o[1:0]  = 2'b00;

endmodule
