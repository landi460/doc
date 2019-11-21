LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.all;

USE work.constants.ALL;


ENTITY carry_generator IS
  GENERIC (
            N_BIT   : integer := cNUM_BIT;
            CARRY   : integer := cNUM_CARRY
          );
  PORT    (
            A       : in  signed (N_BIT-1 DOWNTO 0);
            B       : in  signed (N_BIT-1 DOWNTO 0);
            C_IN_0  : in  std_logic;
            C_OUT   : out std_logic_vector (N_BIT/CARRY DOWNTO 0)
          );

END ENTITY carry_generator;

ARCHITECTURE structural OF carry_generator IS
  COMPONENT pg_network IS
    GENERIC (
              N_BIT : INTEGER
            );
    PORT    (
              A     : in  signed (N_BIT-1 DOWNTO 0);
              B     : in  signed (N_BIT-1 DOWNTO 0);
              PG    : out std_logic_vector (N_BIT-1 DOWNTO 0);
              G     : out std_logic_vector (N_BIT-1 DOWNTO 0)
            );
  END COMPONENT pg_network;

  COMPONENT carry_logic_network IS
    GENERIC (
              N_BIT   : INTEGER;
              CARRY   : INTEGER
            );
    PORT    (
              PG      : in  std_logic_vector (N_BIT-1 DOWNTO 0);
              G       : in  std_logic_vector (N_BIT-1 DOWNTO 0);
              C_IN_0  : in  std_logic;
              C_OUT   : out std_logic_vector (N_BIT/CARRY DOWNTO 0)
            );
  END COMPONENT carry_logic_network;

  SIGNAL sPG_0  : std_logic_vector (N_BIT-1 DOWNTO 0);
  SIGNAL sG_0   : std_logic_vector (N_BIT-1 DOWNTO 0);

BEGIN  -- ARCHITECTURE structural
  pg_net : pg_network
    GENERIC MAP (
                  N_BIT => N_BIT
                )
    PORT MAP    (
                  A  => A,
                  B  => B,
                  PG => sPG_0,
                  G  => sG_0
                );

  cl_net : carry_logic_network
    GENERIC MAP (
                  N_BIT => N_BIT,
                  CARRY => CARRY
                )
    PORT MAP    (
                  PG     => sPG_0,
                  G      => sG_0,
                  C_IN_0 => C_IN_0,
                  C_OUT  => C_OUT
                );

END ARCHITECTURE structural;