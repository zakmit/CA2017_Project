module PC
(
    clk_i,
    rst_i,
    start_i,
    hazard_i,
		pc_i,

    pc_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input								hazard_i; // 0 -> hazard , 1 -> no
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;


always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_o <= 32'b0;
    end
    else begin
        if(start_i )
            pc_o <= (hazard_i)? pc_i:pc_i-4;
        else
            pc_o <= pc_o;
    end
end

endmodule
