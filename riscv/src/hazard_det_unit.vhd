LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;

ENTITY hazard_det_unit IS
  PORT(
    ID_EX_Rd        : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    IF_ID_Rs1       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    IF_ID_Rs2       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    ID_EX_memRead   : IN  std_logic;
    IF_ID_memWrite  : IN  std_logic;
    ControlHaz      : IN  std_logic;	
    stall_n         : OUT std_logic;
    flush_ID_EX     : OUT std_logic;
    flush_IFIDEXMEM : OUT std_logic
    );
END ENTITY;
 
ARCHITECTURE beh OF hazard_det_unit IS

BEGIN
  PROCESS(ID_EX_memRead, ID_EX_Rd, IF_ID_Rs1, IF_ID_Rs2)
   
  BEGIN
    IF (ControlHaz = '1') THEN
	stall_n <= '1';	
	flush_ID_EX <= '1';	
	flush_IFIDEXMEM <= '1';
	
	ELSIF ((ID_EX_memRead = '1') and (ID_EX_Rd /= "00000") and (IF_ID_memWrite = '0') and ((ID_EX_Rd = IF_ID_Rs1) or (ID_EX_Rd = IF_ID_Rs2))) THEN	
	stall_n <= '0';	
	flush_ID_EX <= '1';	
	flush_IFIDEXMEM <= '0';
	
	ELSE 
	stall_n <= '1';	
	flush_ID_EX <= '0';	
	flush_IFIDEXMEM <= '0';
    END IF;
	
  END PROCESS;

END beh;

