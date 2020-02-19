LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

USE work.param.all;
USE work.alu_param.all;

use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY tb_main IS
	
END ENTITY;

ARCHITECTURE test OF tb_main IS

COMPONENT main IS
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
END COMPONENT;

COMPONENT instr_mem IS
--	GENERIC( INIT_FILE : STRING);
	PORT(
    clk        : IN  std_logic; 	
    memRead    : IN  std_logic; 	
    memWrite   : IN  std_logic;	
    address    : IN  std_logic_vector(7-1 DOWNTO 0);	
    input      : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0);
    output     : OUT  std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT data_mem IS
--	GENERIC( INIT_FILE : STRING);
	PORT(
    clk        : IN  std_logic; 	
    memRead    : IN  std_logic; 	
    memWrite   : IN  std_logic;	
    address    : IN  std_logic_vector(7-1 DOWNTO 0);	
    input      : IN  std_logic_vector(WORD_WIDTH-1 DOWNTO 0);
    output     : OUT  std_logic_vector(WORD_WIDTH-1 DOWNTO 0)
    );
END COMPONENT;

	signal clk		: std_logic;
	signal rst_n    : std_logic;

-- Instruction memory
	signal i_mem_read : std_logic;
	signal i_mem_addr : std_logic_vector(ADDR_WIDTH-1 DOWNTO 0); 
	signal i_mem_out  : std_logic_vector(INST_WIDTH-1 DOWNTO 0); 
	
-- Data memory
	signal d_mem_read  : std_logic;
	signal d_mem_write : std_logic;
	signal d_mem_addr  : std_logic_vector(ADDR_WIDTH-1 DOWNTO 0); 
	signal d_mem_in    : std_logic_vector(WORD_WIDTH-1 DOWNTO 0); 
	signal d_mem_out   : std_logic_vector(INST_WIDTH-1 DOWNTO 0); 

BEGIN

PROCESS -- clock generation at 500mhz.
BEGIN
		clk <= '1';
		wait for 1 ns;
		clk <= '0';
		wait for 1 ns;
END PROCESS;
	
PROCESS -- reset generation 
BEGIN
		rst_n   <= '0';	
		wait for 4 ns;
		rst_n   <= '1';		
		wait;
END PROCESS;

-- process for test 
PROCESS		 
BEGIN
		WAIT;
END PROCESS;	
	
        		
	main_map : main
		PORT MAP(clk => clk, rst_n => rst_n, I_mem_out => i_mem_out, D_mem_out => d_mem_out, I_mem_addr => i_mem_addr, I_mem_read => i_mem_read, 
				 D_mem_addr => d_mem_addr, D_mem_in => d_mem_in, D_mem_read => d_mem_read, D_mem_write => d_mem_write
			     );
			     
	data_memory : data_mem
--		GENERIC MAP ("data.txt")
		PORT MAP(clk => clk, memRead => d_mem_read, memWrite => d_mem_write, address => d_mem_addr(6 downto 0), input => d_mem_in, output => d_mem_out
		);
	
	instr_memory : instr_mem
--		GENERIC MAP ("instr.txt")
		PORT MAP(clk => clk, memRead => i_mem_read, memWrite => '0', address => i_mem_addr(6 downto 0), input => (others => '0'), output => i_mem_out
		);
		 
END test;
        