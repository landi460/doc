LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

USE work.param.all;
USE work.alu_param.all;

ENTITY main IS
  PORT(
	clk         : IN  std_logic; 
	rst_n       : IN  std_logic; 
    I_mem_out   : IN  std_logic_vector(INST_WIDTH-1 DOWNTO 0); 
    D_mem_out   : IN  std_logic_vector(INST_WIDTH-1 DOWNTO 0); 
    I_mem_addr  : OUT std_logic_vector(ADDR_WIDTH-1 DOWNTO 0); 
    I_mem_read  : OUT std_logic; 
    D_mem_addr  : OUT std_logic_vector(ADDR_WIDTH-1 DOWNTO 0); 	
    D_mem_in    : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0); 	
    D_mem_read  : OUT std_logic; 
    D_mem_write	: OUT std_logic
    );
END ENTITY;
 
ARCHITECTURE beh OF main IS

COMPONENT regn IS
GENERIC ( N : natural := 4 );
PORT ( 
		d 		: IN std_logic_vector(N-1 DOWNTO 0);
		clk		: IN std_logic; 
		rst_n	: IN std_logic;
		en 	    : IN std_logic; 
		q 		: OUT std_logic_vector(N-1 DOWNTO 0)
	 );
END COMPONENT;

COMPONENT mux2to1 IS
    GENERIC( N : INTEGER := 8);
    PORT(
        IN0    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        IN1    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        SEL    : IN STD_LOGIC;
        OUTPUT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );					
END COMPONENT;

COMPONENT mux3to1 IS
    GENERIC( N : INTEGER := 8);
    PORT(
        IN00    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        IN01_10 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        IN11    : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        SEL     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        OUTPUT  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );					
END COMPONENT;

COMPONENT alu IS
  PORT(
    a, b     : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0); 
    alu_op   : IN  std_logic_vector(ALU_OP_WIDTH-1 DOWNTO 0); 
    output   : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT alu_decoder IS
  PORT(
    opcode  : in  std_logic_vector(6 DOWNTO 0);
    funct3  : in  std_logic_vector(2 DOWNTO 0);
	funct7  : in  std_logic_vector(6 DOWNTO 0);
	alu_op  : out std_logic_vector(ALU_OP_WIDTH-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT forwarding_unit IS
  PORT(
    ID_EX_Rs1       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    ID_EX_Rs2       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_Rs1      : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_Rs2      : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_Rd       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    MEM_WB_Rd       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    EX_MEM_RegWrite : IN  std_logic;
    EX_MEM_MemWrite : IN  std_logic;
    MEM_WB_RegWrite : IN  std_logic;
    MEM_WB_MemToReg : IN  std_logic;
    fwd_a           : OUT std_logic_vector(1 DOWNTO 0);
    fwd_b           : OUT std_logic_vector(1 DOWNTO 0);
    fwd_Wrt_data    : OUT std_logic;
    fwd_Wrt_addr    : OUT std_logic
    );
END COMPONENT;

COMPONENT hazard_det_unit IS
  PORT(
    ID_EX_Rd        : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    IF_ID_Rs1       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    IF_ID_Rs2       : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0); 
    ID_EX_memRead   : IN  std_logic;
    IF_ID_memWrite  : IN  std_logic;
    ControlHaz      : IN  std_logic;	
    stall_n         : OUT std_logic;
    flush_ID_EX     : OUT std_logic;
    flush_IFIDEXMEM : OUT std_logic
    );
END COMPONENT;

COMPONENT imm_gen IS
  PORT(
    inst        : IN  std_logic_vector(INST_WIDTH-1 DOWNTO 0); 
    inst_type   : IN  std_logic_vector(2 DOWNTO 0); 
    output      : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT reg_file IS
  PORT(
    clk         : IN  std_logic; 	
    rst_n       : IN  std_logic; 	
    writeEn     : IN  std_logic;	
    writeAddr   : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);	
    input       : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0);	
    readAddr0   : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
    readAddr1   : IN  std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);		
    out0        : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0);
    out1        : OUT std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT cu IS
  PORT (
  instruction            : IN  std_logic_vector(INST_WIDTH-1 DOWNTO 0);
  imm_type               : OUT std_logic_vector(2 DOWNTO 0);
  D_MEM_write            : OUT std_logic;
  D_MEM_read             : OUT std_logic;
  RF_write               : OUT std_logic;
  branch                 : OUT std_logic;
  jump                   : OUT std_logic;
  RS1_PC_ALU_SRC_MUX_sel : OUT std_logic;
  RS2_IMM_ALU_SRC_MUX_sel: OUT std_logic;
  DMEM_ALU_WB_MUX_sel    : OUT std_logic
  );
END COMPONENT;

COMPONENT next_addr_sel_cu IS
  PORT(
    branchIn    	: IN  std_logic; 
    compResult  	: IN  std_logic; 
    jumpIn			: IN  std_logic; 
    jumpOrBranch	: OUT std_logic
    );
END COMPONENT;

SIGNAL PC_mux_out               : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL PC_out                   : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL PC_adder_out             : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL IF_ID_PC                 : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL IF_ID_next_PC            : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL IMEM_ADDR_MUX_out        : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_PC                 : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_nextPC             : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_nextPC           : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_jumpAddr         : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL BR_JAL_ADDER_out         : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL DMEM_WB_next_PC          : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL DMEM_ADDR_FWD_ADDER_out  : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);
SIGNAL DMEM_ADDR_FWD_MUX_out    : std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);

SIGNAL CU_RF_write                : std_logic;
SIGNAL CU_D_MEM_write             : std_logic;
SIGNAL CU_D_MEM_read              : std_logic;
SIGNAL CU_RS1_PC_ALU_SRC_MUX_sel  : std_logic;
SIGNAL CU_RS2_IMM_ALU_SRC_MUX_sel : std_logic;
SIGNAL CU_DMEM_ALU_WB_MUX_sel     : std_logic;
SIGNAL CU_jump                    : std_logic;
SIGNAL CU_branch                  : std_logic;
SIGNAL CU_immType                 : std_logic_vector (IMMEDIATE_SELECTION_WIDTH-1 DOWNTO 0);

SIGNAL HDU_STALL                  : std_logic;
SIGNAL HDU_FLUSH_IDEX             : std_logic;
SIGNAL HDU_FLUSH_IFID_EXMEM       : std_logic;

SIGNAL IF_ID_FLUSH_FF_q              : std_logic;
SIGNAL NEXT_ADDR_SEL_CU_jumpOrBranch : std_logic;
SIGNAL FWU_fwdWriteData              : std_logic;
SIGNAL FWU_fwdWriteAddr              : std_logic;

SIGNAL JUMP_WB_MUX_out        : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL RF_dataOut0            : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL RF_dataOut1            : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL IMM_GEN_IMM            : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_IMM              : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_IMM            : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_dataOut0         : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_dataOut1         : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_WB_aluOut      : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL DMEM_DATA_FWD_MUX_out  : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL DMEM_ALU_WB_MUX_out    : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL RS1_ALU_FWD_MUX_out    : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL RS2_ALU_FWD_MUX_out    : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL RS1_PC_ALU_SRC_MUX_out : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL RS2_IMM_ALU_SRC_MUX_out: std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL ALU_out                : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_memDataIn      : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);
SIGNAL DMEM_WB_aluOut         : std_logic_vector (WORD_WIDTH-1 DOWNTO 0);

SIGNAL ID_EX_RS2                : std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_RS1                : std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_RD                 : std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_RS1              : std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_RS2              : std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_RD               : std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);
SIGNAL DMEM_WB_RD               : std_logic_vector(RF_ADDR_WIDTH-1 DOWNTO 0);

SIGNAL IF_ID_FLUSH_MUX_out    : std_logic_vector (INST_WIDTH-1 DOWNTO 0);

SIGNAL DMEM_WB_controls       : std_logic_vector (DMEMWB_CTRL_WIDTH-1 DOWNTO 0);

SIGNAL ALU_DECODER_ctl        : std_logic_vector (ALU_OP_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_aluCtl           : std_logic_vector (ALU_OP_WIDTH-1 DOWNTO 0);

SIGNAL ID_EX_controls         : std_logic_vector (IDEX_CTRL_WIDTH-1 DOWNTO 0);
SIGNAL ID_EX_FLUSH_MUX_out    : std_logic_vector (IDEX_CTRL_WIDTH-1 DOWNTO 0);

SIGNAL EX_DMEM_FLUSH_MUX_out  : std_logic_vector (EXDMEM_CTRL_WIDTH-1 DOWNTO 0);
SIGNAL EX_DMEM_controls       : std_logic_vector (EXDMEM_CTRL_WIDTH-1 DOWNTO 0);

SIGNAL FWU_fwdA               : std_logic_vector(1 DOWNTO 0);
SIGNAL FWU_fwdB               : std_logic_vector(1 DOWNTO 0);


BEGIN
-- IF Stage  
 PC:	regn GENERIC MAP (N => ADDR_WIDTH)

		    PORT MAP(
				d 	    => PC_mux_out,
				clk     => clk,		
				rst_n	=> rst_n,   
				en 	    => HDU_STALL,   
				q 	    => PC_out			   
		             );
					 
 -- Next_PC_adder
 PC_adder_out <= PC_out + 4;
	
 PC_mux:	mux2to1 GENERIC MAP (N => ADDR_WIDTH)

		    PORT MAP(		
				IN0    => PC_adder_out,
				IN1    => EX_DMEM_jumpAddr,		
				SEL	   => NEXT_ADDR_SEL_CU_jumpOrBranch,				
				OUTPUT => PC_mux_out	   
		             );

 IF_ID_REG:	regn GENERIC MAP (N => 2 * ADDR_WIDTH)

		    PORT MAP(
				d(2*ADDR_WIDTH-1 DOWNTO ADDR_WIDTH) 	=> PC_adder_out, 
				d(ADDR_WIDTH-1 DOWNTO 0) 	            => PC_out,   
				clk                                     => clk,		
				rst_n	                                => rst_n,   
				en 	                                    => HDU_STALL,   
				q(2*ADDR_WIDTH-1 DOWNTO ADDR_WIDTH) 	=> IF_ID_next_PC,
				q(ADDR_WIDTH-1 DOWNTO 0)                => IF_ID_PC			   
		             );
					 
 IMEM_ADDR_MUX:	mux2to1 GENERIC MAP (N => ADDR_WIDTH)

		    PORT MAP(		
				IN0    => IF_ID_PC,
				IN1    => PC_out,		
				SEL	   => HDU_STALL,  
				OUTPUT => IMEM_ADDR_MUX_out		   
		             );

--  I_MEM interface
    I_mem_read <= '1';
    I_mem_addr <= IMEM_ADDR_MUX_out;

--  ID stage 

 IF_ID_FLUSH_MUX:	mux2to1 GENERIC MAP (N => INST_WIDTH)

		    PORT MAP(		
				IN0    => I_mem_out,
			    IN1    => RV_NOP2,		
				SEL	   => IF_ID_FLUSH_FF_q,   
				OUTPUT => IF_ID_FLUSH_MUX_out			   
		             );
					 
-- IF ID FLUSH_FF	
PROCESS(clk, rst_n)
BEGIN
IF rst_n = '0' THEN

	IF_ID_FLUSH_FF_q <= '1';

ELSIF clk'event and clk='1' and rst_n = '1' THEN
	
	IF_ID_FLUSH_FF_q <= HDU_FLUSH_IFID_EXMEM;

END IF;
END PROCESS; 
	
-- RF	
rf:   reg_file 
  PORT MAP(
		clk       => clk, 	
		rst_n     => rst_n, 	
        writeEn   => DMEM_WB_controls(0),	
        writeAddr => DMEM_WB_RD,	
        input     => JUMP_WB_MUX_out,	
        readAddr0 => IF_ID_FLUSH_MUX_out(RV32I_RS1_START+RF_ADDR_WIDTH-1 DOWNTO RV32I_RS1_START),
        readAddr1 => IF_ID_FLUSH_MUX_out(RV32I_RS2_START+RF_ADDR_WIDTH-1 DOWNTO RV32I_RS2_START),  		
		out0      => RF_dataOut0,	
		out1      => RF_dataOut1	
		);

-- IMM_GEN 
imm_gener: imm_gen
  PORT MAP(
        inst        => IF_ID_FLUSH_MUX_out, 
        inst_type   => CU_immType, 
        output      => IMM_GEN_IMM
           );			 

alu_dec: alu_decoder
  PORT MAP(
    opcode  => IF_ID_FLUSH_MUX_out(RV32I_OPCODE_START+RV32I_OPCODE_WIDTH-1 DOWNTO RV32I_OPCODE_START),
    funct3  => IF_ID_FLUSH_MUX_out(RV32I_FUNCT3_START+RV32I_FUNCT3_WIDTH-1 DOWNTO RV32I_FUNCT3_START),
	funct7  => IF_ID_FLUSH_MUX_out(RV32I_FUNCT7_START+RV32I_FUNCT7_WIDTH-1 DOWNTO RV32I_FUNCT7_START),
	alu_op  => ALU_DECODER_ctl
	);
	
 ID_EX_FLUSH_MUX:	mux2to1 GENERIC MAP (N => IDEX_CTRL_WIDTH)

		    PORT MAP(		
				IN0(IDEX_CTRL_WIDTH-1)    => CU_RS1_PC_ALU_SRC_MUX_sel, 
				IN0(IDEX_CTRL_WIDTH-2)    => CU_RS2_IMM_ALU_SRC_MUX_sel, 
				IN0(IDEX_CTRL_WIDTH-3)    => CU_branch, 
				IN0(IDEX_CTRL_WIDTH-4)    => CU_jump, 
				IN0(IDEX_CTRL_WIDTH-5)    => CU_D_MEM_read, 
				IN0(IDEX_CTRL_WIDTH-6)    => CU_D_MEM_write, 
				IN0(IDEX_CTRL_WIDTH-7)    => CU_DMEM_ALU_WB_MUX_sel, 
				IN0(IDEX_CTRL_WIDTH-8)    => CU_RF_write, 
				IN1                       => (others => '0'),		
				SEL	                      => IF_ID_FLUSH_FF_q,   
				OUTPUT                    => ID_EX_FLUSH_MUX_out			   
		             );

 ID_EX_REG:	regn GENERIC MAP (N => 3*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)

		    PORT MAP(
				d(3*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH) 	=> IF_ID_FLUSH_MUX_out(RV32I_RS2_START+RF_ADDR_WIDTH-1 DOWNTO RV32I_RS2_START), 
				d(2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH) 	    => IF_ID_FLUSH_MUX_out(RV32I_RS1_START+RF_ADDR_WIDTH-1 DOWNTO RV32I_RS1_START),
				d(RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH) 	                    => IF_ID_FLUSH_MUX_out(RV32I_RD_START+RF_ADDR_WIDTH-1 DOWNTO RV32I_RD_START),
				d(2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                        => IF_ID_next_PC,
				d(ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                                        => IF_ID_PC, 
				d(3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 2*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                                                    => IMM_GEN_IMM,
				d(2*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                                                        => RF_dataOut1, 
				d(WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO ALU_OP_WIDTH +IDEX_CTRL_WIDTH)		                                                                                => RF_dataOut0,
				d(ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO IDEX_CTRL_WIDTH)	                                                                                                                => ALU_DECODER_ctl,
				d(IDEX_CTRL_WIDTH-1 DOWNTO 0)		                                                                                                                                        => ID_EX_FLUSH_MUX_out,
				clk                                                                                                                                                                         => clk,		
				rst_n	                                                                                                                                                                    => rst_n,   
				en                                                                                                                                                                        	=> '1',  
				q(3*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH) 	=> ID_EX_RS2, 
				q(2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH) 	    => ID_EX_RS1,
				q(RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH) 	                    => ID_EX_RD,
				q(2*ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                        => ID_EX_nextPC,
				q(ADDR_WIDTH + 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                                        => ID_EX_PC, 
				q(3*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO 2*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                                                    => ID_EX_IMM,
				q(2*WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH)	                                                                        => ID_EX_dataOut1, 
				q(WORD_WIDTH + ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO ALU_OP_WIDTH +IDEX_CTRL_WIDTH)		                                                                                => ID_EX_dataOut0,
				q(ALU_OP_WIDTH +IDEX_CTRL_WIDTH-1 DOWNTO IDEX_CTRL_WIDTH)	                                                                                                                => ID_EX_aluCtl,
				q(IDEX_CTRL_WIDTH-1 DOWNTO 0)					                                                                                                                            => ID_EX_controls		   
		             );

-- EX stage

EX_DMEM_FLUSH_MUX: mux2to1 GENERIC MAP (N => EXDMEM_CTRL_WIDTH)

		    PORT MAP(		
				IN0    => ID_EX_controls(5 DOWNTO 0),
				IN1    => (others => '0'),
				SEL	   => HDU_FLUSH_IFID_EXMEM,   
				OUTPUT => EX_DMEM_FLUSH_MUX_out		   
		             );



RS1_ALU_FWD_MUX: mux3to1 GENERIC MAP( N => WORD_WIDTH)
    PORT MAP(
        IN00    => ID_EX_dataOut0,
        IN01_10 => DMEM_ALU_WB_MUX_out,
        IN11    => EX_DMEM_WB_aluOut,
        SEL     => FWU_fwdA,
        OUTPUT  => RS1_ALU_FWD_MUX_out
        );				

RS2_ALU_FWD_MUX: mux3to1 GENERIC MAP( N => WORD_WIDTH)
    PORT MAP(
        IN00    => ID_EX_dataOut1,
        IN01_10 => DMEM_ALU_WB_MUX_out,
        IN11    => EX_DMEM_WB_aluOut,
        SEL     => FWU_fwdB,
        OUTPUT  => RS2_ALU_FWD_MUX_out
        );
		
	
RS1_PC_ALU_SRC_MUX: mux2to1 GENERIC MAP (N => WORD_WIDTH)

		    PORT MAP(		
				IN0    => RS1_ALU_FWD_MUX_out,
				IN1    => ID_EX_PC,		
				SEL	   => ID_EX_controls(7),   
				OUTPUT => RS1_PC_ALU_SRC_MUX_out			   
		             ); 
					 
RS2_PC_ALU_SRC_MUX: mux2to1 GENERIC MAP (N => WORD_WIDTH)

		    PORT MAP(		
				IN0    => RS2_ALU_FWD_MUX_out,
				IN1    => ID_EX_IMM,		
				SEL	   => ID_EX_controls(6),   
				OUTPUT => RS2_IMM_ALU_SRC_MUX_out			   
		             ); 

alu_b: alu
  PORT MAP(
    a       =>  RS1_PC_ALU_SRC_MUX_out,
	b       =>  RS2_IMM_ALU_SRC_MUX_out, 
    alu_op  =>  ID_EX_aluCtl,	
    output  =>  ALU_out
    );
    
-- BR_JAL_ADDER
BR_JAL_ADDER_out <= std_logic_vector(shift_left(unsigned(ID_EX_IMM), 1)) + ID_EX_PC;					 

EX_DMEM_REG: regn GENERIC MAP (N => 3*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)

		    PORT MAP(
				d(3*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH) 	=> ID_EX_RS1, 
				d(2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	=> ID_EX_RS2, 
				d(RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                    => ID_EX_RD, 
				d(2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                                    => ID_EX_nextPC, 
				d(ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                                                    => BR_JAL_ADDER_out, 
				d(3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 2*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                                                                => ALU_out, 
				d(2*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                                                                    => ID_EX_IMM, 
				d(WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO EXDMEM_CTRL_WIDTH)   	                                                                                => RS2_ALU_FWD_MUX_out, 
				d(EXDMEM_CTRL_WIDTH -1 DOWNTO 0)   	                                                                                                                => EX_DMEM_FLUSH_MUX_out, 
				clk                                                                                                                                                 => clk,		
				rst_n	                                                                                                                                            => rst_n,   
				en 	                                                                                                                                                => '1',   
				q(3*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH) 	=> EX_DMEM_RS1,
				q(2*RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	=> EX_DMEM_RS2,
                q(RF_ADDR_WIDTH + 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                    => EX_DMEM_RD,
 			    q(2*ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)                                          => EX_DMEM_nextPC, 
				q(ADDR_WIDTH + 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 3*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                                                    => EX_DMEM_jumpAddr,
				q(3*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO 2*WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                                                                => EX_DMEM_WB_aluOut,
				q(2*WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO WORD_WIDTH + EXDMEM_CTRL_WIDTH)   	                                                                    => EX_DMEM_IMM, 
				q(WORD_WIDTH + EXDMEM_CTRL_WIDTH -1 DOWNTO EXDMEM_CTRL_WIDTH)   	                                                                                => EX_DMEM_memDataIn,
				q(EXDMEM_CTRL_WIDTH -1 DOWNTO 0)   	                                                                                                                => EX_DMEM_controls
		             );	
   
DMEM_DATA_FWD_MUX: mux2to1 GENERIC MAP (N => WORD_WIDTH)

		    PORT MAP(		
				IN0    => EX_DMEM_memDataIn,
				IN1    => D_mem_out,		
				SEL	   => FWU_fwdWriteData,   
				OUTPUT => DMEM_DATA_FWD_MUX_out			   
		             ); 

DMEM_ADDR_FWD_MUX: mux2to1 GENERIC MAP (N => ADDR_WIDTH)

		    PORT MAP(		
				IN0    => EX_DMEM_WB_aluOut,
				IN1    => DMEM_ADDR_FWD_ADDER_out,		
				SEL	   => FWU_fwdWriteAddr,   
				OUTPUT => DMEM_ADDR_FWD_MUX_out			   
		             ); 
					 
					 
DMEM_ADDR_FWD_ADDER_out <= D_mem_out + EX_DMEM_IMM; 

-- D_MEM interface
D_mem_write <= EX_DMEM_controls(2);
D_mem_read  <= EX_DMEM_controls(3);
D_mem_in    <= DMEM_DATA_FWD_MUX_out;
D_mem_addr  <= DMEM_ADDR_FWD_MUX_out;   

DMEM_WB_REG: regn GENERIC MAP (N => RF_ADDR_WIDTH + ADDR_WIDTH + WORD_WIDTH + DMEMWB_CTRL_WIDTH)

		    PORT MAP(
				d(RF_ADDR_WIDTH + ADDR_WIDTH + WORD_WIDTH + DMEMWB_CTRL_WIDTH-1 DOWNTO ADDR_WIDTH + WORD_WIDTH + DMEMWB_CTRL_WIDTH) 	=> EX_DMEM_RD,
				d(ADDR_WIDTH + WORD_WIDTH + DMEMWB_CTRL_WIDTH-1 DOWNTO WORD_WIDTH + DMEMWB_CTRL_WIDTH)                                  => EX_DMEM_nextPC,
				d(WORD_WIDTH + DMEMWB_CTRL_WIDTH-1 DOWNTO DMEMWB_CTRL_WIDTH)                                                            => EX_DMEM_WB_aluOut,
				d(DMEMWB_CTRL_WIDTH-1)                                                                                                  => EX_DMEM_controls(4),
				d(DMEMWB_CTRL_WIDTH-2 DOWNTO 0)                                                                                         => EX_DMEM_controls(1 DOWNTO 0),
				clk                                                                                                                     => clk,		
				rst_n	                                                                                                                => rst_n,   
				en 	                                                                                                                    => '1',   
				q(RF_ADDR_WIDTH + ADDR_WIDTH + WORD_WIDTH + DMEMWB_CTRL_WIDTH-1 DOWNTO ADDR_WIDTH + WORD_WIDTH + DMEMWB_CTRL_WIDTH) 	=> DMEM_WB_RD,
				q(ADDR_WIDTH + WORD_WIDTH + DMEMWB_CTRL_WIDTH-1 DOWNTO WORD_WIDTH + DMEMWB_CTRL_WIDTH)                                  => DMEM_WB_next_PC,
				q(WORD_WIDTH + DMEMWB_CTRL_WIDTH-1 DOWNTO DMEMWB_CTRL_WIDTH)                                                            => DMEM_WB_aluOut,
				q(DMEMWB_CTRL_WIDTH-1 DOWNTO 0)	                                                                                        => DMEM_WB_controls                      			   
		             );

-- WB stage 
DMEM_ALU_WB_MUX:  mux2to1 GENERIC MAP (N => WORD_WIDTH)

		    PORT MAP(		
				IN0    => DMEM_WB_aluOut,
				IN1    => D_mem_out,		
				SEL	   => DMEM_WB_controls(1),   
				OUTPUT => DMEM_ALU_WB_MUX_out			   
		             ); 

JUMP_WB_MUX: mux2to1 GENERIC MAP (N => WORD_WIDTH)

		    PORT MAP(		
				IN0    => DMEM_ALU_WB_MUX_out,
				IN1    => DMEM_WB_next_PC,		
				SEL	   => DMEM_WB_controls(2),   
				OUTPUT => JUMP_WB_MUX_out			   
		             ); 

cu_b:  cu 
  PORT MAP (
  instruction             =>  IF_ID_FLUSH_MUX_out,
  imm_type                =>  CU_immType,
  D_MEM_write             =>  CU_D_MEM_write,       
  D_MEM_read              =>  CU_D_MEM_read,           
  RF_write                =>  CU_RF_write,      
  branch                  =>  CU_branch,
  jump                    =>  CU_jump,    
  RS1_PC_ALU_SRC_MUX_sel  =>  CU_RS1_PC_ALU_SRC_MUX_sel,
  RS2_IMM_ALU_SRC_MUX_sel =>  CU_RS2_IMM_ALU_SRC_MUX_sel,
  DMEM_ALU_WB_MUX_sel     =>  CU_DMEM_ALU_WB_MUX_sel
  );

HDU: hazard_det_unit
  PORT MAP(
    ID_EX_Rd         => ID_EX_RD, 
    IF_ID_Rs1        => IF_ID_FLUSH_MUX_out(RV32I_RS1_START+RF_ADDR_WIDTH-1 DOWNTO RV32I_RS1_START),
    IF_ID_Rs2        => IF_ID_FLUSH_MUX_out(RV32I_RS2_START+RF_ADDR_WIDTH-1 DOWNTO RV32I_RS2_START),
    ID_EX_memRead    => ID_EX_controls(3),
    IF_ID_memWrite   => CU_D_MEM_write,
    ControlHaz       => NEXT_ADDR_SEL_CU_jumpOrBranch,	
    stall_n          => HDU_STALL,
    flush_ID_EX      => HDU_FLUSH_IDEX,
    flush_IFIDEXMEM  => HDU_FLUSH_IFID_EXMEM
    );

FWU: forwarding_unit
  PORT MAP(
    ID_EX_Rs1        => ID_EX_RS1, 
    ID_EX_Rs2        => ID_EX_RS2,  
    EX_MEM_Rs1       => EX_DMEM_RS1, 
    EX_MEM_Rs2       => EX_DMEM_RS2, 
    EX_MEM_Rd        => EX_DMEM_RD,
    MEM_WB_Rd        => DMEM_WB_RD,
    EX_MEM_RegWrite  => EX_DMEM_controls(0),
    EX_MEM_MemWrite  => EX_DMEM_controls(2),
    MEM_WB_RegWrite  => DMEM_WB_controls(0),
    MEM_WB_MemToReg  => DMEM_WB_controls(1),
    fwd_a            => FWU_fwdA,
    fwd_b            => FWU_fwdB,
    fwd_Wrt_data     => FWU_fwdWriteData,
    fwd_Wrt_addr     => FWU_fwdWriteAddr
    );

NEXT_ADDR_SEL_CU_b: next_addr_sel_cu
  PORT MAP(
    branchIn      => EX_DMEM_controls(5), 
    compResult    => EX_DMEM_WB_aluOut(0),	
    jumpIn		  => EX_DMEM_controls(4),	
    jumpOrBranch  => NEXT_ADDR_SEL_CU_jumpOrBranch
    );	 

				 
END beh;

