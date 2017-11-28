module Sign_Extend
(
	data_i,
	data_o
);

input	[15:0]	data_i;
output	[31:0]	data_o;
reg		[31:0]	data_t;
reg		[6:0]	i;

always @ *
begin
data_t = 32'b0;
if(data_i[15] == 0) begin
	for(i = 0; i < 16; i = i + 1) begin
		data_t[i] = data_i[i];
	end
	end
else begin
	for(i = 31; i > 15; i = i - 1) begin
		data_t[i] = 1;
	end
	for(i = 15; i >= 0; i = i - 1) begin
		data_t[i] = data_i[i];
	end
	end
end

assign data_o = data_t;
endmodule