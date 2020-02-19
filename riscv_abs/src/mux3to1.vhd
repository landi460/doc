LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY mux3to1 IS
    GENERIC( N : INTEGER := 8);
    PORT(
        IN00    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        IN01_10 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        IN11    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        SEL     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        OUTPUT  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );				
END ENTITY;

ARCHITECTURE struct OF mux3to1 IS

    COMPONENT mux2to1
        GENERIC( N : INTEGER := 8);
        PORT(
            IN0    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            IN1    : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            SEL    : IN  STD_LOGIC;
            OUTPUT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
            );				
    END COMPONENT;
    
    SIGNAL tmp   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SIGNAL s_sel : STD_LOGIC;
    
    BEGIN
    
        mux1 : mux2to1
            GENERIC MAP(N => N)
            PORT MAP(
                    IN0    => IN00,
                    IN1    => IN11,
                    SEL    => SEL(1),
                    OUTPUT => tmp
					);
					
        mux2 : mux2to1
            GENERIC MAP(N => N)
            PORT MAP(
                    IN0    => tmp,
                    IN1    => IN01_10,
                    SEL    => s_sel,
                    OUTPUT => OUTPUT
					);
					
        s_sel <= SEL(0) XOR SEL(1);
        
END ARCHITECTURE;
