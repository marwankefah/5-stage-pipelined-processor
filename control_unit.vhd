library ieee;
use ieee.std_logic_1164.all;

entity control_unit is 
	port(
		opcode : in std_logic_vector(5 downto 0);
		int : in std_logic;
		rst : in std_logic;
		cntrl_sig : out std_logic_vector(34 downto 0);
		IF_flush : out std_logic
	);
end control_unit;

architecture control_unit_arch of control_unit is 
	signal op_signals : std_logic_vector(34 downto 0);
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
		op_signals <= 
		        "00000000000000000000100000000000000" when NOP_OP,
			      "00000000000010000100100000000000000" when SETC_OP,
			      "00000000000001000100100000000000000" when CLRC_OP,
			      "00000000010000000100100000000000010" when NOT_OP,
			      "00000000100000000100100000000000010" when INC_OP,
			      "00000000100100000100100000000000010" when DEC_OP,
			      "00000010011100000000100000000000000" when OUT_OP,
			      "00000100011100000000100000000000010" when IN_OP,
			      "00000000011100000000100000000000111" when SWAP_OP,
			      "10000000000000000100100000000000010" when ADD_OP,
			      "10000001000000000100100000000000010" when IADD_OP,
			      "10000000000100000100100000000000010" when SUB_OP,
			      "10000000001000000100100000000000010" when AND_OP,
			      "10000000001100000100100000000000010" when OR_OP,
			      "00000001010100000100100000000000010" when SHL_OP,
			      "00000001011000000100100000000000010" when SHR_OP,
			      "00000000011100000001100000010100000" when PUSH_OP,
			      "00000000000000000001000000001010010" when POP_OP,
			      "00001000011100000000100000000000010" when LDM_OP,
			      "00000000000000000000100000111010010" when LDD_OP,
			      "00000000011100000000100000110100000" when STD_OP,
			      "01100000000000100100100000000000000" when JZ_OP,
			      "01000000000000010100100000000000000" when JN_OP,
			      "00100000000001000100100000000000000" when JC_OP,
			      "00010000000000000000100000000000000" when JMP_OP,
			      "00010000000000000001100010010100000" when CALL_OP,
			      "00000000000000000001000000001011000" when RET_OP,
			      "00000000000000000000101000101011000" when RTI_OP,	
			      "00000000000000000000100000000000000" when others;
			
	cntrl_sig <= "00000000000000001100000000101011000" when rst = '1' else
		     "00000000000000000000100100101011000" when int = '1' else
		     op_signals;

	IF_flush <= '1' when (int = '1' or rst = '1' or opcode = CALL_OP or opcode = RET_OP or opcode = RTI_OP) else
		    '0';		
end control_unit_arch;
