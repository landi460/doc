library IEEE;

use IEEE.std_logic_1164.all;

entity TBMUX21BIS is
end TBMUX21BIS;

architecture TEST of TBMUX21BIS is

	signal	A:		std_logic :='0';
	signal	B:		std_logic :='0';
	signal	S:		std_logic :='0';
	signal	Y:		std_logic;
	
	signal N: std_logic;
	signal Z: std_logic;
	signal X: std_logic;
	


begin 

	A <= '1';
	B <= '1';
	S <= '1', '0' after 1 ns; -- output dovrebbe rimanere a 1 invece ...
	
	PSN: process(S)
	begin
	  N <= not(S) after 0.1 ns; 
	end process;

	PBS: process(B,S)
	begin
	  Z <= B and S; 
	end process;

	PAS: process(A,N)
	begin
	  X <= A and N; 
	end process;

	POUT: process(X,Z)
	begin
	  Y <= X or Z; 
	end process;

end TEST;

configuration MUX21BISTEST of TBMUX21BIS is
   for TEST
   end for;
end MUX21BISTEST;

