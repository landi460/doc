library IEEE;
use IEEE.std_logic_1164.all;
use WORK.all;

entity CKGBUG is
end CKGBUG;

architecture TEST of CKGBUG is

	constant BYTE : natural := 8;
	
	signal	CK:		std_logic :='0';
	signal	RESET:		std_logic :='0';
	signal	D1:		std_logic_vector(byte-1 downto 0) := ('0', others => '1');
	signal	D2:		std_logic_vector(0 to byte-1) := (others => '0');
	signal	D3:		std_logic_vector(byte-1 downto 0) := (others => '1');
        -- the multiple assignment is also possible like := "11111111"
	signal	ENABLE:		std_logic :='1';
	signal	STROBE:		std_logic;
	signal	Q:		std_logic;
	
	
	component FD
	
	Port (	CK:	In	std_logic;
		RESET:	In	std_logic;
		D:	In	std_logic;
		Q:	Out	std_logic);
	end component;

begin 
	
	
	L1: for I in 1 to BYTE generate
	  REG1 : FD Port Map ( CK, RESET, D1(I-1), D2(I-1)); 
	end generate;


	L2: for I in 1 to BYTE generate
	  REG2 : FD Port Map ( STROBE, RESET, D2(I-1), D3(I-1)); 
	end generate;

        STROBE <= CK and ENABLE;
	
	--RESET <= '0', '1' after 0.6 ns, '0' after 1.1 ns, '1' after 2.2 ns, '0' after 3.2 ns;	
	RESET <= '1' after 0.1 ns, '0' after 0.2 ns;
	
	--D <= '0' after 0 ns, '1' after 0.4 ns, '0' after 1.1 ns, '1' after 1.4 ns;
	--ENABLE <= '1' after 0 ns, '0' after 4.4 ns;
	
	PCLOCK : process(CK)
	begin
		CK <= not(CK) after 0.5 ns;	
	end process;



	

end TEST;

configuration CFG_CKGBUG_TEST of CKGBUG is
   for TEST
     for L1
        for all : FD
           use configuration WORK.CFG_FD_PLUTO; 
        end for;
     end for;
     for L2
        for all : FD
           use configuration WORK.CFG_FD_PLUTO; 
        end for;
     end for;

   end for;
end CFG_CKGBUG_TEST;

