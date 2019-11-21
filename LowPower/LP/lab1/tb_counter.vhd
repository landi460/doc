library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned 

entity TESTCOUNT is 
end TESTCOUNT; 

architecture TEST of TESTCOUNT is

  component COUNT
        generic ( DCOUNT : Time := 0 ns);
	Port (	A:	In	std_logic;
		CK:     In      std_logic;
                RESET:  In      std_logic;
		S:	Out	std_logic_vector(7 downto 0);
		Co:	Out	std_logic);
  end component;
  

  constant Period: time := 0.8 ns; -- Clock period
  signal CLK : std_logic :='0';
  signal RESET : std_logic;

  signal COUNTEN : std_logic;
  signal OWFL : std_logic;
  signal COUNTOUT : std_logic_vector(7 downto 0);

Begin

  UCOUNTER1: COUNT generic map (DCOUNT => 0.2 ns) port map (COUNTEN, CLK, RESET, COUNTOUT, OWFL);
  
  COUNTEN <= '0', '1' after Period*3;

-- Create the permanent Clock and the Reset pulse
  CLK <= not CLK after Period/2;
  RESET <= '1', '0' after Period;

end TEST;

configuration CFG_TESTCOUNT of TESTCOUNT is
	for TEST
		for UCOUNTER1 : COUNT
			use configuration WORK.CFG_COUNT_STRUCTURAL;
		end for;
	end for;
end CFG_TESTCOUNT;

