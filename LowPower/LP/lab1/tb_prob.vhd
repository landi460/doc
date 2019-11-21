library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned 
use ieee.std_logic_arith.all;

entity TBPROB is 
end TBPROB; 

architecture TEST of TBPROB is

  component LFSR16 
                     port (CLK, RESET, LD, EN : in std_logic; 
                           DIN : in std_logic_vector(15 downto 0); 
                           PRN : out std_logic_vector(15 downto 0); 
                           ZERO_D : out std_logic);
  end component;
  constant Period: time := 1 ns; -- Clock period (1 GHz)
  signal CLK : std_logic :='0';
  signal RESET,LD,EN,ZERO_D : std_logic;
  signal DIN, DOUT : std_logic_vector(15 downto 0);

  signal IVA, IVY, ANDA, ANDB, ANDY, ORA, ORB, ORY, XA, XB, XY : std_logic;

Begin

-- Define the Inverter gate
  -- input
  IVA <= DOUT(0);
  -- ouput
  IVY <= not(IVA) after 0.1 ns;

-- Define the And gate
  -- inputs
  ANDA <= DOUT(0);
  ANDB <= DOUT(15);
  -- ouput
  ANDY <= ANDA and ANDB after 0.1 ns;

-- Define the Or gate
  -- inputs
  ORA <= DOUT(0);
  ORB <= DOUT(15);
  -- ouput
  ORY <= ORA or ORB after 0.1 ns;


-- Define the Xor gate
  -- inputs
  XA <= DOUT(0);
  XB <= DOUT(15);
  -- ouput
  XY <= XA xor XB after 0.1 ns;



-- Instanciate the LFSR
  ULFSR: LFSR16 port map (CLK=>CLK, RESET=>RESET, LD=>LD, EN=>EN, 
                        DIN=>DIN,PRN=>DOUT, ZERO_D=>ZERO_D);
-- Create the permanent Clock and the Reset pulse
  CLK <= not CLK after Period/2;
  RESET <= '1', '0' after Period;
-- Open file, make a load, and wait for a timeout in case of design error.
  STIMULUS1: process
  begin
    DIN <= "0000000000000001";
    EN <='1';
    LD <='1';
    wait for 2 * PERIOD;
    LD <='0';
    wait for (65600 * PERIOD);
-- we should never reach this timeout (LFSR should cycle before)
--    report "LFSR Error : failed to cycle !" severity failure;
  end process STIMULUS1;

end TEST;

