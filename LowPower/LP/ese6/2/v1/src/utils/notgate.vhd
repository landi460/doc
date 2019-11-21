LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.constants.ALL;

ENTITY notgate IS
  PORT  (
          A : in  std_logic;
          Y : out std_logic
        );
END ENTITY;

ARCHITECTURE behavioral OF notgate IS
BEGIN
  Y <= NOT A;
END ARCHITECTURE;
