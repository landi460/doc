library IEEE;
use IEEE.std_logic_1164.all;
use WORK.all;

entity CKGATING is
end CKGATING;

architecture TEST of CKGATING is

	signal	CK:		std_logic :='0';
	signal	RESET:		std_logic :='0';
	signal	D:		std_logic :='0';
	signal	ENABLE:		std_logic :='0';
	signal	ENABLEL:	std_logic :='0';
	signal	STROBE:		std_logic;
	signal	Q:		std_logic;
	
	
	component LD
	
	Port (	CK:	In	std_logic;
		RESET:	In	std_logic;
		D:	In	std_logic;
		Q:	Out	std_logic);
	end component;

	component FD
	
	Port (	CK:	In	std_logic;
		RESET:	In	std_logic;
		D:	In	std_logic;
		Q:	Out	std_logic);
	end component;

begin 
		
	ULD : LD
	Port Map ( CK, RESET, ENABLE, ENABLEL); -- asincrono

        
	UFD : FD
	Port Map ( STROBE, RESET, D, Q); -- asincrono


        STROBE <= CK and ENABLEL;
	
	--RESET <= '0', '1' after 0.6 ns, '0' after 1.1 ns, '1' after 2.2 ns, '0' after 3.2 ns;	
	RESET <= '1' after 0.1 ns, '0' after 0.2 ns;
	
	D <= '0' after 0 ns, '1' after 0.4 ns, '0' after 1.1 ns, '1' after 1.6 ns;
	ENABLE <= '1' after 0 ns, '0' after 2.3 ns;
	
	PCLOCK : process(CK)
	begin
		CK <= not(CK) after 0.5 ns;	
	end process;



	

end TEST;

configuration CKGTEST of CKGATING is
   for TEST
      for ULD : LD
         use configuration WORK.CFG_LD_BEHAVIORAL;
      end for;
      for UFD : FD
         use configuration WORK.CFG_FD_PLUTO; 
      end for;


   end for;
end CKGTEST;

