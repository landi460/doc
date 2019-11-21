library ieee;
	use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

	use work.constants.all;


entity inccomp is
	generic	(
						N_BIT : integer := cNUM_BIT
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
end inccomp;

architecture rtl of inccomp is

------------------------------------------------------------------------
-- COMPONENTS DECLARATION ----------------------------------------------
------------------------------------------------------------------------
	component mux21_generic IS
	  generic (
	            N_BIT     : integer
	          );
	  port    (
	            DATA_0    : in  signed (N_BIT-1 downto 0);
	            DATA_1    : in  signed (N_BIT-1 downto 0);
	            SEL       : in  std_logic;
	            DATA_OUT  : out signed (N_BIT-1 downto 0)
	          );
	end component ;

	component p4_adder_1 IS
	  generic (
	            N_BIT   	: integer;
	            CARRY   	: integer
	          );
	  port    (
	            A       	: in  signed (N_BIT-1 downto 0);
	            B       	: in  signed (N_BIT-1 downto 0);
	            C_IN_0  	: in  std_logic;
	            C_OUT   	: out std_logic;
	            SUM     	: out signed (N_BIT-1 downto 0)
	          );

	end component ;

	component p4_adder_2 IS
	  generic (
	            N_BIT   	: integer;
	            CARRY   	: integer
	          );
	  port    (
	            A       	: in  signed (N_BIT-1 downto 0);
	            B       	: in  signed (N_BIT-1 downto 0);
	            C_IN_0  	: in  std_logic;
	            C_OUT   	: out std_logic;
	            SUM     	: out signed (N_BIT-1 downto 0)
	          );

	end component ;

	component RegisterN is
		generic	( 
							N : positive 
						);
		port 		(
							CLK 			: in 	std_logic; 
							RST 			: in 	std_logic;
							D 				: in 	signed (N_BIT-1 downto 0);
							Q					: out signed (N_BIT-1 downto 0)
						);
	end component;

	component comparator is
	  generic ( 
	            N : positive 
	          );
	  port    (
	            A     : in  signed ( N - 1 downto 0);
	            B     : in 	signed ( N - 1 downto 0);
	            C     : out signed ( N - 1 downto 0)

	          );
	end component;
------------------------------------------------------------------------
-- SIGNALS DECLARATIONS ------------------------------------------------
------------------------------------------------------------------------
	
	signal sIN_REG_INCA     : signed(1 downto 0);
	signal sIN_REG_INCB 	  : signed(1 downto 0);
  signal sOUT_REG_INCA    : signed(1 downto 0);
  signal sOUT_REG_INCB    : signed(1 downto 0);

	-- MUX A
	signal sSEL_MUX_A		: std_logic;
	signal sIN_0_MUX_A	: signed(N_BIT-1 downto 0);
	signal sIN_1_MUX_A	: signed(N_BIT-1 downto 0);
	signal sOUT_MUX_A		: signed(N_BIT-1 downto 0);

	-- MUX B
	signal sSEL_MUX_B		: std_logic;
	signal sIN_0_MUX_B	: signed(N_BIT-1 downto 0);
	signal sIN_1_MUX_B	: signed(N_BIT-1 downto 0);
	signal sOUT_MUX_B		: signed(N_BIT-1 downto 0);

	-- P4A_1
	signal sIN_0_P4A_1		: signed(N_BIT-1 downto 0);
	signal sIN_1_P4A_1		: signed(N_BIT-1 downto 0);
	signal sC_IN_P4A_1		: std_logic;
	signal sOUT_P4A_1			: signed(N_BIT-1 downto 0);
	--signal sC_OUT_P4A_1		: std_logic;

	-- P4A_2
	signal sIN_0_P4A_2		: signed(N_BIT-1 downto 0);
	signal sIN_1_P4A_2		: signed(N_BIT-1 downto 0);
	signal sC_IN_P4A_2		: std_logic;
	signal sOUT_P4A_2			: signed(N_BIT-1 downto 0);
	--signal sC_OUT_P4A_2		: std_logic;

	-- REG A
	signal sIN_REG_A		: signed(N_BIT-1 downto 0);
	signal sOUT_REG_A		: signed(N_BIT-1 downto 0);

	-- REG B
	signal sIN_REG_B		: signed(N_BIT-1 downto 0);
	signal sOUT_REG_B		: signed(N_BIT-1 downto 0);

	-- COMPARATOR
	signal sIN_0_COMP		: signed(N_BIT-1 downto 0);
	signal sIN_1_COMP		: signed(N_BIT-1 downto 0);
	signal sOUT_COMP		: signed(N_BIT-1 downto 0);

begin


------------------------------------------------------------------------
-- CONNECTIONS ---------------------------------------------------------
------------------------------------------------------------------------

	sSEL_MUX_A 	<= EXTA;
	sIN_0_MUX_A <= sOUT_P4A_1;
	sIN_1_MUX_A <= A;

	sSEL_MUX_B 	<= EXTB;
	sIN_0_MUX_B <= sOUT_P4A_2;
	sIN_1_MUX_B <= B;

	sIN_REG_A 	<= sOUT_MUX_A;

	sIN_REG_B 	<= sOUT_MUX_B;

	sIN_REG_INCA(0)		<= INCA;
	sIN_REG_INCA(1)		<= '0';
	sIN_0_P4A_1 	<= resize(sOUT_REG_INCA, sIN_0_P4A_1'length);
	sIN_1_P4A_1		<= sOUT_REG_A;
	sC_IN_P4A_1		<= '0';

	sIN_REG_INCB(0)		<= INCB;
	sIN_REG_INCB(1)		<= '0';
	sIN_0_P4A_2 	<= resize(sOUT_REG_INCB, sIN_0_P4A_2'length);
	sIN_1_P4A_2 	<= sOUT_REG_B;
	sC_IN_P4A_2		<= '0';

	sIN_0_COMP 	<= sOUT_P4A_1;
	sIN_1_COMP 	<= sOUT_P4A_2;

	C 					<= sOUT_COMP;


------------------------------------------------------------------------
-- PORT MAPS -----------------------------------------------------------
------------------------------------------------------------------------
	mux_a : mux21_generic
    generic map (
                  N_BIT 		=> N_BIT
                )
    port map    (
			            DATA_0    => sIN_0_MUX_A,
			            DATA_1    => sIN_1_MUX_A,
			            SEL       => sSEL_MUX_A,
			            DATA_OUT  => sOUT_MUX_A
                );


  mux_b : mux21_generic
    generic map (
                  N_BIT 		=> N_BIT
                )
    port map    (
			            DATA_0    => sIN_0_MUX_B,
			            DATA_1    => sIN_1_MUX_B,
			            SEL       => sSEL_MUX_B,
			            DATA_OUT  => sOUT_MUX_B
                );

  p4a_1 : p4_adder_1
    generic map (
                  N_BIT 		=> N_BIT,
                  CARRY			=> cNUM_CARRY
                )
    port map    (
			            A       	=> sIN_0_P4A_1,
			            B       	=> sIN_1_P4A_1,
			            C_IN_0  	=> sC_IN_P4A_1,
			            C_OUT   	=> open,
			            SUM     	=> sOUT_P4A_1
                );

  p4a_2 : p4_adder_2
    generic map (
                  N_BIT 		=> N_BIT,
                  CARRY			=> cNUM_CARRY
                )
    port map    (
			            A       	=> sIN_0_P4A_2,
			            B       	=> sIN_1_P4A_2,
			            C_IN_0  	=> sC_IN_P4A_2,
			            C_OUT   	=> open,
			            SUM     	=> sOUT_P4A_2
                );


  reg_a : RegisterN
    generic map (
                  N 				=> N_BIT
                )
    port map    (
									CLK 			=> CK,
									RST 			=> RST,
									D 				=> sIN_REG_A,
									Q					=> sOUT_REG_A
                );


  reg_b : RegisterN
    generic map (
                  N 				=> N_BIT
                )
    port map    (
									CLK 			=> CK,
									RST 			=> RST,
									D 				=> sIN_REG_B,
									Q					=> sOUT_REG_B
                );

  inc_a : RegisterN
    generic map (
                  N         => 2
                )
    port map    (
                  CLK       => CK,
                  RST       => RST,
                  D         => sIN_REG_INCA,
                  Q         => sOUT_REG_INCA
                );


  inc_b : RegisterN
    generic map (
                  N         => 2
                )
    port map    (
                  CLK       => CK,
                  RST       => RST,
                  D         => sIN_REG_INCB,
                  Q         => sOUT_REG_INCB
                );

  comp : comparator
    generic map (
                  N 				=> N_BIT
                )
    port map    (
									A 				=> sIN_0_COMP,
									B 				=> sIN_1_COMP,
									C 				=> sOUT_COMP
                );

end rtl;
