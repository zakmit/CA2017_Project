// Control		Control
// MUX32			MUX1,2,5
// MUX3				MUX3
// MAX8				mux8
// FORWARD_MUX MUX6,7
// Shift_left_2  Shift_left_2
// Shift_left_0_27__28_31 Shift_left_0_27__28_31   // link IF_ID and MUX1.o
// EQ					EQ <<---- maybe wrong
// IFID
// IDEX

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
wire [31:0] 	    registerout1;
wire [31:0] 	    registerout2;

//Control output
wire    CONTROL_BRANCH_O;
wire    CONTROL_JUMP_O;
wire    CONTROL_MUX8_O;

//mux_RegDst
wire [4:0]	    MUX_REGDST_DATA_O;

//ALU COUNT
wire [31:0]         ALU_DATA_O;
wire        ALU_ZERO_O;

//Sign_Extend 16->32
wire [31:0]   SIGN_EXTEND_DATA_O;

//MUX_ALUsrc
wire [31:0] 	MUX_ALUSRC_DATA_O;

//ALU_Control
wire [2:0] 	ALU_CONTROL_ALUCTRL_O; //3-bit

// HOMEWORK4
wire [31:0] 	ADD_PC_DATA_O;

// MUX32 mux1,mux2,mux5,mux8
wire [31:0]   MUX32_MUX1_O;
wire [31:0]   MUX32_MUX2_O;
wire [31:0]   MUX32_MUX5_O;

// MUX8 mux8
wire [7:0]   MUX8_MUX8_O;

// Adder ADD
wire [31:0]   ADDER_ADD_O;

//Shift_left_2 Shift_left_0_27__28_31
wire [31:0]   SHIFT_LEFT_2_O;
wire [31:0]   SHIFT_LEFT_0_27__28_31_O;

//EQ
wire [31:0]   EQ_DATA_O;

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
wire					MEM_WB_REGWRITE;

//IDEX
wire				IDEX_WB_O;
wire				IDEX_M_O;
wire [3:0]	IDEX_EX_O;
wire [31:0] IDEX_DATA1_O;
wire [31:0] IDEX_DATA2_O;
wire [31:0] IDEX_SIGNEXTEND_O;
wire [4:0] 	IDEX_RS_O;
wire [4:0]	IDEX_RT_O;
wire [4:0]	IDEX_RD_O;


IFID IFID(
			.clk_i					(clk_i),
			.add_pc_i				(ADD_PC_DATA_O),
			.instruction_i	(inst), //from instruction.o
			.flush_i				(CONTROL_JUMP_O | (CONTROL_BRANCH_O & EQ_DATA_O)),
			.hazard_i 			(HD_IFID_O),
			.pc_o						(IF_ID_PC),
			.inst_o					(IF_ID_INST)
);// DONE




IDEX IDEX(
			.clk_i				(clk_i),
			.wb_i					(MUX8_MUX8_O[7:6]),
			.m_i					(MUX8_MUX8_O[5:4]),
			.ex_i					(MUX8_MUX8_O[3:0]),
			.add_pc_i			(IF_ID_PC), // no use anymore
			.data1_i			(registerout1),
			.data2_i			(registerout2),
			.signextend_i	(SIGN_EXTEND_DATA_O),
			.rs_i					(IF_ID_INST[25:21]),
			.rt_i					(IF_ID_INST[20:16]),
			.rd_i					(IF_ID_INST[15:11]),

			.wb_o					(IDEX_WB_O), // go to ex/mem wb
			.m_o					(IDEX_M_O), // go to ex/mem m
			.ex_o					(IDEX_EX_O), // go to mux4 , Alu control , mux3
			.data1_o			(IDEX_DATA1_O), // go to forward_mux6
			.data2_o			(IDEX_DATA2_O), // go to forward_mux7
			.signextend_o (IDEX_SIGNEXTEND_O), // go to mux4
			.rs_o					(IDEX_RS_O), // go to forwarding
			.rt_o					(IDEX_RT_O), // go to forwarding , mux3 , hazard
			.rd_o					(IDEX_RD_O), // go to mux3


);

HD HD(
		.IFID_rs_i	(IF_ID_INST[25:21]),
		.IFID_rt_i	(IF_ID_INST[20:16]),
		.IFID_o			(HD_IFID_O),	
		.mux8_o 		(HD_MUX8_O),
		.pc_o				(HD_PC_O)
);

Control Control(      //new control
      .Op_i       (IF_ID_INST[31:26]),
      .branch_o   (CONTROL_BRANCH_O)
      .jump_o     (CONTROL_JUMP_O)
			.mux8_o			(CONTROL_MUX8_O)
); //DONE

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (ADD_PC_DATA_O)
); //DONE

Adder ADD(
    .data1_in   (SHIFT_LEFT_2_O),
    .data2_in   (IF_ID_PC),
    .data_o     (ADDER_ADD_O)
); //DONE

MUX32 MUX1(
    .data1_i    (ADD_PC_DATA_O),
    .data2_i    (ADDER_ADD_O),
    .select_i   (CONTROL_BRANCH_O & EQ_DATA_O),
    .data_o     (MUX32_MUX1_O)
); //DONE

MUX32 MUX2(
    .data1_i    (MUX32_MUX1_O),
    .data2_i    ({MUX32_MUX1_O[31:28], SHIFT_LEFT_0_27__28_31_O[27:0]}),
    .select_i   (CONTROL_JUMP_O),
    .data_o     (MUX32_MUX2_O)
); //DONE

MUX5	MUX3(
    .data1_i    (),
    .data2_i    (),
    .select_i   (), // ID/EX control
    .data_o     ()
);

MUX32 MUX4(
    .data1_i  (MEM_WB_ALU_O),
    .data2_i  (MEM_WB_READDATA_O),
    .select_i (MEM_WB_MEMTOREG),
    .data_o   (MUX32_MUX5_O)
);

MUX32 MUX5(
    .data1_i  (MEM_WB_ALU_O),
    .data2_i  (MEM_WB_READDATA_O),
    .select_i (MEM_WB_MEMTOREG),
    .data_o   (MUX32_MUX5_O)
); // DONE

FORWARD_MUX MUX6(
		.data_i						(),
		.select_i 				(), // from forward unit
		.forward_exmem_i	(),
		.forward_memwb_i	(),
		.data_o						()
);

FORWARD_MUX MUX7(
		.data_i						(),
		.select_i 				(), // from forward unit
		.forward_exmem_i	(),
		.forward_memwb_i	(),
		.data_o						()
);

MUX8 MUX8(
		.data1_i	(CONTROL_MUX8_O),
		.data2_i	(32'd0), // default
		.select_i	(HD_MUX8_O),
		.data_o		(MUX8_MUX8_O)
); // DONE

EQ EQ( // maybe wrong
    .data1_i    (registerout1),
    .data2_i    (registerout2),
    .data_o     (EQ_DATA_O)
); //DONE 

Shift_left_2  Shift_left_2(
    .data_in    (SIGN_EXTEND_DATA_O),
    .data_o     (SHIFT_LEFT_2_O)
); //DONE
Sign_Extend Sign_Extend(
    .data_i     (IF_ID_INST[15:0]),
    .data_o     (SIGN_EXTEND_DATA_O)
); //DONE

Shift_left_0_27__28_31 Shift_left_0_27__28_31(
    .data_in    (IF_ID_INST[25:0]), // 0-25 << come from IF_ID's INST
    .data_o     (SHIFT_LEFT_0_27__28_31_O[27:0]) //28bit
); //DONE

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
		.hazard_i		(HD_PC_O),
		
    .pc_i       (MUX32_MUX2_O),
    .pc_o       (inst_addr)
); 

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr),
    .instr_o    (inst)
); //DONE

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (IF_ID_INST[25:21]),
    .RTaddr_i   (IF_ID_INST[20:16]),
    .RDaddr_i   (MEM_WB_RD), // 5bit [4:0]
    .RDdata_i   (MUX32_MUX5_O),
    .RegWrite_i (MEM_WB_REGWRITE),
    .RSdata_o   (registerout1), // registerout1 and 2 maybe wrong
    .RTdata_o   (registerout2)
); //DONE

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
