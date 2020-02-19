LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;
USE work.alu_param.all;

ENTITY alu IS
  PORT(
    a, b     : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0); 
    alu_op   : IN  std_logic_vector(ALU_OP_WIDTH-1 DOWNTO 0); 
    output   : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END ENTITY;
 
ARCHITECTURE beh OF alu IS

SIGNAL res : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);

BEGIN
  PROCESS(a, b, alu_op)
   
  BEGIN
    CASE(alu_op) IS
	
    WHEN ALU_ADD => 
      res <= std_logic_vector(signed(a) + signed(b));
	  
    WHEN ALU_XOR =>	
      res <= a xor b;	

    WHEN ALU_AND =>	
      res <= a and b;	

    WHEN ALU_SEQ =>   
	  IF (signed(a) = signed(b)) THEN
	  res <= (0 => '1', OTHERS => '0');
	  ELSE
	  res <= (OTHERS => '0');
	  END IF;		  
	  
    WHEN ALU_SLT =>   
	  IF (signed(a) < signed(b)) THEN
	  res <= (0 => '1', OTHERS => '0');
	  ELSE
	  res <= (OTHERS => '0');
	  END IF;	

    WHEN ALU_SRA =>
	  res <= std_logic_vector(shift_right(signed(a), to_integer(unsigned(b(SHAMT_WIDTH-1 downto 0)))));	  
	  
    WHEN ALU_LUI =>	
      res <= b;	 
	  
	WHEN ALU_AB =>
	  
	  if (a(31) = '1') then
	  res <= (a xor "11111111111111111111111111111111") + 1;	 -- This complements x is x was negative and subtract one, does nothing if x is positive
	  else
	  res <= a;
	  end if;

    WHEN OTHERS => 
      res <= (OTHERS => '0');	 
	
    END CASE;
  END PROCESS;
 
  output <= res; 

END beh;

