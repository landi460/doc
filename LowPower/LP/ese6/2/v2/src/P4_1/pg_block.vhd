LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pg_block IS
  PORT  (
          PG_L   : in  std_logic;
          G_L    : in  std_logic;
          PG_R   : in  std_logic;
          G_R    : in  std_logic;
          PG_OUT : out std_logic;
          G_OUT  : out std_logic
        );
END ENTITY pg_block;

ARCHITECTURE behavioral OF pg_block IS

BEGIN  -- ARCHITECTURE behavioral
  G_OUT  <= (G_L) OR (PG_L AND G_R);
  PG_OUT <= PG_L AND PG_R;
END ARCHITECTURE behavioral;