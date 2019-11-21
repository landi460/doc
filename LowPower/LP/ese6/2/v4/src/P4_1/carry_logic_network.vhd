LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.math_real.ALL;
USE work.constants.ALL;

ENTITY carry_logic_network IS
  GENERIC (
            N_BIT         : integer := cNUM_BIT;
            CARRY         : integer := cNUM_CARRY;
            N_BIT_LOG2    : integer := cNUM_BIT_LOG2;
            CARRY_LOG2    : integer := cNUM_CARRY_LOG2
          );
  PORT    (
            PG            : in  std_logic_vector (N_BIT-1 DOWNTO 0);
            G             : in  std_logic_vector (N_BIT-1 DOWNTO 0);
            C_IN_0        : in  std_logic;
            C_OUT         : out std_logic_vector (N_BIT/CARRY DOWNTO 0)
          );
END ENTITY carry_logic_network;


ARCHITECTURE structural OF carry_logic_network IS

  COMPONENT g_block IS
    PORT  (
            PG_L  : in  std_logic;
            G_L   : in  std_logic;
            G_R   : in  std_logic;
            G_OUT : out std_logic
          );
  END COMPONENT g_block;

  COMPONENT pg_block IS
    PORT  (
            PG_L   : in  std_logic;
            G_L    : in  std_logic;
            PG_R   : in  std_logic;
            G_R    : in  std_logic;
            PG_OUT : out std_logic;
            G_OUT  : out std_logic
          );
  END COMPONENT pg_block;

  -- return # of blocks for the bintree LEVEL
  FUNCTION bintree_blocks ( 
      N_BIT_LOG2 : integer;
      LEVEL      : integer
    )
    RETURN integer IS
  BEGIN  -- FUNCTION bintree_blocks
    RETURN 2**(N_BIT_LOG2-LEVEL);
  END FUNCTION bintree_blocks;

  -- purpose: return if the block is a g block (bintree only)
  FUNCTION bintree_is_g (
      INDEX : integer
    )
    RETURN boolean IS
  BEGIN  -- FUNCTION bintree_is_g
    IF INDEX = 1 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END FUNCTION bintree_is_g;

  -- purpose: return left INDEX of bintree LEVEL
  FUNCTION bintree_left (
      LEVEL : integer;
      INDEX : integer
    )
    RETURN integer IS
  BEGIN  -- FUNCTION bintree_left
    RETURN INDEX*2**LEVEL;
  END FUNCTION bintree_left;

  -- purpose: return right INDEX of bintree LEVEL
  FUNCTION bintree_right (
      LEVEL : integer;
      INDEX : integer
    )
    RETURN integer IS
  BEGIN  -- FUNCTION bintree_right
    RETURN bintree_left(LEVEL, INDEX)-2**(LEVEL-1);
  END FUNCTION bintree_right;

  -- purpose: return # of blocks for bintable LEVEL
  FUNCTION bintable_blocks (
      N_BIT_LOG2 : integer;
      CARRY_LOG2 : integer
    )
    RETURN integer IS
  BEGIN  -- FUNCTION bintable_blocks
    RETURN 2**(N_BIT_LOG2-CARRY_LOG2);
  END FUNCTION bintable_blocks;

  -- purpose: return if it's needed a block
  FUNCTION bintable_valid_block (
      LEVEL      : integer;
      INDEX      : integer;
      CARRY_LOG2 : integer;
      N_BIT_LOG2 : integer
    )
    RETURN BOOLEAN IS
  BEGIN  -- FUNCTION bintable_valid_block
    IF (INDEX-1) MOD 2**(LEVEL-CARRY_LOG2) >= 2**(LEVEL-CARRY_LOG2-1) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END FUNCTION bintable_valid_block;

  -- purpose: return if the block is a g block (bintable only)
  FUNCTION bintable_is_g (
      LEVEL      : integer;
      INDEX      : integer;
      CARRY_LOG2 : integer;
      N_BIT_LOG2 : integer
    )
    RETURN BOOLEAN IS
  BEGIN  -- FUNCTION bintable_is_g
    IF (INDEX-1) < 2**(LEVEL-CARRY_LOG2) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END FUNCTION bintable_is_g;

  -- purpose: return left INDEX of bintable LEVEL
  FUNCTION bintable_left (
      CARRY : integer;
      INDEX : integer
    )
    RETURN integer IS
  BEGIN  -- FUNCTION bintable_left
    RETURN INDEX*CARRY;
  END FUNCTION bintable_left;


  -- purpose: return offset for right INDEX of bintable LEVEL
  FUNCTION bintable_right_offset (
      CARRY      : integer;
      CARRY_LOG2 : integer;
      LEVEL      : integer;
      INDEX      : integer
    )
    RETURN integer IS
  BEGIN
    RETURN (INDEX-1) MOD 2**(LEVEL-CARRY_LOG2-1)+1;
  END bintable_right_offset;

  -- purpose: return right INDEX of bintable LEVEL
  FUNCTION bintable_right (
      CARRY      : integer;
      CARRY_LOG2 : integer;
      LEVEL      : integer;
      INDEX      : integer
    )
    RETURN integer IS
  BEGIN
    RETURN bintable_left(CARRY, INDEX)-CARRY*bintable_right_offset(CARRY, CARRY_LOG2, LEVEL, INDEX);
  END bintable_right;

  SIGNAL PG_MATRIX : signal_vector_t;
  SIGNAL G_MATRIX  : signal_vector_t;


BEGIN  -- ARCHITECTURE structural

  C_OUT(0) <= C_IN_0;

  CARRY_outs : FOR blck IN 1 TO bintable_blocks(N_BIT_LOG2, CARRY_LOG2) GENERATE
    C_OUT(blck) <= G_MATRIX(N_BIT_LOG2)(bintable_left(CARRY, blck));
  END GENERATE;

  g_block0 : g_block
    PORT MAP  (
                PG_L  => PG(0),
                G_L   => G(0),
                G_R   => C_IN_0,
                G_OUT => G_MATRIX(0)(1)
              );
  PG_MATRIX(0)(1)   <= PG(1);

  pg_lev_0 : FOR blck IN 2 TO N_BIT GENERATE
    PG_MATRIX(0)(blck)   <= PG(blck-1);
    G_MATRIX(0)(blck)    <= G(blck-1);
  END GENERATE pg_lev_0;

  bintree : FOR LEVEL IN 1 TO CARRY_LOG2 GENERATE
    bintree_blcks : FOR blck IN 1 TO bintree_blocks(N_BIT_LOG2, LEVEL) GENERATE
      bintree_g_block : IF bintree_is_g(blck) GENERATE
        g_blockx : g_block
          PORT MAP  (
                      PG_L  => PG_MATRIX  (LEVEL-1)   (bintree_left(LEVEL, blck)),
                      G_L   => G_MATRIX   (LEVEL-1)   (bintree_left(LEVEL, blck)),
                      G_R   => G_MATRIX   (LEVEL-1)   (bintree_right(LEVEL, blck)),
                      G_OUT => G_MATRIX   (LEVEL)     (bintree_left(LEVEL, blck))
                    );
      END GENERATE bintree_g_block;
      bintree_pg_block : IF NOT bintree_is_g(blck) GENERATE
        pg_blockx : pg_block
          PORT MAP  (
                      PG_L   => PG_MATRIX   (LEVEL-1)   (bintree_left(LEVEL, blck)),
                      G_L    => G_MATRIX    (LEVEL-1)   (bintree_left(LEVEL, blck)),
                      PG_R   => PG_MATRIX   (LEVEL-1)   (bintree_right(LEVEL, blck)),
                      G_R    => G_MATRIX    (LEVEL-1)   (bintree_right(LEVEL, blck)),
                      PG_OUT => PG_MATRIX   (LEVEL)     (bintree_left(LEVEL, blck)),
                      G_OUT  => G_MATRIX    (LEVEL)     (bintree_left(LEVEL, blck))
                    );
      END GENERATE bintree_pg_block;
    END GENERATE bintree_blcks;
  END GENERATE bintree;

  bintable : FOR LEVEL IN CARRY_LOG2+1 TO N_BIT_LOG2 GENERATE
    bintable_blcks : FOR blck IN 1 TO bintable_blocks(N_BIT_LOG2, CARRY_LOG2) GENERATE
      bintable_valid_blck : IF bintable_valid_block(LEVEL, blck, CARRY_LOG2, N_BIT_LOG2) GENERATE
        bintable_g_block : IF bintable_is_g(LEVEL, blck, CARRY_LOG2, N_BIT_LOG2) GENERATE
          g_blockx : g_block
            PORT MAP  (
                        PG_L  => PG_MATRIX    (LEVEL-1)   (bintable_left(CARRY, blck)),
                        G_L   => G_MATRIX     (LEVEL-1)   (bintable_left(CARRY, blck)),
                        G_R   => G_MATRIX     (LEVEL-1)   (bintable_right(CARRY, CARRY_LOG2, LEVEL, blck)),
                        G_OUT => G_MATRIX     (LEVEL)     (bintable_left(CARRY, blck))
                      );
        END GENERATE bintable_g_block;
        bintable_pg_block : IF NOT bintable_is_g(LEVEL, blck, CARRY_LOG2, N_BIT_LOG2) GENERATE
          pg_blockx : pg_block
            PORT MAP  (
                        PG_L   => PG_MATRIX   (LEVEL-1)   (bintable_left(CARRY, blck)),
                        G_L    => G_MATRIX    (LEVEL-1)   (bintable_left(CARRY, blck)),
                        PG_R   => PG_MATRIX   (LEVEL-1)   (bintable_right(CARRY, CARRY_LOG2, LEVEL, blck)),
                        G_R    => G_MATRIX    (LEVEL-1)   (bintable_right(CARRY, CARRY_LOG2, LEVEL, blck)),
                        PG_OUT => PG_MATRIX   (LEVEL)     (bintable_left(CARRY, blck)),
                        G_OUT  => G_MATRIX    (LEVEL)     (bintable_left(CARRY, blck))
                      );
        END GENERATE bintable_pg_block;
      END GENERATE bintable_valid_blck;
      bintable_redirect : IF NOT bintable_valid_block(LEVEL, blck, CARRY_LOG2, N_BIT_LOG2) GENERATE
        PG_MATRIX   (LEVEL)   (bintable_left(CARRY, blck))  <= PG_MATRIX    (LEVEL-1)   (bintable_left(CARRY, blck));
        G_MATRIX    (LEVEL)   (bintable_left(CARRY, blck))  <= G_MATRIX     (LEVEL-1)   (bintable_left(CARRY, blck));
      END GENERATE bintable_redirect;
    END GENERATE bintable_blcks;
  END GENERATE bintable;
END ARCHITECTURE structural;
