module CPU
  (
   clk_i, 
   rst_i,
   start_i
   );
   
// Ports
input               clk_i;
input               rst_i;
input               start_i;
   
wire [31:0] 	    inst_addr, inst;
      
//register
wire [4:0]          writeREG;
wire [31:0] 	    registerdata;
wire [31:0] 	    registerout1;
wire [31:0] 	    registerout2;
   
//Control output 
wire 	    CONTROL_REGDST_O;
wire [2:0]  CONTROL_ALUOP_O; // 3-bit
wire 	    CONTROL_ALUSRC_O;
wire 	    CONTROL_REGWRITE_O;
   
//mux_RegDst
wire [4:0]	    MUX_REGDST_DATA_O;

//ALU COUNT
wire [31:0]         ALU_DATA_O;
wire        ALU_ZERO_O;
   
//Sign_Extend 16->32
wire [31:0]     SIGN_EXTEND_DATA_O;

//MUX_ALUsrc
wire [31:0] 	MUX_ALUSRC_DATA_O;

//ALU_Control
wire [2:0] 	ALU_CONTROL_ALUCTRL_O; //3-bit

// HOMEWORK4
wire [31:0] 	ADD_PC_DATA_O;


Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (CONTROL_REGDST_O),
    .ALUOp_o    (CONTROL_ALUOP_O),
    .ALUSrc_o   (CONTROL_ALUSRC_O),
    .RegWrite_o (CONTROL_REGWRITE_O)
);
   
Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (ADD_PC_DATA_O)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (ADD_PC_DATA_O),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_REGDST_DATA_O), 
    .RDdata_i   (ALU_DATA_O),
    .RegWrite_i (CONTROL_REGWRITE_O), //MUX_RegDst choice
    .RSdata_o   (registerout1), 
    .RTdata_o   (registerout2) 
);

MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (CONTROL_REGDST_O),
    .data_o     (MUX_REGDST_DATA_O)
);

      
MUX32 MUX_ALUSrc(
    .data1_i    (registerout2),
    .data2_i    (SIGN_EXTEND_DATA_O),
    .select_i   (CONTROL_ALUSRC_O),
    .data_o     (MUX_ALUSRC_DATA_O)
);
      
Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (SIGN_EXTEND_DATA_O)
);
  

ALU ALU(
    .data1_i    (registerout1),
    .data2_i    (MUX_ALUSRC_DATA_O),
    .ALUCtrl_i  (ALU_CONTROL_ALUCTRL_O),
    .data_o     (ALU_DATA_O),
    .Zero_o     (ALU_ZERO_O)
);   
   
ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (CONTROL_ALUOP_O),
    .ALUCtrl_o  (ALU_CONTROL_ALUCTRL_O)
);

endmodule


