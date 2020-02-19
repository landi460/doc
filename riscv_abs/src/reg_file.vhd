LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

USE work.param.all;

ENTITY reg_file IS
  PORT(
    clk         : IN  std_logic; 	
    rst_n       : IN  std_logic; 	
    writeEn     : IN  std_logic;	
    writeAddr   : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);	
    input       : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0);	
    readAddr0   : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
    readAddr1   : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);		
    out0        : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0);
    out1        : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END reg_file;


ARCHITECTURE beh OF reg_file IS

SIGNAL registers : register_file;
  
BEGIN
 
-- asyncronous read an bypass 
  read_op : PROCESS (clk, rst_n)	
  BEGIN
  
	IF ((to_integer(unsigned(readAddr0))) = 0) THEN	
	out0 <= (others=>'0');
		
    ELSIF ((readAddr0 = writeAddr) and (writeEn = '1')) THEN
	out0 <= input;
    
	ELSE 
    out0 <= registers(to_integer(unsigned(readAddr0)));	
	END IF; 

	IF ((to_integer(unsigned(readAddr1))) = 0) THEN
	out1 <= (others=>'0');

    ELSIF ((readAddr1 = writeAddr) and (writeEn = '1')) THEN 	
	out1 <= input;
    
	ELSE 
    out1 <= registers(to_integer(unsigned(readAddr1)));	
	END IF;	
	
  END PROCESS;

-- syncronous write
  write_op : PROCESS (clk, rst_n) IS
  BEGIN
  
    IF rising_edge(clk) THEN
	
    	IF (rst_n = '0') THEN
    		FOR i IN 0 TO 31 LOOP
    			registers(i) <= (others=>'0');
    		END LOOP;

        ELSIF (writeEn = '1' and (to_integer(unsigned(writeAddr)) /= 0)) THEN
        registers(to_integer(unsigned(writeAddr))) <= input; 
			
        END IF;
    END IF;
  END PROCESS;
  
END ARCHITECTURE;


