LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

USE work.param.all;

ENTITY instr_mem IS

--GENERIC(INIT_FILE : string); 

  PORT(
    clk        : IN  std_logic; 	
    memRead    : IN  std_logic; 	
    memWrite   : IN  std_logic;		
    address    : IN  std_logic_vector(7-1 DOWNTO 0);	
    input      : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0);
    output     : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END ENTITY;


ARCHITECTURE beh OF instr_mem IS

--SIGNAL mem : memory_size;
  
BEGIN

-- syncronous read and write
  mem_op : PROCESS (clk, memRead, memWrite) 
  
  BEGIN
  
    IF rising_edge(clk) THEN
	
    	IF (memRead = '1') THEN
    		
    		case address is
   				when "0000000" => --0
     				output <= "00000000011100000000100000010011";
   				when "0000100" => --4
     				output <= "00000000000000000010001000010111";
   				when "0001000" => --8
     				output <= "11111111110000100000001000010011";
   				when "0001100" => --12
     				output <= "00000000000000000010001010010111";
   				when "0010000" => --16
     				output <= "00000001000000101000001010010011";
   				when "0010100" => --20
     				output <= "01000000000000000000011010110111";
   				when "0011000" => --24
     				output <= "11111111111101101000011010010011";
   				when "0011100" => --28
     				output <= "00000010000010000000100001100011";
   				when "0100000" => --32
     				output <= "00000000000000100010010000000011";
   				when "0100100" => --36
     				output <= "01000001111101000101010010010011";
   				when "0101000" => --40
     				output <= "00000000100101000100010100110011";
   				when "0101100" => --44
     				output <= "00000000000101001111010010010011";
   				when "0110000" => --48
     				output <= "00000000100101010000010100110011";
   				when "0110100" => --52
     				output <= "00000000010000100000001000010011";	
   				when "0111000" => --56
     				output <= "11111111111110000000100000010011";
   				when "0111100" => --60
     				output <= "00000000110101010010010110110011";
   				when "1000000" => --64
     				output <= "11111100000001011000111011100011";
   				when "1000100" => --68
     				output <= "00000000000001010000011010110011";
   				when "1001000" => --72
     				output <= "11111101010111111111000011101111";
   				when "1001100" => --76
     				output <= "00000000110100101010000000100011";
   				when "1010000" => --80
     				output <= "00000000000000000000000011101111";
   				when "1010100" => --84
     				output <= "00000000000000000000000000010011";
     			when others 	=>
     				output <= "00000000000000000000000000000000";
			end case;
		END IF;
		
    END IF;
  END PROCESS;
  
END ARCHITECTURE;


