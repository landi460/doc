library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.std_logic_signed.all; 

entity tb_FSM_adder is
end entity;

architecture TEST of tb_FSM_adder is

signal CLK, RST : STD_LOGIC := '0';
signal A, B, C, D, E, F, Y : STD_LOGIC_VECTOR(15 DOWNTO 0);

component FSM_adder is
  port ( clk: in std_logic;
  reset:	in std_logic;
 	MUX00:	in std_logic_vector(15 downto 0);
	MUX02:	in std_logic_vector(15 downto 0);
	MUX03:	in std_logic_vector(15 downto 0);
	MUX10:	in std_logic_vector(15 downto 0);
	MUX11:	in std_logic_vector(15 downto 0);
	MUX13:	in std_logic_vector(15 downto 0);
	SUMS:	buffer std_logic_vector(15 downto 0));
        
end component;

begin 
  
prova_FSM_adder: FSM_adder port map(clk=>CLK, reset=>RST, MUX00=>A, MUX02=>F, MUX03=>E, MUX10=>B, MUX11=>C, MUX13=>D, SUMS=>Y);

CLK <= not CLK after 20 ns;
RST <= '1', '0' after 5 ns;

stimulus: process
          begin
            
            
            
A <= "0000000000000001";
B <= "0000000000000001";

C <= "0000000000000001";
D <= "0000000000000001";

E <= "0000000000000001";
F <= "0000000000000001";


wait;
end process;
end architecture;
