LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.all;

USE work.constants.ALL;

ENTITY mux21_generic IS
  GENERIC (
            N_BIT     : INTEGER := cNUM_BIT
          );
  PORT    (
            DATA_0    : in  signed (N_BIT-1 DOWNTO 0);
            DATA_1    : in  signed (N_BIT-1 DOWNTO 0);
            SEL       : in  std_logic;
            DATA_OUT  : out signed (N_BIT-1 DOWNTO 0)
          );
END ENTITY;

ARCHITECTURE structural OF mux21_generic IS
  COMPONENT andgate2 IS
    PORT  (
            A : in  std_logic;
            B : in  std_logic;
            Y : out std_logic
          );
  END COMPONENT;

  COMPONENT orgate2 IS
    PORT  (
            A : in  std_logic;
            B : in  std_logic;
            Y : out std_logic
          );
  END COMPONENT;

  COMPONENT notgate IS
    PORT  (
            A : in  std_logic;
            Y : out std_logic
          );
  END COMPONENT;

  SIGNAL sNOT_SEL             : std_logic;
  SIGNAL s_DATA_0_AND_NOT_SEL : std_logic_vector (N_BIT-1 DOWNTO 0);
  SIGNAL sDATA_1_AND_SEL      : std_logic_vector (N_BIT-1 DOWNTO 0);

BEGIN

  notselgate : notgate 
    PORT MAP  (
                A => SEL, 
                Y => sNOT_SEL
              );

  gates_gen : FOR i IN 0 TO N_BIT-1 GENERATE
    aandgatex : andgate2 
      PORT MAP  (
                  A => DATA_0(i),
                  B => sNOT_SEL,
                  Y => s_DATA_0_AND_NOT_SEL(i)
                );
    bandgatex : andgate2 
      PORT MAP  (
                  A => DATA_1(i),
                  B => SEL,
                  Y => sDATA_1_AND_SEL(i)
                );
    outgatex  : orgate2 
      PORT MAP  (
                  A => s_DATA_0_AND_NOT_SEL(i),
                  B => sDATA_1_AND_SEL(i),
                  Y => DATA_OUT(i)
                );
  END GENERATE gates_gen;

END ARCHITECTURE;
