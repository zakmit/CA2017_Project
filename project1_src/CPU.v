// Control Control
// Adder ADD
// MUX32 mux1
// MUX32 mux2
// MUX32 MUX5
// Shift_left_2  Shift_left_2
// Shift_left_0_27__28_31 Shift_left_0_27__28_31   // link IF_ID and MUX1.o
// EQ EQ <<---- maybe wrong


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
wire    CONTROL_BRANCH_O;
wire    CONTROL_JUMP_O;

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

// MUX32 mux1,mux2,mux5
wire [31:0]   MUX32_MUX1_O;
wire [31:0]   MUX32_MUX2_O;
wire [31:0]   MUX32_MUX5_O;

// Adder ADD
wire [31:0]   ADDER_ADD_O;

//Shift_left_2 Shift_left_0_27__28_31
wire [31:0]   SHIFT_LEFT_2_O;
wire [31:0]   SHIFT_LEFT_0_27__28_31_O;

//EQ
wire [31:0]   EQ_DATA_O;

//IF_ID
reg [31:0]    IF_ID_PC;
reg [31:0]    IF_ID_INST;

//MEM_WB MEM_WB_READDATA,MEM_WB_ALU_O,MEM_WB_MEMTOREG
reg [31:0]    MEM_WB_ALU_O;
reg [31:0]    MEM_WB_READDATA_O;
reg           MEM_WB_MEMTOREG;

Control Control(      //new control
      .Op_i       (inst[31:26]),
      .branch_o   (CONTROL_BRANCH_O)
      .jump_o     (CONTROL_JUMP_O)
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (ADD_PC_DATA_O)
);

Adder ADD(
    .data1_in   (SHIFT_LEFT_2_O),
    .data2_in   (IF_ID_PC),
    .data_o     (ADDER_ADD_O)
);

MUX32 mux1(
    .data1_i    (ADDER_ADD_O),
    .data2_i    (ADD_PC_DATA_O),
    .select_i   (CONTROL_BRANCH_O & EQ_DATA_O),
    .data_o     (MUX32_MUX1_O)
);

EQ EQ( // maybe wrong
    .data1_i    (registerout1),
    .data2_i    (registerout2),
    .data_o     (EQ_DATA_O)
);

MUX32 mux2(
    .data1_i    (MUX32_MUX1_O),
    .data2_i    ({MUX32_MUX1_O[31:28], SHIFT_LEFT_0_27__28_31_O[27:0]}),
    .select_i   (CONTROL_JUMP_O),
    .data_o     (MUX32_MUX2_O)
);

Shift_left_2  Shift_left_2(
    .data_in    (SIGN_EXTEND_DATA_O),
    .data_o     (SHIFT_LEFT_2_O)
);

Sign_Extend Sign_Extend(
    .data_i     (IF_ID_INST[15:0]),
    .data_o     (SIGN_EXTEND_DATA_O)
);

Shift_left_0_27__28_31 Shift_left_0_27__28_31(
    .data_in    (IF_ID_INST[25:0]), // 0-25 << come from IF_ID's INST
    .data_o     (SHIFT_LEFT_0_27__28_31_O)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (MUX32_MUX2_O),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr),
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (IF_ID_INST[25:21]),
    .RTaddr_i   (IF_ID_INST[20:16]),
    .RDaddr_i   (MUX_REGDST_DATA_O), // haven't done , from PIPELINE's MEM_WB
    .RDdata_i   (MUX32_MUX5_O),
    .RegWrite_i (CONTROL_REGWRITE_O), // haven't done , from PIPELINE's MEM_WB
    .RSdata_o   (registerout1), // registerout1 and 2 maybe wrong
    .RTdata_o   (registerout2)
);

MUX32 MUX8(

);

MUX32 MUX5(
    .data1_i  (MEM_WB_READDATA_O),
    .data2_i  (MEM_WB_ALU_O),
    .select_i (MEM_WB_MEMTOREG),
    .data_o   (MUX32_MUX5_O)
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
