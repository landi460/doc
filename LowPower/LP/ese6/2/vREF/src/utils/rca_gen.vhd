LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.all;
--USE ieee.std_logic_unsigned.ALL;
USE work.constants.ALL;

ENTITY rca_generic IS
  GENERIC (
            N_BIT     : INTEGER := cNUM_BIT
          );
  PORT    (
            A         : in  signed (N_BIT-1 DOWNTO 0);
            B         : in  signed (N_BIT-1 DOWNTO 0);
            C_IN      : in  std_logic;
            S         : out signed (N_BIT-1 DOWNTO 0);
            C_OUT     : out std_logic
          );
END rca_generic;

ARCHITECTURE structural OF rca_generic IS

  SIGNAL sSUM   : std_logic_vector (N_BIT-1 DOWNTO 0);
  SIGNAL sCARRY : std_logic_vector (N_BIT DOWNTO 0);

  COMPONENT fa
    PORT  ( 
            A   : in  std_logic;
            B   : in  std_logic;
            Ci  : in  std_logic;
            S   : out std_logic;
            Co  : out std_logic
          );
  END COMPONENT;


BEGIN

        sCARRY(0)     <= C_IN;
        S             <= signed(sSUM);
        C_OUT         <= sCARRY(N_BIT);

  fa_gen : FOR i IN 1 TO N_BIT GENERATE
    fax : fa 
      PORT MAP  (
                  A   => A(i-1),
                  B   => B(i-1),
                  Ci  => sCARRY(i-1),
                  S   => sSUM(i-1),
                  Co  => sCARRY(i)
                );
  END GENERATE fa_gen;

END structural;