library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.std_logic_signed.all;

entity FSM_adder is
  port ( clk: in std_logic;
  reset:	in std_logic;
	MUX00:	in std_logic_vector(15 downto 0);
	MUX02:	in std_logic_vector(15 downto 0);
	MUX03:	in std_logic_vector(15 downto 0);
	MUX10:	in std_logic_vector(15 downto 0);
	MUX11:	in std_logic_vector(15 downto 0);
	MUX13:	in std_logic_vector(15 downto 0);
	SUMS:	buffer std_logic_vector(15 downto 0));
        
end FSM_adder;


architecture behavioral of FSM_adder is

signal s0, s1, s2, s3: std_logic;


component datapath_adder is
port( 	
  MUX00:	in std_logic_vector(15 downto 0);
	MUX01:	in std_logic_vector(15 downto 0);
	MUX02:	in std_logic_vector(15 downto 0);
	MUX03:	in std_logic_vector(15 downto 0);
	MUX10:	in std_logic_vector(15 downto 0);
	MUX11:	in std_logic_vector(15 downto 0);
	MUX12:	in std_logic_vector(15 downto 0);
	MUX13:	in std_logic_vector(15 downto 0);
	clock: 	in std_logic;
	reset:	in std_logic;
	SEL00:	in std_logic;
	SEL01:	in std_logic;
	SEL10:	in std_logic;
	SEL11:	in std_logic;
	SUM :	buffer std_logic_vector(15 downto 0)
);
end	component;

component FSM is
  port ( clk, reset: in std_logic;
         S0, S1, S2, S3: out std_logic);
end component;

--port map
begin

prova_datapath: datapath_adder port map (MUX00=>MUX00, MUX01=>SUMS, MUX02=>MUX02, MUX03=>MUX03, MUX10=>MUX10, 
MUX11=>MUX11, MUX12=>SUMS, MUX13=>MUX13, SUM=>SUMS, SEL00=>s0, SEL01=>s1,
SEL10=>s2, SEL11=>s3, clock=>clk, reset=>reset); 
                                  
prova_FSM: FSM port map (clk=>clk, reset=>reset, S0=>s0, S1=>s1, S2=>s2, S3=>s3);

end architecture;




