library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.math_real.all ; -- for UNIFORM, TRUNC
  use std.textio.all;


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

file results: text;

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
  variable line_out: line;

 
begin
  

  A_TB    <= to_signed(0, A_TB'LENGTH);
  B_TB    <= to_signed(0, B_TB'LENGTH);
  
  
  INCA_TB   <= '1';
  INCB_TB   <= '1';
  EXTA_TB   <= '0';
  EXTB_TB   <= '0';

  


file_open(results, "results.txt", write_mode);
  for I in 1 to 1000 loop
    -- Random number generation
    UNIFORM(seed1, seed2, rand_1);
    UNIFORM(seed1, seed2, rand_2);

    int_rand_1 := INTEGER(TRUNC(rand_1*4294967296.0 - 2147483649.0));
    int_rand_2 := INTEGER(TRUNC(rand_2*4294967296.0 - 2147483649.0));
  
    A_TB  <= to_signed(int_rand_1, A_TB'LENGTH);
    B_TB   <= to_signed(int_rand_2, B_TB'LENGTH);

    
    write(line_out,I,left,20);
    write(line_out,to_integer(C_TB));
    writeline(results, line_out);


  wait for 2500 ps;
  end loop;

  wait;

end process;


end architecture ; -- arch
