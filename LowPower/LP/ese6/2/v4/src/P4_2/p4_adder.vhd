LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.all;
  USE work.constants.ALL;

ENTITY p4_adder IS
  GENERIC (
            N_BIT   : integer := cNUM_BIT;
            CARRY   : integer := cNUM_CARRY
          );
  PORT    (
            A       : in  signed (N_BIT-1 DOWNTO 0);
            B       : in  signed (N_BIT-1 DOWNTO 0);
            C_IN_0  : in  std_logic;
            C_OUT   : out std_logic;
            SUM     : out signed (N_BIT-1 DOWNTO 0)
          );

END ENTITY p4_adder;

ARCHITECTURE structural OF p4_adder IS

  COMPONENT carry_generator IS
    GENERIC (
              N_BIT   : integer;
              CARRY   : integer
            );
    PORT    (
              A       : in  signed (N_BIT-1 DOWNTO 0);
              B       : in  signed (N_BIT-1 DOWNTO 0);
              C_IN_0  : in  std_logic;
              C_OUT   : out std_logic_vector (N_BIT/CARRY DOWNTO 0)
            );
  END COMPONENT carry_generator;

  COMPONENT sum_generator IS
    GENERIC (
              N_BIT : integer;
              CARRY : integer
            );
    PORT    (
              A     : in  signed (N_BIT-1 DOWNTO 0);
              B     : in  signed (N_BIT-1 DOWNTO 0);
              C_IN  : in  std_logic_vector (N_BIT/CARRY DOWNTO 0);
              SUM   : out signed (N_BIT-1 DOWNTO 0)
            );
  END COMPONENT sum_generator;

  SIGNAL sCARRIES   : std_logic_vector (N_BIT/CARRY DOWNTO 0);
  SIGNAL sERROR     : boolean := false;
  SIGNAL sSUM       : signed (N_BIT-1 downto 0);

BEGIN  -- ARCHITECTURE structural

  -- assign outputs
  C_OUT <= sCARRIES(N_BIT/CARRY);
  SUM   <= sSUM;

  cg : carry_generator
    GENERIC MAP (
                  N_BIT   => N_BIT,
                  CARRY   => CARRY
                )
    PORT MAP    (
                  A       => A,
                  B       => B,
                  C_IN_0  => C_IN_0,
                  C_OUT   => sCARRIES
                );

  sg : sum_generator
    GENERIC MAP (
                  N_BIT   => N_BIT,
                  CARRY   => CARRY
                )
    PORT MAP    (
                  A       => A,
                  B       => B,
                  C_IN    => sCARRIES,
                  SUM     => sSUM
                );
                        
  
  -- check for errors              
  sERROR <= false when A+B = sSUM else true;

END ARCHITECTURE structural;