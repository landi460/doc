LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;
USE work.alu_param.all;

ENTITY cu IS
  PORT (
  instruction            : IN  std_logic_vector(INST_WIDTH-1 DOWNTO 0);
  imm_type               : OUT std_logic_vector(2 DOWNTO 0);
  D_MEM_write            : OUT std_logic;
  D_MEM_read             : OUT std_logic;
  RF_write               : OUT std_logic;
  branch                 : OUT std_logic;
  jump                   : OUT std_logic;
  RS1_PC_ALU_SRC_MUX_sel : OUT std_logic;
  RS2_IMM_ALU_SRC_MUX_sel: OUT std_logic;
  DMEM_ALU_WB_MUX_sel    : OUT std_logic
  );
END ENTITY;

ARCHITECTURE behavioral OF cu IS
BEGIN
  PROCESS(instruction)
    BEGIN
	
    imm_type <= NOP_TYPE;
    D_MEM_write <= '0';
    D_MEM_read <= '0';
    RF_write <= '0';
    RS1_PC_ALU_SRC_MUX_sel <= '0';
    RS2_IMM_ALU_SRC_MUX_sel <= '0';
    DMEM_ALU_WB_MUX_sel <= '0';
    branch <= '0';
    jump <= '0';
    
     IF (instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_LUI) THEN
      imm_type <= U_TYPE;
      DMEM_ALU_WB_MUX_sel <= '0'; --ALU
      RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '1'; -- immediate
     
     ELSIF (instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_AUIPC) THEN
      imm_type <= U_TYPE;
      RF_write <= '1';
      RS1_PC_ALU_SRC_MUX_sel <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '1'; 

     ELSIF (instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START ) = RV32_JAL) THEN
      imm_type <= UJ_TYPE;
      RF_write <= '1';
      jump <= '1';
     
     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START ) = RV32_BRANCH) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START ) = RV32I_BEQ_FUNCT3)) THEN 
      imm_type <=  SB_TYPE;
      branch <= '1';
    
     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START ) = RV32_LOAD ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START ) = RV32I_LW_FUNCT3 )) THEN 
      imm_type <= I_TYPE;
      RS2_IMM_ALU_SRC_MUX_sel <= '1'; -- immediate
      DMEM_ALU_WB_MUX_sel <= '1'; -- DMEM
      D_MEM_read <= '1';
      RF_write <= '1';
 
     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_STORE ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START ) = RV32I_SW_FUNCT3 )) THEN
      imm_type <= S_TYPE;
      RS2_IMM_ALU_SRC_MUX_sel <= '1'; -- immediate
      D_MEM_write <= '1';
     
     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_OP_IMM ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START) = RV32I_ADD_FUNCT3 )) THEN
      imm_type <= I_TYPE;
	  RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '1'; -- immediate
      DMEM_ALU_WB_MUX_sel <= '0';

     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_OP_IMM ) AND (instruction( (RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START) = RV32I_AND_FUNCT3 )) THEN
      imm_type <= I_TYPE;
      RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '1'; -- immediate
      DMEM_ALU_WB_MUX_sel <= '0' ; -- ALU

     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_OP_IMM ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START) = RV32I_SRA_FUNCT3 AND (instruction((RV32I_FUNCT7_START+RV32I_FUNCT7_WIDTH-1) DOWNTO RV32I_FUNCT7_START) = RV32I_SRA_FUNCT7 ))) THEN
      imm_type <= I_TYPE;
      RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '1'; 
      DMEM_ALU_WB_MUX_sel <= '0' ; 
     
     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START ) = RV32_OP ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START ) = RV32I_ADD_FUNCT3 AND (instruction((RV32I_FUNCT7_START+RV32I_FUNCT7_WIDTH-1) DOWNTO RV32I_FUNCT7_START) = RV32I_ADD_FUNCT7 ))) THEN
      imm_type <= R_TYPE;
      RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '0'; 
      DMEM_ALU_WB_MUX_sel <= '0' ; -- ALU
	  
	 ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START ) = RV32_OP ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START ) = RV32I_ADD_FUNCT3 AND (instruction((RV32I_FUNCT7_START+RV32I_FUNCT7_WIDTH-1) DOWNTO RV32I_FUNCT7_START) = RV32I_AB_FUNCT7 ))) THEN
      imm_type <= R_TYPE;
      RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '0'; 
      DMEM_ALU_WB_MUX_sel <= '0' ; -- ALU

     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_OP ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START ) = RV32I_SLT_FUNCT3 AND (instruction((RV32I_FUNCT7_START+RV32I_FUNCT7_WIDTH-1) DOWNTO RV32I_FUNCT7_START) = RV32I_SLT_FUNCT7 ))) THEN
      imm_type <= R_TYPE;
      RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '0' ; -- Rs2
      DMEM_ALU_WB_MUX_sel <= '0' ; -- ALU

     ELSIF ((instruction((RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1) DOWNTO RV32I_OPCODE_START) = RV32_OP ) AND (instruction((RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1) DOWNTO RV32I_FUNCT3_START) = RV32I_XOR_FUNCT3 AND (instruction((RV32I_FUNCT7_START+RV32I_FUNCT7_WIDTH-1) DOWNTO RV32I_FUNCT7_START) = RV32I_XOR_FUNCT7 ))) THEN
      imm_type <= R_TYPE;
      RF_write <= '1';
      RS2_IMM_ALU_SRC_MUX_sel <= '0' ; -- Rs2
      DMEM_ALU_WB_MUX_sel <= '0' ; -- ALU
     
END IF;
    END PROCESS;
  END ARCHITECTURE;
  
  
  
  