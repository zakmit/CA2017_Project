module CPU
(
   clk_i,
   rst_i,
   start_i,
   mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;     

//register
wire [31:0] 	    registerout1;
wire [31:0] 	    registerout2;

//Control output
wire         CONTROL_BRANCH_O;
wire         CONTROL_JUMP_O;
wire [7:0]   CONTROL_MUX8_O;

//mux_RegDst
wire [4:0]	    MUX_REGDST_DATA_O;

//ALU COUNT
wire [31:0]	ALU_DATA_O;
wire				ALU_ZERO_O;

//Sign_Extend 16->32
wire [31:0]   SIGN_EXTEND_DATA_O;

//MUX_ALUsrc
wire [31:0] 	MUX_ALUSRC_DATA_O;

//ALU_Control
wire [2:0] 	ALU_CONTROL_ALUCTRL_O; //3-bit

// HOMEWORK4
wire [31:0] 	ADD_PC_DATA_O;

// MUX32 mux1,mux2,mux4,mux5
wire [31:0]   MUX32_MUX1_O;
wire [31:0]   MUX32_MUX2_O;
wire [31:0]   MUX32_MUX4_O;
wire [31:0]   MUX32_MUX5_O;

// MUX8 mux8
wire [7:0]   MUX8_MUX8_O;

// MUX_FORWARD MUX6,MUX7
wire [31:0]  MUX6_DATA_O;
wire [31:0]  MUX7_DATA_O;

//FORWARD_UNIT
wire [1:0] FORWARDUNIT_MUX6_O;
wire [1:0] FORWARDUNIT_MUX7_O;

// MUX3
wire [4:0]   MUX3_DATA_O;

// Adder ADD
wire [31:0]   ADDER_ADD_O;

//Shift_left_2 Shift_left_0_27__28_31
wire [31:0]   SHIFT_LEFT_2_O;
wire [31:0]   SHIFT_LEFT_0_27__28_31_O;

//EQ
wire  EQ_DATA_O;

//HD
wire 	HD_MUX8_O;  // 0 = off , 1 = on
wire	HD_PC_O;
wire	HD_IFID_O;  // 0 = no hazard , 1 = hazard

//IF_ID
wire [31:0]  IF_ID_PC;
wire [31:0]  IF_ID_INST;

//MEM_WB
wire [31:0]   MEM_WB_ALU_O;
wire [31:0]   MEM_WB_READDATA_O;
wire [4:0]    MEM_WB_RD;
wire          MEM_WB_MEMTOREG;
wire          MEM_WB_REGWRITE;

//IDEX
wire [1:0]    IDEX_WB_O;
wire [1:0]    IDEX_M_O;
wire [3:0]    IDEX_EX_O;
wire [31:0]   IDEX_DATA1_O;
wire [31:0]   IDEX_DATA2_O;
wire [31:0]   IDEX_SIGNEXTEND_O;
wire [4:0]    IDEX_RS_O;
wire [4:0]    IDEX_RT_O;
wire [4:0]    IDEX_RD_O;

//EXMEM
wire [1:0]   EXMEM_WB_O;
wire [1:0]   EXMEM_M_O;
wire [31:0]  EXMEM_ALU_O;
wire [31:0]  EXMEM_MUX7_O;
wire [4:0]   EXMEM_MUX3_O;

//MEMWB
wire [1:0] MEMWB_WB_O;
wire [31:0] MEMWB_READ_DATA_O;
wire [31:0] MEMWB_ALU_O;
wire [4:0] MEMWB_MUX3_O;

//DATA_MEMORY
wire [31:0] DATAMEMORY_READ_DATA_O;
wire [31:0] inst_addr;
wire [31:0] inst;
wire mem_stall;
input	[256-1:0]	mem_data_i; 
input				mem_ack_i; 	
output	[256-1:0]	mem_data_o; 
output	[32-1:0]	mem_addr_o; 	
output				mem_enable_o; 
output				mem_write_o; 

IFID IFID(
  .clk_i          (clk_i),
  .add_pc_i       (ADD_PC_DATA_O),
  .instruction_i  (inst), //from instruction.o
  .flush_i        ((CONTROL_JUMP_O || (CONTROL_BRANCH_O && EQ_DATA_O))),
  .stall_i		  (mem_stall),
  .hazard_i       (HD_IFID_O),
  .pc_o           (IF_ID_PC),
  .inst_o         (IF_ID_INST)
);// ALL COMPLETE

IDEX IDEX(
  .clk_i         (clk_i),
  .wb_i          (MUX8_MUX8_O[7:6]),
  .m_i           (MUX8_MUX8_O[5:4]),
  .ex_i          (MUX8_MUX8_O[3:0]),
  .add_pc_i      (IF_ID_PC), // no use anymore
  .data1_i       (registerout1),
  .data2_i       (registerout2),
  .signextend_i  (SIGN_EXTEND_DATA_O),
  .rs_i          (IF_ID_INST[25:21]),
  .rt_i          (IF_ID_INST[20:16]),
  .rd_i          (IF_ID_INST[15:11]),
  .stall_i		 (mem_stall),
  .wb_o          (IDEX_WB_O), // go to ex/mem wb
  .m_o           (IDEX_M_O), // go to ex/mem M and hazard
  .ex_o          (IDEX_EX_O), // go to mux4 , Alu control , mux3
  .data1_o       (IDEX_DATA1_O), // go to forward_mux6
  .data2_o       (IDEX_DATA2_O), // go to forward_mux7
  .signextend_o  (IDEX_SIGNEXTEND_O), // go to mux4
  .rs_o          (IDEX_RS_O), // go to forwarding
  .rt_o          (IDEX_RT_O), // go to forwarding , mux3 , hazard
  .rd_o          (IDEX_RD_O) // go to mux3
);// ALL COMPLETE

EXMEM EXMEM(
	.clk_i         (clk_i),
  .wb_i          (IDEX_WB_O),
	.m_i           (IDEX_M_O),
	.alu_i         (ALU_DATA_O),
	.mux7_i        (MUX7_DATA_O),
	.mux3_i        (MUX3_DATA_O),
    .stall_i	   (mem_stall),
	.wb_o          (EXMEM_WB_O), // go to MEMWB
	.m_o           (EXMEM_M_O), // go to Datamemory(memread,memwrite), forwarding unit
	.alu_o         (EXMEM_ALU_O),//go to MEMWB , 	mux6
	.mux7_o        (EXMEM_MUX7_O),//go to Datamemory
	.mux3_o        (EXMEM_MUX3_O)//go to forwarding , MEMWB

);//ALL COMPLETE

MEMWB MEMWB(
  .clk_i                  (clk_i),
  .exmem_wb_i             (EXMEM_WB_O),
	.data_memory_readdata_i (DATAMEMORY_READ_DATA_O),
	.exmem_alu_i            (EXMEM_ALU_O),
	.exmem_mux3_i           (EXMEM_MUX3_O),
    .stall_i				(mem_stall),
	.wb_o        (MEMWB_WB_O), //go to mux5, forwarding unit , register(RegWritte)
	.read_data_o (MEMWB_READ_DATA_O),//go to mux5
	.alu_o       (MEMWB_ALU_O),//go to mux5
	.mux3_o      (MEMWB_MUX3_O)//go o forwarding , Register

);//ALL COMPLETE



FORWARDUNIT FORWARDUNIT(
  .idex_rs_i   (IDEX_RS_O),
	.idex_rt_i   (IDEX_RT_O),
	.exmem_mux3_i (EXMEM_MUX3_O),
	.exmem_wb_i  (EXMEM_WB_O[1]),
	.memwb_mux3_i (MEMWB_MUX3_O),
	.memwb_wb_i  (MEMWB_WB_O[1]),

	.to_mux6_o   (FORWARDUNIT_MUX6_O),
	.to_mux7_o   (FORWARDUNIT_MUX7_O)

);//ALL COMEPLETE

HD HD(
  .ifid_inst_i(IF_ID_INST),
	.idex_rt_i  (IDEX_RT_O),
	.idex_m_i   (IDEX_M_O[1]),
  .ifid_o     (HD_IFID_O),
  .mux8_o     (HD_MUX8_O),
  .pc_o       (HD_PC_O)
);//ALL COMPLETE

Control Control(      //new control
  .Op_i      (IF_ID_INST[31:26]),
  .branch_o  (CONTROL_BRANCH_O),
  .jump_o    (CONTROL_JUMP_O),
  .mux8_o    (CONTROL_MUX8_O)
); //ALL COMPLETE

Adder Add_PC(
  .data1_in  (inst_addr),
  .data2_in  (32'd4),
  .data_o    (ADD_PC_DATA_O)
); //ALL COMPLETE

Adder ADD(
  .data1_in  (SHIFT_LEFT_2_O),
  .data2_in  (IF_ID_PC),
  .data_o    (ADDER_ADD_O)
); //ALL COMPLETE

MUX32 MUX1(
  .data1_i  (ADD_PC_DATA_O),
  .data2_i  (ADDER_ADD_O),
  .select_i ((CONTROL_BRANCH_O && EQ_DATA_O)),
  .data_o   (MUX32_MUX1_O)
); //ALL COMPLETE

MUX32 MUX2(
  .data1_i   (MUX32_MUX1_O),
  .data2_i   ({MUX32_MUX1_O[31:28], SHIFT_LEFT_0_27__28_31_O[27:0]}),
  .select_i  (CONTROL_JUMP_O),
  .data_o    (MUX32_MUX2_O)
); //ALL COMPLETE

MUX5	MUX3(
  .data1_i  (IDEX_RT_O),
  .data2_i  (IDEX_RD_O),
  .select_i (IDEX_EX_O[0]), // ID/EX control
  .data_o   (MUX3_DATA_O)
);//ALL COMPLETE

MUX32 MUX4(
  .data1_i  (MUX7_DATA_O),
  .data2_i  (IDEX_SIGNEXTEND_O),
  .select_i (IDEX_EX_O[3]),
  .data_o   (MUX32_MUX4_O)
);//ALL COMPLETE

MUX32 MUX5(
		//.data1_i  (MEMWB_READ_DATA_O),
		//.data2_i  (MEMWB_ALU_O),
  .data1_i  (MEMWB_ALU_O), // select_i == 0 , this
  .data2_i  (MEMWB_READ_DATA_O),// select_i == 1 , this
  .select_i (MEMWB_WB_O[0]),
  .data_o   (MUX32_MUX5_O)
); //ALL COMPLETE

FORWARD_MUX MUX6(
  .data_i           (IDEX_DATA1_O),
  .select_i         (FORWARDUNIT_MUX6_O), // from forward unit
  .exmem_i          (EXMEM_ALU_O),
  .memwb_i          (MUX32_MUX5_O),
  .data_o           (MUX6_DATA_O)
);//ALL COMPLETE

FORWARD_MUX MUX7(
  .data_i           (IDEX_DATA2_O),
  .select_i         (FORWARDUNIT_MUX7_O), // from forward unit
  .exmem_i          (EXMEM_ALU_O),
  .memwb_i          (MUX32_MUX5_O),
  .data_o           (MUX7_DATA_O)
);//ALL COMPLETE

MUX8 MUX8(
  .data1_i  (CONTROL_MUX8_O),
  .data2_i  (8'd0), // default
  .select_i (HD_MUX8_O),
  .data_o   (MUX8_MUX8_O)
); // ALL COMEPLETE

EQ EQ( // maybe wrong
  .data1_i  (registerout1),
  .data2_i  (registerout2),
  .data_o   (EQ_DATA_O)
); //ALL COMEPLETE

Shift_left_2  Shift_left_2(
  .data_i  (SIGN_EXTEND_DATA_O),
  .data_o   (SHIFT_LEFT_2_O)
); //ALL COMEPLETE
Sign_Extend Sign_Extend(
  .data_i   (IF_ID_INST[15:0]),
  .data_o   (SIGN_EXTEND_DATA_O)
); //ALL COMPLETE

Shift_left_0_27__28_31 Shift_left_0_27__28_31(
  .data_i  (IF_ID_INST[25:0]), // 0-25 << come from IF_ID's INST
  .data_o   (SHIFT_LEFT_0_27__28_31_O[27:0]) //28bit
); //ALL COMPLETE



PC PC
(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.start_i(start_i),
	.stall_i(mem_stall),
	.pcEnable_i(HD_PC_O),
	.pc_i(MUX32_MUX2_O),
	.pc_o(inst_addr)
);

Instruction_Memory Instruction_Memory(
  .addr_i   (inst_addr),
  .instr_o  (inst)
); //ALL COMPLETE

Registers Registers(
  .clk_i      (clk_i),
  .RSaddr_i   (IF_ID_INST[25:21]),
  .RTaddr_i   (IF_ID_INST[20:16]),
  .RDaddr_i   (MEMWB_MUX3_O), // 5bit [4:0]
  .RDdata_i   (MUX32_MUX5_O),
  .RegWrite_i (MEMWB_WB_O[1]),
  .RSdata_o   (registerout1), // registerout1 and 2 maybe wrong
  .RTdata_o   (registerout2)
); //ALL COMEPLETE

/*
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
*///didnt use

ALU ALU(
    .data1_i    (MUX6_DATA_O), //ok
    .data2_i    (MUX32_MUX4_O), //ok
    .ALUCtrl_i  (ALU_CONTROL_ALUCTRL_O),
    .data_o     (ALU_DATA_O),
    .Zero_o     (ALU_ZERO_O)
);//ALL COMPLETE

ALU_Control ALU_Control(
    .funct_i    (IDEX_SIGNEXTEND_O[5:0]),
    .ALUOp_i    (IDEX_EX_O[2:1]),
    .ALUCtrl_o  (ALU_CONTROL_ALUCTRL_O)
);//ALL COMPLETE


dcache_top dcache
(
    // System clock, reset and stall
	.clk_i(clk_i), 
	.rst_i(rst_i),
	
	// to Data Memory interface		
	.mem_data_i(mem_data_i), 
	.mem_ack_i(mem_ack_i), 	
	.mem_data_o(mem_data_o), 
	.mem_addr_o(mem_addr_o), 	
	.mem_enable_o(mem_enable_o), 
	.mem_write_o(mem_write_o), 
	
	// to CPU interface	
	.p1_data_i(EXMEM_MUX7_O), 
	.p1_addr_i(EXMEM_ALU_O), 	
	.p1_MemRead_i(EXMEM_M_O[1]), 
	.p1_MemWrite_i(EXMEM_M_O[0]), 
	.p1_data_o(DATAMEMORY_READ_DATA_O), 
	.p1_stall_o(mem_stall)
);


endmodule

	