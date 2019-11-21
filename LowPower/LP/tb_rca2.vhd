library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned 

entity TBRCA is 
end TBRCA; 

architecture TEST of TBRCA is


  component RCA
        generic ( DRCAS : Time := 0 ns;
	          DRCAC : Time := 0 ns);
	Port (	A:	In	std_logic_vector(7 downto 0);
		B:	In	std_logic_vector(7 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(7 downto 0);
		Co:	Out	std_logic);
  end component;
  

  signal DIN : std_logic_vector(15 downto 0);

  signal A, B, S1, S2 : std_logic_vector(7 downto 0);
  signal Ci, Co1, Co2 : std_logic;

Begin

-- Instanciate the ADDER without delay
  UADDER1: RCA generic map (DRCAS => 0.025 ns, DRCAC => 0 ns) port map (A, B, Ci, S1, Co1);
  
-- Instanciate the ADDER without delay
  UADDER2: RCA generic map (DRCAS => 0.025 ns, DRCAC => 0.025 ns) port map (A, B, Ci, S2, Co2);
  
  Ci <= '0';
  A(0) <= '0';
  A(1) <= '0';
  A(2) <= DIN(0);
  A(3) <= DIN(1);
  A(4) <= DIN(2);
  A(5) <= DIN(3);
  A(6) <= DIN(4);
  A(7) <= DIN(5);
  
  B(0) <= DIN(8);
  B(1) <= DIN(9);
  B(2) <= DIN(10);
  B(3) <= DIN(11);
  B(4) <= DIN(12);
  B(5) <= DIN(13);
  B(6) <= DIN(14);
  B(7) <= DIN(15);

  DIN <= "1010100000101010", "1111110000000001" after 1 ns;

end TEST;

