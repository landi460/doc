LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.constants.ALL;

ENTITY andgate2 IS
  PORT  (
          A : in  std_logic;
          B : in  std_logic;
          Y : out std_logic
        );
END ENTITY;

ARCHITECTURE behavioral OF andgate2 IS
BEGIN
  Y <= A AND B;
END ARCHITECTURE;
