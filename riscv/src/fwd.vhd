LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;

ENTITY forwarding_unit IS
  PORT(
    ID_EX_Rs1       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    ID_EX_Rs2       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_Rs1      : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_Rs2      : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_Rd       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    MEM_WB_Rd       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_RegWrite : IN  std_logic;
    EX_MEM_MemWrite : IN  std_logic;
    MEM_WB_RegWrite : IN  std_logic;
    MEM_WB_MemToReg : IN  std_logic;
    fwd_a           : OUT std_logic_vector(1 DOWNTO 0);
    fwd_b           : OUT std_logic_vector(1 DOWNTO 0);
    fwd_Wrt_data    : OUT std_logic;
    fwd_Wrt_addr    : OUT std_logic
    );
END ENTITY;
 
ARCHITECTURE beh OF forwarding_unit IS

BEGIN
  PROCESS(ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rs1, EX_MEM_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_RegWrite, EX_MEM_MemWrite, MEM_WB_RegWrite, MEM_WB_MemToReg)
   
  BEGIN 

--  ALU INPUT A  
    IF ((EX_MEM_RegWrite = '1') and (EX_MEM_Rd /= "00000") and (EX_MEM_Rd = ID_EX_Rs1)) THEN
		fwd_a <= "11";	
	ELSIF ((MEM_WB_RegWrite = '1') and (MEM_WB_Rd /= "00000") and (MEM_WB_Rd = ID_EX_Rs1)) THEN
		fwd_a <= "01";
	ELSE
		fwd_a <= "00";
	END IF;	

--  ALU INPUT B  		
    IF ((EX_MEM_RegWrite = '1') and (EX_MEM_Rd /= "00000") and (EX_MEM_Rd = ID_EX_Rs2)) THEN
		fwd_b <= "11";	
	ELSIF ((MEM_WB_RegWrite = '1') and (MEM_WB_Rd /= "00000") and (MEM_WB_Rd = ID_EX_Rs2)) THEN
		fwd_b <= "01";
	ELSE
		fwd_b <= "00";	
    END IF;		
		
-- forwards store data when it immediately follows a load to the same register	
    IF ((MEM_WB_MemToReg = '1') and (EX_MEM_MemWrite = '1') and (MEM_WB_Rd /= "00000") and (MEM_WB_Rd = EX_MEM_Rs2)) THEN
		fwd_Wrt_data <= '1'; 
    ELSE 
	    fwd_Wrt_data <= '0';
    END IF; 	

    IF ((MEM_WB_MemToReg = '1') and (EX_MEM_MemWrite = '1') and (MEM_WB_Rd /= "00000") and (MEM_WB_Rd = EX_MEM_Rs1)) THEN
		fwd_Wrt_addr <= '1'; 
    ELSE 
	    fwd_Wrt_addr <= '0';
    END IF; 	

  END PROCESS;

END beh;

