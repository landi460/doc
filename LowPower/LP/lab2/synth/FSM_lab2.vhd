library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.std_logic_signed.all;

entity FSM is
  port ( clk: in std_logic;
         reset: in std_logic;
         S0, S1, S2, S3: out std_logic);
end entity;

architecture FSM_lab2 of FSM is
type TYPE_STATE is (sum1, sum2, sum3, sum4, sum5);
signal current_state : TYPE_STATE;
signal next_state : TYPE_STATE;

begin 
  P_lab2: process(clk, reset)
  begin
    if reset = '1' then
      current_state <= sum1;  
    elsif (clk='1' and clk'event) then
      current_state <= next_state;
    end if;
    
  end process P_lab2;  
  
 P_next_state : process(current_state)
 
begin
  case current_state is
    
  when sum1 =>
    S0 <= '0'; 
    S1 <= '0'; 
    S2 <= '0'; 
    S3 <= '0'; 
       
   next_state <= sum2;
   
   when sum2 =>
    S0 <= '1'; 
    S1 <= '0'; 
    S2 <= '1'; 
    S3 <= '0'; 
       
   next_state <= sum3;
       
   when sum3 =>
    S0 <= '1'; 
    S1 <= '0'; 
    S2 <= '1'; 
    S3 <= '1'; 
       
   next_state <= sum4;
       
       when sum4 =>
    S0 <= '1'; 
    S1 <= '1'; 
    S2 <= '0'; 
    S3 <= '1'; 
       
   next_state <= sum5;
       
       when sum5 =>
    S0 <= '0'; 
    S1 <= '1'; 
    S2 <= '0'; 
    S3 <= '1'; 
       
   next_state <= sum1;
       
       
       
end case;
end process;
end architecture;