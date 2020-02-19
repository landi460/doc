LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

USE work.param.all;

ENTITY data_mem IS

-- GENERIC(INIT_FILE : string); 

  PORT(
    clk        : IN  std_logic; 	
    memRead    : IN  std_logic; 	
    memWrite   : IN  std_logic;		
    address    : IN  std_logic_vector(7-1 DOWNTO 0);	
    input      : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0);
    output     : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE beh OF data_mem IS

--SIGNAL mem : memory_size;
  
BEGIN

-- syncronous read and write
  mem_op : PROCESS (clk, memRead, memWrite) 
  
  BEGIN
  
    IF rising_edge(clk) THEN
	
    	IF (memRead = '1') THEN
    		
    		case address is
   				when "0000000" =>
     				output <= "00000000000000000000000000001010";
   				when "0000100" =>
     				output <= "11111111111111111111111111010001";
   				when "0001000" =>
     				output <= "00000000000000000000000000010110";
   				when "0001100" =>
     				output <= "11111111111111111111111111111101";
   				when "0010000" =>
     				output <= "00000000000000000000000000001111";
   				when "0010100" =>
     				output <= "00000000000000000000000000011011";
   				when "0011000" =>
     				output <= "11111111111111111111111111111100";
				when "0011100" =>
     				output <= "00000000000000000000000000000000";
     			when others 	=>
     				output <= "00000000000000000000000000000000";
			end case;
		END IF;	
		
    END IF;
  END PROCESS;
  
END ARCHITECTURE;


