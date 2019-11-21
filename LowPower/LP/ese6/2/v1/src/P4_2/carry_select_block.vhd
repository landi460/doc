LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.all;

USE work.constants.ALL;

ENTITY carry_select_block IS
  GENERIC (
            N_BIT : integer := cNUM_CARRY
          );
  PORT    (
            A     : in  signed (N_BIT-1 DOWNTO 0);
            B     : in  signed (N_BIT-1 DOWNTO 0);
            C_SEL : in  std_logic;
            SUM   : out signed (N_BIT-1 DOWNTO 0)
          );

END ENTITY carry_select_block;

ARCHITECTURE structural OF carry_select_block IS
  COMPONENT rca_generic IS
    GENERIC (
              N_BIT : INTEGER
            );
    PORT    (
              A         : in  signed (N_BIT-1 DOWNTO 0);
              B         : in  signed (N_BIT-1 DOWNTO 0);
              C_IN      : in  std_logic;
              S         : out signed (N_BIT-1 DOWNTO 0);
              C_OUT     : out std_logic
            );
  END COMPONENT rca_generic;

  COMPONENT mux21_generic IS
    GENERIC (
              N_BIT     : INTEGER
            );
    PORT    (
              DATA_0    : in  signed (N_BIT-1 DOWNTO 0);
              DATA_1    : in  signed (N_BIT-1 DOWNTO 0);
              SEL       : in  std_logic;
              DATA_OUT  : out signed (N_BIT-1 DOWNTO 0)
            );
  END COMPONENT mux21_generic;

  SIGNAL sSUM_0 : signed (N_BIT-1 DOWNTO 0);
  SIGNAL sSUM_1 : signed (N_BIT-1 DOWNTO 0);
BEGIN
  rca_0 : rca_generic
    GENERIC MAP (
                  N_BIT     => N_BIT
                )
    PORT MAP    (
                  A         => A,
                  B         => B,
                  C_IN      => '0',
                  S         => sSUM_0,
                  C_OUT     => OPEN
                );


  rca_1 : rca_generic
    GENERIC MAP (
                  N_BIT     => N_BIT
                )
    PORT MAP    (
                  A         => A,
                  B         => B,
                  C_IN      => '1',
                  S         => sSUM_1,
                  C_OUT     => OPEN
                );

  mux : mux21_generic
    GENERIC MAP (
                  N_BIT     => N_BIT
                )
    PORT MAP    (
                  DATA_0    => sSUM_1,
                  DATA_1    => sSUM_0,
                  SEL       => C_SEL,
                  DATA_OUT  => SUM
                );
END ARCHITECTURE structural;