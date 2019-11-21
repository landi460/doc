library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.math_real.all ; -- for UNIFORM, TRUNC


entity counter_tb is
end entity ; -- rca_tb

architecture arch of counter_tb is

component counter is 
  port
  (
		CLK		 		: in	std_logic;
		RST				: in 	std_logic;
		COUNT	 		: in 	std_logic;
		DATA_OUT	: out	unsigned (8-1 downto 0);
		UP_DN			: out	std_logic);
end component;

  signal COUNT_TB  :	std_logic;
  signal DATA_OUT_TB  :	unsigned (8-1 downto 0);
  signal UP_DN_TB  :	std_logic;
  signal CK_TB    : std_logic := '1';
  signal RST_TB   : std_logic;



begin

  DUT : counter
  port map    (
                COUNT => COUNT_TB,
                DATA_OUT => DATA_OUT_TB,
                UP_DN => UP_DN_TB,
                CLK => CK_TB,
                RST => RST_TB
              ); 
     
  CK_TB <= not CK_TB after 2500 ps;
  RST_TB <= '1', '0' after 3 ns;
              
  test : process        

 
begin
  
 UP_DN_TB <= '1';
 COUNT_TB <= '1';


  for I in 1 to 100 loop

   COUNT_TB <= '1';

  wait until CK_TB'event and CK_TB = '1';

  COUNT_TB <= '0';

  wait for 300 ns;

  

  end loop;

  wait;

end process;


end architecture ; -- arch
