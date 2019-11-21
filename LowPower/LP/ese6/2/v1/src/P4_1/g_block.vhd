LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY g_block IS
  PORT  (
          PG_L  : in  std_logic;
          G_L   : in  std_logic;
          G_R   : in  std_logic;
          G_OUT : out std_logic
        );

END ENTITY g_block;

ARCHITECTURE behavioral OF g_block IS
BEGIN  -- ARCHITECTURE behavioral
  G_OUT <= (G_L) OR (PG_L AND G_R);
END ARCHITECTURE behavioral;