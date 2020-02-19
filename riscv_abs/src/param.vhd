LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

PACKAGE param IS

TYPE register_file IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0);
TYPE memory_size IS ARRAY(0 TO 127) OF std_logic_vector(7 DOWNTO 0);
  
CONSTANT INST_WIDTH       : natural := 32;
CONSTANT WORD_WIDTH       : natural := 32;
CONSTANT BYTE_WIDTH       : natural := 8;
CONSTANT SHAMT_WIDTH      : natural := 5;
CONSTANT RF_ADDR_WIDTH    : natural := 5;
CONSTANT ADDR_WIDTH       : natural := 32;
CONSTANT MEM_ADDR_WIDTH   : natural := 10;

CONSTANT IDEX_CTRL_WIDTH   : natural := 8;
CONSTANT EXDMEM_CTRL_WIDTH : natural := 6;
CONSTANT DMEMWB_CTRL_WIDTH : natural := 3;


-- R-type opcodes
CONSTANT RV32_OP  : std_logic_vector(6 DOWNTO 0) := "0110011";

-- I-type opcodes
CONSTANT RV32_JALR   : std_logic_vector(6 DOWNTO 0) := "1100111";
CONSTANT RV32_LOAD   : std_logic_vector(6 DOWNTO 0) := "0000011";
CONSTANT RV32_OP_IMM : std_logic_vector(6 DOWNTO 0) := "0010011";
CONSTANT RV32_SYSTEM : std_logic_vector(6 DOWNTO 0) := "1110011";

-- S-type opcodes
CONSTANT RV32_STORE  : std_logic_vector(6 DOWNTO 0) := "0100011";

-- SB-type opcodes
CONSTANT RV32_BRANCH : std_logic_vector(6 DOWNTO 0) := "1100011";

-- U-type opcodes
CONSTANT RV32_LUI : std_logic_vector(6 DOWNTO 0)   := "0110111";
CONSTANT RV32_AUIPC : std_logic_vector(6 DOWNTO 0) := "0010111";

-- UJ-type opcodes
CONSTANT RV32_JAL : std_logic_vector(6 DOWNTO 0) := "1101111";

-- NOP
CONSTANT RV_NOP : std_logic_vector(6 DOWNTO 0) := "0010011";
CONSTANT RV_NOP2 : std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";


-- funct3
CONSTANT RV32I_BEQ_FUNCT3   : std_logic_vector(2 DOWNTO 0) := "000"; 
CONSTANT RV32I_LW_FUNCT3    : std_logic_vector(2 DOWNTO 0) := "010"; 
CONSTANT RV32I_SW_FUNCT3    : std_logic_vector(2 DOWNTO 0) := "010"; 
CONSTANT RV32I_AND_FUNCT3   : std_logic_vector(2 DOWNTO 0) := "111"; 
CONSTANT RV32I_SRA_FUNCT3   : std_logic_vector(2 DOWNTO 0) := "101"; 
CONSTANT RV32I_ADD_FUNCT3   : std_logic_vector(2 DOWNTO 0) := "000";  
CONSTANT RV32I_SLT_FUNCT3   : std_logic_vector(2 DOWNTO 0) := "010"; 
CONSTANT RV32I_XOR_FUNCT3   : std_logic_vector(2 DOWNTO 0) := "100";   

-- funct7 
CONSTANT RV32I_SRA_FUNCT7   : std_logic_vector(6 DOWNTO 0) := "0100000";
CONSTANT RV32I_ADD_FUNCT7   : std_logic_vector(6 DOWNTO 0) := "0000000";
CONSTANT RV32I_SLT_FUNCT7   : std_logic_vector(6 DOWNTO 0) := "0000000";
CONSTANT RV32I_XOR_FUNCT7   : std_logic_vector(6 DOWNTO 0) := "0000000";

CONSTANT RV32I_AB_FUNCT7   : std_logic_vector(6 DOWNTO 0) := "0000001";

-- instruction types
CONSTANT R_TYPE   : std_logic_vector(2 DOWNTO 0) := "000";
CONSTANT I_TYPE   : std_logic_vector(2 DOWNTO 0) := "001";
CONSTANT S_TYPE   : std_logic_vector(2 DOWNTO 0) := "010";
CONSTANT SB_TYPE  : std_logic_vector(2 DOWNTO 0) := "011";
CONSTANT U_TYPE   : std_logic_vector(2 DOWNTO 0) := "100";
CONSTANT UJ_TYPE  : std_logic_vector(2 DOWNTO 0) := "101";
CONSTANT NOP_TYPE  : std_logic_vector(2 DOWNTO 0) := "111";

-- width for MUX control inside immediate generation
CONSTANT IMMEDIATE_SELECTION_WIDTH : natural := 3;

-- widths
CONSTANT RV32I_OPCODE_WIDTH   : natural := 7  ;
CONSTANT RV32I_FUNCT3_WIDTH   : natural := 3 ;
CONSTANT RV32I_SHAMT_WIDTH    : natural := 5 ;
CONSTANT RV32I_FUNCT7_WIDTH   : natural := 7 ;


-- bit positions
CONSTANT RV32I_FUNCT7_START : natural := 25 ;
CONSTANT RV32I_OPCODE_START : natural := 0  ;
CONSTANT RV32I_FUNCT3_START : natural := 12 ;
CONSTANT RV32I_SHAMT_START  : natural := 20 ;
CONSTANT RV32I_RS1_START    : natural := 15 ;
CONSTANT RV32I_RS2_START    : natural := 20 ;
CONSTANT RV32I_RD_START     : natural := 7  ;

	
END PACKAGE;
