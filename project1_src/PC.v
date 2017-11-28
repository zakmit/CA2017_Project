module PC
(
    clk_i,
    rst_i,
    start_i,
    pc_i,
    pc_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;


always@(posedge clk_i or negedge rst_i) begin
    $display("in PC.\n");
    if(~rst_i) begin
        $display("in rst_i.\n");
        pc_o <= 32'b0;
    end
    else begin
        if(start_i) begin
            $display("in start_i.\n");
            pc_o <= pc_i;
        end
        else
            pc_o <= pc_o;
    end
    $display("pc_i = %h, pc_o = %h.\n", pc_i, pc_o);
end

endmodule
