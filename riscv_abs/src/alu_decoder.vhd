LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;
USE work.alu_param.all;

ENTITY alu_decoder IS
  PORT(
    opcode  : in  std_logic_vector(6 DOWNTO 0);
    funct3  : in  std_logic_vector(2 DOWNTO 0);
	funct7  : in  std_logic_vector(6 DOWNTO 0);
	alu_op  : out std_logic_vector(ALU_OP_WIDTH-1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE beh OF alu_decoder IS
BEGIN

  decode_alu: PROCESS(opcode, funct3, funct7)
	BEGIN
		CASE opcode IS
		
			WHEN RV32_LOAD => 
				alu_op <= ALU_ADD;
			WHEN RV32_STORE => 
				alu_op <= ALU_ADD;
			WHEN RV32_AUIPC =>
				alu_op <= ALU_ADD;				
			WHEN RV32_LUI => 
				alu_op <= ALU_LUI;				
			WHEN RV32_BRANCH => 
				CASE funct3 IS
					WHEN RV32I_BEQ_FUNCT3 =>
						alu_op <= ALU_SEQ;	
			        WHEN OTHERS => 
				        alu_op <= "1111";						
				END CASE;			
			WHEN RV32_OP => 
				CASE funct3 IS				
					WHEN RV32I_ADD_FUNCT3  => 
						CASE funct7 IS
							WHEN RV32I_ADD_FUNCT7 => 
							alu_op <= ALU_ADD;
							WHEN RV32I_AB_FUNCT7 => 
							alu_op <= ALU_AB;
			                WHEN OTHERS => 
				            alu_op <= "1111";								
						END CASE; 						
					WHEN RV32I_SLT_FUNCT3 =>
						alu_op <= ALU_SLT;
					WHEN RV32I_XOR_FUNCT3 =>
						alu_op <= ALU_XOR;
			        WHEN OTHERS => 
				        alu_op <= "1111";							
				END CASE;				
			WHEN RV32_OP_IMM =>				
				CASE funct3 IS				
					WHEN RV32I_ADD_FUNCT3  =>  
					    alu_op <= ALU_ADD;																								
					WHEN RV32I_SRA_FUNCT3 =>       
						CASE funct7 IS
							WHEN RV32I_SRA_FUNCT7 => 
							alu_op <= ALU_SRA;	
			                WHEN OTHERS => 
				            alu_op <= "1111";								
						END CASE; 	
					WHEN RV32I_AND_FUNCT3 =>
						alu_op <= ALU_AND;	
			        WHEN OTHERS => 
				        alu_op <= "1111";							
				END CASE;
			WHEN OTHERS => 
				alu_op <= "1111";								
				
        END CASE;				

	END PROCESS;

END ARCHITECTURE;
