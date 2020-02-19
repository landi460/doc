-- This combinatorial CU is part of the branch/jump management HW block.
-- It drives the selectors of the MUXes used to determine the next instruction address (i.e. the next $PC)
--
-- branchIn : asserted if the instruction is a BRANCH
-- compResult : LSB of the ALU_out signal, it is asserted if the condition of the BRANCH is verified
-- jumpIn : asserted iff the instruction is a generic JUMP
-- jumpOrBranch : asserted iff the jump/branch is taken, i.e. iff (instruction == JUMP or (instruction == BRANCH and comprResult == '1')) 


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;

ENTITY next_addr_sel_cu IS
  PORT(
    branchIn    	: IN  std_logic; 
    compResult  	: IN  std_logic; 
    jumpIn			: IN  std_logic; 
    jumpOrBranch	: OUT std_logic
    );
END ENTITY;
 
ARCHITECTURE beh OF next_addr_sel_cu IS

BEGIN
  jumpOrBranch <= jumpIn or (compResult and branchIn);
END beh;
   