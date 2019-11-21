library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity t0encdec is
port (	ck : in std_logic;
	rst : in std_logic;
	A : in std_logic_vector(7 downto 0);
	B : out std_logic_vector(8 downto 0);
	C : buffer std_logic_vector(7 downto 0));
end t0encdec;

architecture behavioral of t0encdec is

signal BTMP,C_tmp, Aold,AoldInc, inc: std_logic_vector(7 downto 0);
signal buss: std_logic_vector(7 downto 0);
signal out_inc : std_logic ;


begin 
	
	pRegIn : process(ck, rst)
	begin
	  if rst ='1' then
    aold <="00000000";
	  elsif ck'event and ck='1' then
	       Aold <= A;
	  end if;
        end process;

   AoldInc  <= std_logic_vector ( unsigned( Aold ) + to_unsigned( 1,8) );
   
   out_inc <= ( inc(0) AND inc(1) AND inc(2) AND inc(3) AND inc(4) AND inc(5) AND inc(6) AND inc(7) );



    pBuss : process(A,rst)
	begin
	  if rst ='1' then
    inc <="00000000";
  end if;
	    for I in 0 to 7 loop
	      inc(I) <= A(I) xnor AoldINc(I); 
 	    end loop;

        end process;

   pck : process(out_inc,ck,rst)
	begin
	  if rst ='1' then
    buss <="00000000";
    elsif out_inc<= '0' then
        buss <= A;
      end if;
     end process;
        
    B <= out_inc & buss;

----decoder

  pDEc: process(ck, rst) 
   	begin
if rst ='1' then
    C <="00000000";
      elsif ck'event and ck='1' then
        if out_inc= '0'then
             C <= buss;
         elsif out_inc ='1' then
            C  <= std_logic_vector ( unsigned( C) + to_unsigned( 1, 8) );
         END IF;
     end if;
end process;


end architecture ;

         
         
   


