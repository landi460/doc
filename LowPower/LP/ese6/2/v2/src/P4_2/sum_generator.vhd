LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.all;

USE work.constants.ALL;

ENTITY sum_generator IS
  GENERIC (
            N_BIT   : integer := cNUM_BIT;
            CARRY   : integer := cNUM_CARRY
          );
  PORT    (
            A       : in  signed (N_BIT-1 DOWNTO 0);
            B       : in  signed (N_BIT-1 DOWNTO 0);
            C_IN    : in  std_logic_vector (N_BIT/CARRY DOWNTO 0);
            SUM     : out signed (N_BIT-1 DOWNTO 0)
          );

END ENTITY sum_generator;

ARCHITECTURE structural OF sum_generator IS
  COMPONENT carry_select_block IS
    GENERIC (
              N_BIT : integer
            );
    PORT    (
              A     : in  signed (N_BIT-1 DOWNTO 0);
              B     : in  signed (N_BIT-1 DOWNTO 0);
              C_SEL : in  std_logic;
              SUM   : out signed (N_BIT-1 DOWNTO 0)
            );
  END COMPONENT carry_select_block;

BEGIN  -- ARCHITECTURE structural

  csb_gen : FOR i IN 0 TO N_BIT/CARRY-2 GENERATE
    csbx : carry_select_block
      GENERIC MAP (
                    N_BIT => CARRY
                  )
      PORT MAP    (
                    A     => A((i+1)*CARRY-1 DOWNTO (i)*CARRY),
                    B     => B((i+1)*CARRY-1 DOWNTO (i)*CARRY),
                    C_SEL => C_IN(i),
                    SUM   => SUM((i+1)*CARRY-1 DOWNTO (i)*CARRY)
                  );
  END GENERATE csb_gen;

  csb_N : carry_select_block
  GENERIC MAP (
                N_BIT => CARRY
              )
  PORT MAP    (
                A     => A((N_BIT/CARRY)*CARRY-1 DOWNTO (N_BIT/CARRY-1)*CARRY),
                B     => B((N_BIT/CARRY)*CARRY-1 DOWNTO (N_BIT/CARRY-1)*CARRY),
                C_SEL => C_IN(N_BIT/CARRY-2),
                SUM   => SUM((N_BIT/CARRY)*CARRY-1 DOWNTO (N_BIT/CARRY-1)*CARRY)
              );

END ARCHITECTURE structural;