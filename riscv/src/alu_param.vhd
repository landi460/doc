LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

PACKAGE alu_param IS
  
CONSTANT ALU_OP_WIDTH     : natural := 4;

-- ALU opcodes
CONSTANT ALU_ADD  : STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 DOWNTO 0) := "0000";     
      
CONSTANT ALU_XOR  : STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 DOWNTO 0) := "0001";     
CONSTANT ALU_AND  : STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 DOWNTO 0) := "0010";    

CONSTANT ALU_SRA  : STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 DOWNTO 0) := "0011";  
CONSTANT ALU_SLT  : STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 DOWNTO 0) := "0100";   
CONSTANT ALU_SEQ  : STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 DOWNTO 0) := "0101";   
CONSTANT ALU_LUI  : STD_LOGIC_VECTOR(ALU_OP_WIDTH-1 DOWNTO 0) := "0111";   
	
END PACKAGE;