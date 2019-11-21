library ieee; 
use ieee.std_logic_1164.all; 

entity COUNT is 
	generic (DCOUNT : 	Time := 0 ns);
	Port (	A:	In	std_logic;
		CK:     In      std_logic;
		RESET: In      std_logic;
		S:	Out	std_logic_vector(7 downto 0);
		Co:	Out	std_logic);
end COUNT; 

architecture STRUCTURAL of COUNT is

  signal STMP : std_logic_vector(7 downto 0);
  signal CTMP : std_logic_vector(8 downto 0);
  signal STMPSYNC : std_logic_vector(7 downto 0);

  component HA 
  generic (DHA : 	Time := 0 ns);
  Port ( A:	In	std_logic;
	 B:	In	std_logic;
	 S:	Out	std_logic;
	 Co:	Out	std_logic);
  end component; 

  component FD
  Port (  D:      In      std_logic;
          CK:     In      std_logic;
          RESET:  In      std_logic;
          Q:      Out     std_logic);
  end component;

begin


  S <= STMPSYNC;
  Co <= CTMP(8);
  CTMP(0) <= A; 

  HADDER1: for I in 1 to 8 generate
    HAI : HA generic map (DHA => DCOUNT) Port Map (STMPSYNC(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
  end generate;
  DFF1:  for I in 1 to 8 generate
    DFFI : FD Port Map (STMP(I-1), CK, RESET, STMPSYNC(I-1));
  end generate;  

end STRUCTURAL;


configuration CFG_COUNT_STRUCTURAL of COUNT is
  for STRUCTURAL 
    for HADDER1
      for all : HA
        use configuration WORK.CFG_HA_BEHAVIORAL;
      end for;
    end for;
    for DFF1
      for all : FD
	use configuration WORK.CFG_FD_PLUTO;
      end for;	
    end for;	
  end for;
end CFG_COUNT_STRUCTURAL;
