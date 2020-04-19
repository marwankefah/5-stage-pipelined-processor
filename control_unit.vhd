library ieee;
use ieee.std_logic_1164.all;

entity control_unit is 
	port(
		opcode : in std_logic_vector(5 downto 0);
		cntrl_sig : out std_logic_vector(32 downto 0)
	);
end control_unit;

architecture control_unit_arch of control_unit is 
	-- opcodes
	constant NOP_OP : std_logic_vector(5 downto 0) := "000000";
	constant SETC_OP : std_logic_vector(5 downto 0) := "000001";
	constant CLRC_OP : std_logic_vector(5 downto 0) := "000010";
	constant NOT_OP : std_logic_vector(5 downto 0) := "000011";
	constant INC_OP : std_logic_vector(5 downto 0) := "000100";
	constant DEC_OP : std_logic_vector(5 downto 0) := "000101";
	constant OUT_OP : std_logic_vector(5 downto 0) := "000110";
	constant IN_OP : std_logic_vector(5 downto 0) := "000111";
	constant SWAP_OP : std_logic_vector(5 downto 0) := "001000";
	constant ADD_OP : std_logic_vector(5 downto 0) := "001001";
	constant IADD_OP : std_logic_vector(5 downto 0) := "101010";
	constant SUB_OP : std_logic_vector(5 downto 0) := "001011";
	constant AND_OP : std_logic_vector(5 downto 0) := "001100";
	constant OR_OP : std_logic_vector(5 downto 0) := "001101";
	constant SHL_OP : std_logic_vector(5 downto 0) := "101110";
	constant SHR_OP : std_logic_vector(5 downto 0) := "101111";
	constant PUSH_OP : std_logic_vector(5 downto 0) := "010000";
	constant POP_OP : std_logic_vector(5 downto 0) := "010001";
	constant LDM_OP : std_logic_vector(5 downto 0) := "110010";
	constant LDD_OP : std_logic_vector(5 downto 0) := "110011";
	constant STD_OP : std_logic_vector(5 downto 0) := "110100";
	constant JZ_OP : std_logic_vector(5 downto 0) := "011000";
	constant JN_OP : std_logic_vector(5 downto 0) := "011001";
	constant JC_OP : std_logic_vector(5 downto 0) := "011010";
	constant JMP_OP : std_logic_vector(5 downto 0) := "011011";
	constant CALL_OP : std_logic_vector(5 downto 0) := "011100";
	constant RET_OP : std_logic_vector(5 downto 0) := "011101";
	constant RTI_OP : std_logic_vector(5 downto 0) := "011110";
begin
	with opcode select 
		cntrl_sig <= "000000000000000000100000000000000" when NOP_OP,
			      "000000000000100100100000000000000" when SETC_OP,
			      "000000000000010100100000000000000" when CLRC_OP,
			      "000000000100000100100000000000010" when NOT_OP,
			      "000000001000000100100000000000010" when INC_OP,
			      "000000001001000100100000000000010" when DEC_OP,
			      "000000100111000000100000000000000" when OUT_OP,
			      "000001000111000000100000000000010" when IN_OP,
			      "000000000111000000100000000000111" when SWAP_OP,
			      "100000000000000100100000000000010" when ADD_OP,
			      "100000010000000100100000000000010" when IADD_OP,
			      "100000000001000100100000000000010" when SUB_OP,
			      "100000000010000100100000000000010" when AND_OP,
			      "100000000011000100100000000000010" when OR_OP,
			      "000000010101000100100000000000010" when SHL_OP,
			      "000000010110000100100000000000010" when SHR_OP,
			      "000000000111000001100000010100000" when PUSH_OP,
			      "000000000000000001000000001000010" when POP_OP,
			      "000010000111000000100000000000010" when LDM_OP,
			      "000000000000000000100000111000010" when LDD_OP,
			      "000000000111000000100000110100000" when STD_OP,
			      "011000000000000000100000000000000" when JZ_OP,
			      "010000000000000000100000000000000" when JN_OP,
			      "001000000000000000100000000000000" when JC_OP,
			      "000100000000000000100000000000000" when JMP_OP,
			      "000100000000000001100010010100000" when CALL_OP,
			      "000000000000000001000000001001000" when RET_OP,
			      "000000000000000000101000101001000" when RTI_OP,	
			      "000000000000000000100000000000000" when others;
end control_unit_arch;

