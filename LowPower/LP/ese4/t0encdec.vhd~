library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.all;

entity t0encdec is
port (	ck : in std_logic;
	rst : in std_logic;
	A : in std_logic_vector(7 downto 0);
	B : out std_logic_vector(8 downto 0);
	C : out std_logic_vector(7 downto 0)
        );
end t0encdec;

architecture behavioral of t0encdec is

signal AOLD: std_logic_vector(7 downto 0);
signal COLD: std_logic_vector(7 downto 0);
signal CDEC: std_logic_vector(7 downto 0);
signal BSIG: std_logic_vector(7 downto 0);
signal AOLD_inc: std_logic_vector(7 downto 0);
signal INC, INC_C, C_CTR, INC_A  : std_logic;

begin


B<=INC_A &  BSIG;
C<=CDEC;

 increment: process(AOLD)
   begin
     AOLD_inc <= AOLD + 1;
   end process;

 inpt: process(ck, rst)
   begin
     if rst='1' then
       AOLD <= "00000000";
       INC_A <= '0';
     elsif ck'event and ck ='1' then
       AOLD <= A;
       INC_A <= INC;
     end if;
   end process;

 validator: process(A)
   begin
     if(AOLD_inc = A) then
       INC <= '1';
     else
       INC <= '0';
     end if;
   end process;

 encoding: process(ck, rst)
   begin
     if rst = '1' then
       BSIG <= "00000000";
     elsif ck'event and ck='1' then
       if INC = '1' then
         BSIG <= BSIG;
       elsif INC = '0' then
         BSIG <= A;
       end if;
     end if;
   end process;



 decoding: process(ck, rst)
   begin
     if rst = '1' then
       CDEC <= "00000000";
       COLD<="00000000";
       INC_C <= '0';
     elsif ck'event and ck='1' then
       INC_C<=INC_A;
       COLD<=CDEC;
       CDEC<=BSIG;
     end if;
  end process;
     
  maintain: process(INC_C,COLD,BSIG,CDEC)
    begin
      if INC_C='1' then
        COLD<=COLD+1;
      else
        COLD <= CDEC;
      end if;
   end process;

     

  end behavioral;
	
	
