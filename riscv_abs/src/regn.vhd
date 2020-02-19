LIBRARY ieee;
USE ieee.std_logic_1164.ALL; 
USE ieee.numeric_std.ALL;

ENTITY regn IS
GENERIC ( N : natural := 4 );
PORT ( 
		d 		: IN std_logic_vector(N-1 DOWNTO 0);
		clk		: IN std_logic; 
		rst_n	: IN std_logic;
		en 	    : IN std_logic; 
		q 		: OUT std_logic_vector(N-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE beh OF regn IS

BEGIN

PROCESS(clk, rst_n)
BEGIN
IF (rst_n = '0') THEN

	q <= (OTHERS=>'0');

ELSIF (clk'event and clk='1' and en='1') THEN
	
	q <= d;

END IF;
END PROCESS; 

END ARCHITECTURE;