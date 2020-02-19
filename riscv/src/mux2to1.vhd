LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY mux2to1 IS
    GENERIC( N : INTEGER := 8);
    PORT(
        IN0    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        IN1    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        SEL    : IN STD_LOGIC;
        OUTPUT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );				
END ENTITY;

ARCHITECTURE struct OF mux2to1 IS

    BEGIN
    
    mux : FOR i IN 0 TO N-1 GENERATE
        OUTPUT(i) <= (IN1(i) AND SEL) OR (IN0(i) AND NOT SEL);
    END GENERATE;
    
END ARCHITECTURE;
