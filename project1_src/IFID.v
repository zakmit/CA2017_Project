module IFID
(
  clk_i,
	add_pc_i,
	instruction_i,
	flush_i,
	hazard_i,
	pc_o,
	inst_o
);

input clk_i;
input flush_i;
input hazard_i;
input [31:0] add_pc_i;
input [31:0] instruction_i;

output [31:0] pc_o;
output [31:0] inst_o;

reg [31:0] pc_o;
reg [31:0] inst_o;

initial begin #5
   pc_o = 0;
	 inst_o = 0;
end

//always@(posedge clk_i) begin
//			  pc_o <= add_pc_i;
//				inst_o <= instruction_i;
//end
always@(posedge clk_i) begin
    pc_o <= add_pc_i;
    if( flush_i )
	    begin
		  	inst_o <= 0;
		  end
		else if( hazard_i )
		  begin 
				inst_o <= instruction_i;
			end
            else
            begin
                inst_o <= inst_o;
            end
end

endmodule
