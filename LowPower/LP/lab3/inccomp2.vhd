library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity inccomp2 is
Port(	C: out std_logic_vector(7 downto 0);
	ck: in std_logic;
	rst: in std_logic;
	INCA: in std_logic;
	INCB: in std_logic);
end inccomp2;

architecture behavioral of inccomp2 is

signal syncha, synchb: std_logic_vector(7 downto 0);

begin
	  pv1: process(ck,rst)
	  begin
           if rst ='1' then 
           C<="00000000";
           elsif ck'event and ck='0' then
if INCA='1' or INCB='1' then
if ((syncha)>(synchb)) then
C<= syncha;
else
C<=synchb;
end if ;
end if;
end if;
end process;


pv2: process(ck,rst)
begin 
if rst = '1' then
syncha<="00000000";
elsif ck'event and ck='1' then
if INCA='1' then 
syncha<=syncha+1;
end if;
end if;
end process;

pv3: process(ck,rst)
begin 
if rst = '1' then
synchb<="00000000";
elsif ck'event and ck='1' then
if INCB='1' then 
synchb<=synchb+1;
end if;
end if;
end process;


end behavioral;
