library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterN is
	generic	( 
						N : integer 
					);
	port 		(
						CLK 	: in 	std_logic; 
						RST 	: in 	std_logic;
						D 		: in 	signed ( N - 1 downto 0);
						Q			: out signed ( N - 1 downto 0)
					);
end RegisterN;

architecture arch of RegisterN is

begin

	reg : process( CLK, RST )
	begin
		if ( RST = '1' ) then 
			Q <= ( others => '0' );
		elsif ( CLK'event and CLK = '1' ) then
			Q <= D;
		end if;
	end process;
end architecture ; -- arch
