library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.math_real.all ; -- for UNIFORM, TRUNC


entity inccomp_tb is
end entity ; -- rca_tb

architecture arch of inccomp_tb is

component inccomp is
	generic	(
						N_BIT : integer := 32
					);
	port		(	
						CK		: in 	std_logic;
						RST		: in 	std_logic;
						INCA	: in 	std_logic;
						INCB	: in 	std_logic;
						EXTA 	: in 	std_logic;
						EXTB 	: in 	std_logic;
						A			: in 	signed (N_BIT-1 downto 0);
						B			: in 	signed (N_BIT-1 downto 0);
						C			: out	signed (N_BIT-1 downto 0)
					);
end component;

  signal A_TB     : signed(31 downto 0);
  signal B_TB     : signed(31 downto 0);
  signal C_TB     : signed(31 downto 0);
  signal EXTA_TB  :	std_logic;
  signal EXTB_TB  :	std_logic;
  signal INCA_TB  :	std_logic;
  signal INCB_TB  :	std_logic;
  signal CK_TB    : std_logic := '1';
  signal RST_TB   : std_logic;



begin

  DUT : inccomp
  generic map (
                N_BIT => 32
              )
  port map    (
                A   => A_TB, 
                B   => B_TB, 
                C  =>  C_TB, 
                EXTA   => EXTA_TB, 
                EXTB   => EXTB_TB, 
                INCA => INCA_TB,
                INCB => INCB_TB,
                CK => CK_TB,
                RST => RST_TB
              ); 
     
  CK_TB <= not CK_TB after 2500 ps;
  RST_TB <= '1', '0' after 3 ns;
              
  random : process        
  variable seed1, seed2: positive;
  variable rand_1: real;
  variable rand_2: real;
  variable int_rand_1: integer;
  variable int_rand_2: integer;
  variable sum: signed(31 downto 0);

 
begin
  

for I in 1 to 1000 loop
  A_TB      <= "00000000000000000000000000000001";
  B_TB      <= "00000000000000000000000000000001";
  
wait for 2500 ps;
end loop;
 
  INCA_TB   <= '1';
  INCB_TB   <= '1';
  EXTA_TB   <= '1', '0' after 100 ns;
  EXTB_TB   <= '1', '0' after 100 ns;

  wait;

end process;


end architecture ; -- arch
