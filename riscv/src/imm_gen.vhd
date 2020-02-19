LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;

ENTITY imm_gen IS
  PORT(
    inst        : IN  std_logic_vector(INST_WIDTH-1 DOWNTO 0); 
    inst_type   : IN  std_logic_vector(2 DOWNTO 0); 
    output      : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END ENTITY;
 
ARCHITECTURE beh OF imm_gen IS

SIGNAL res : std_logic_vector (INST_WIDTH-1 DOWNTO 0);

BEGIN
  PROCESS(inst, inst_type)
   
  BEGIN
    CASE(inst_type) IS 
	
    WHEN I_TYPE => 
      res(31 downto 11) <= inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) &
      						inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) 
      						& inst(31) & inst(31) & inst(31) & inst(31) & 
      					   inst(31) & inst(31) & inst(31) & inst(31) & inst(31); 
      res(10 downto 0) <= inst(30 downto 20);	
	  
    WHEN S_TYPE =>	
    	res(4 downto 0) <= inst(11 downto 7);
    	res(10 downto 5) <= inst(30 downto 25);
        res(31 downto 11) <= inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) &
      						inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) 
      						& inst(31) & inst(31) & inst(31) & inst(31) & 
      					   inst(31) & inst(31) & inst(31) & inst(31) & inst(31); 
      
    WHEN SB_TYPE =>	
    	res(3 downto 0) <= inst(11 downto 8);	
    	res(9 downto 4) <= inst(30 downto 25);	
    	res(10) <= inst(7);	
        res(31 downto 11) <= inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) &
      						inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) 
      						& inst(31) & inst(31) & inst(31) & inst(31) & 
      					   inst(31) & inst(31) & inst(31) & inst(31) & inst(31); 
      	
    WHEN UJ_TYPE =>	
    	res(18 downto 11) <= inst(19 downto 12);
    	res(10) <= inst(20);
    	res(9 downto 0) <= inst(30 downto 21);		 
    	res(31 downto 19) <= inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & 
    				inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31) & inst(31); 
   		
   	WHEN U_TYPE =>	
    	res(31 downto 12) <= inst(31 downto 12);		
        res(11 downto 0) <= (others => '0');

    WHEN OTHERS => 
      res <= (others => '0');	 
	
    END CASE;
  END PROCESS;
 
  output <= res; 

END beh;

