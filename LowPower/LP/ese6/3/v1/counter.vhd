library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity counter is
	port
	(
		CLK		 		: in	std_logic;
		RST				: in 	std_logic;
		COUNT	 		: in 	std_logic;
		DATA_OUT	: out	unsigned (8-1 downto 0);
		UP_DN			: out	std_logic
	);
end entity;

architecture behavioral of counter is
type state_type is (idle, u1, u2, u3, u4, u5, u6, u7, d6, d5, d4, d3, d2, d1);
signal sSTATE : state_type;

begin
	state : process (CLK, RST)
	begin
		if RST = '1' then
			sSTATE <= idle;
		elsif (CLK'event and CLK = '1') then
			case sSTATE is
				when idle=>
					if COUNT = '1' then
						sSTATE <= u1;
					else
						sSTATE <= idle;
					end if;

				when u1=>
					if COUNT = '1' then
						sSTATE <= u2;
					else
						sSTATE <= u1;
					end if;

				when u2=>
					if COUNT = '1' then
						sSTATE <= u3;
					else
						sSTATE <= u2;
					end if;
					
				when u3=>
					if COUNT = '1' then
						sSTATE <= u4;
					else
						sSTATE <= u3;
					end if;

				when u4=>
					if COUNT = '1' then
						sSTATE <= u6;
					else
						sSTATE <= u4;
					end if;

				when u5=>
					if COUNT = '1' then
						sSTATE <= u6;
					else
						sSTATE <= u5;
					end if;

				when u6=>
					if COUNT = '1' then
						sSTATE <= u7;
					else
						sSTATE <= u6;
					end if;

				when u7=>
					if COUNT = '1' then
						sSTATE <= d6;
					else
						sSTATE <= u7;
					end if;

				when d6=>
					if COUNT = '1' then
						sSTATE <= d5;
					else
						sSTATE <= d6;
					end if;

				when d5=>
					if COUNT = '1' then
						sSTATE <= d4;
					else
						sSTATE <= d5;
					end if;

				when d4=>
					if COUNT = '1' then
						sSTATE <= d3;
					else
						sSTATE <= d4;
					end if;

				when d3=>
					if COUNT = '1' then
						sSTATE <= d2;
					else
						sSTATE <= d3;
					end if;

				when d2=>
					if COUNT = '1' then
						sSTATE <= d1;
					else
						sSTATE <= d2;
					end if;

				when d1=>
					if COUNT = '1' then
						sSTATE <= idle;
					else
						sSTATE <= d1;
					end if;	
			end case;
		end if;
	end process;

	output: process (sSTATE)
	begin
		case sSTATE is
			when idle	=> 
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(0, DATA_OUT'length);

			when u1		=>
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(1, DATA_OUT'length);

			when u2		=>
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(2, DATA_OUT'length);

			when u3		=>
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(3, DATA_OUT'length);

			when u4		=>
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(4, DATA_OUT'length);

			when u5		=>
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(5, DATA_OUT'length);

			when u6		=>
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(6, DATA_OUT'length);

			when u7		=>
				UP_DN <= '1';
				DATA_OUT <= to_unsigned(7, DATA_OUT'length);

			when d6		=>
				UP_DN <= '0';
				DATA_OUT <= to_unsigned(6, DATA_OUT'length);

			when d5		=>
				UP_DN <= '0';
				DATA_OUT <= to_unsigned(5, DATA_OUT'length);

			when d4		=>
				UP_DN <= '0';
				DATA_OUT <= to_unsigned(4, DATA_OUT'length);

			when d3		=>
				UP_DN <= '0';
				DATA_OUT <= to_unsigned(3, DATA_OUT'length);

			when d2		=>
				UP_DN <= '0';
				DATA_OUT <= to_unsigned(2, DATA_OUT'length);

			when d1		=>
				UP_DN <= '0';
				DATA_OUT <= to_unsigned(1, DATA_OUT'length);
		end case;
	end process;
end behavioral;