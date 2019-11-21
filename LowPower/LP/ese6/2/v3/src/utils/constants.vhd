LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;

PACKAGE constants IS
  CONSTANT cNUM_BIT      : INTEGER := 32;

  -- length of a carry select block
  CONSTANT cNUM_CARRY    : INTEGER := 4;

  CONSTANT cNUM_BIT_LOG2    : INTEGER := 5;
  CONSTANT cNUM_CARRY_LOG2    : INTEGER := 2;

  TYPE signal_vector_t IS ARRAY (0 TO cNUM_BIT_LOG2) OF STD_LOGIC_VECTOR (cNUM_BIT DOWNTO 0);

       -- TYPE charvector IS ARRAY (n_bit DOWNTO 0) OF CHARACTER;
      --  TYPE charmatrix IS ARRAY (0 TO n_bit_log2) OF charvector;
      --  TYPE intvector IS ARRAY (n_bit DOWNTO 0) OF INTEGER;
      --  TYPE intmatrix IS ARRAY (0 TO n_bit_log2) OF intvector;
END constants;
