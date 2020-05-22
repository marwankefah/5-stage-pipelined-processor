library ieee;
use ieee.std_logic_1164.all;

entity ID_Stage is
	port(
		-- INPUTS

		-- EXTERNAL INPUT
		clk : std_logic;
		rst_in : std_logic;
		reset : std_logic; 

		-- FROM IF/ID BUFFER
		instr : in std_logic_vector(31 downto 0);
		int : in std_logic;
		PCnext : in std_logic_vector(31 downto 0);
		INport : in std_logic_vector(31 downto 0);

		-- FROM MEM/WB BUFFER
		MEM_WB_WR1 : in std_logic_vector(2 downto 0);			
		MEM_WB_WR2 : in std_logic_vector(2 downto 0);	
		MEM_WB_RD2 : in std_logic_vector(31 downto 0);		
		MEM_WB_WE1R : in std_logic;
		MEM_WB_WE2R : in std_logic;	
		MEM_WB_WDRS : in std_logic;

		--FROM WB STAGE
		WB_WB : in std_logic_vector(31 downto 0);

		-- FROM EX/MEM BUFFER
		EX_MEM_RD2 : in std_logic_vector(31 downto 0);
		EX_MEM_ALUr : in std_logic_vector(31 downto 0);

		-- FROM FORWARDING UNIT
		F_C : in std_logic_vector(1 downto 0);
		
		-- FROM EX STAGE
		CCR : in std_logic_vector(3 downto 0);
		
		-- FROM HAZARD DETECTION UNIT
		HZ_NOP : std_logic;

		-- FROM INTERRUPT HANDLING UNIT
		INS_ID : in std_logic_vector(1 downto 0);


		-- OUTPUTS

		-- CONTROL SIGNALS TO ID/EX BUFFER
		WB : out std_logic_vector(4 downto 0);
		MEM : out std_logic_vector(10 downto 0);
		EX : out std_logic_vector(12 downto 0);
		opcode : out std_logic_vector(5 downto 0);
		INPS : out std_logic_vector(1 downto 0);
		
		-- DATA AND ADDRESSES TO ID/EX BUFFER
		RD1 : out std_logic_vector(31 downto 0);
		RD2 : out std_logic_vector(31 downto 0);
		IMMe : out std_logic_vector(31 downto 0);
		EAe : out std_logic_vector(31 downto 0);
		WR1 : out std_logic_vector(2 downto 0);
		WR2 : out std_logic_vector(2 downto 0);
		RR1 : out std_logic_vector(2 downto 0);
		RR2 : out std_logic_vector(2 downto 0);

		-- CONTROL SIGNALS TO HAZARD DETECTION UNIT
		JCS : out std_logic_vector(1 downto 0);
		CALL : out std_logic;

		-- SELECTOR AND VALUE TO FETCH STAGE
		PCBranch : out std_logic_vector(31 downto 0);
		PCBranchS : out std_logic
	);
end ID_Stage;

architecture ID_Stage_arch of ID_Stage is
	component control_unit is 
		port(
			opcode : in std_logic_vector(5 downto 0);
			int : in std_logic;
			rst : in std_logic;
			cntrl_sig : out std_logic_vector(34 downto 0)
		);
	end component;

	component register_file is
		port(
			clk, reset, WER1, WER2 : in std_logic;
			RR1, RR2, WR1, WR2 : in std_logic_vector(2 downto 0);
			WD1, WD2 : in std_logic_vector(31 downto 0);
			RD1, RD2 : out std_logic_vector(31 downto 0)
		);
	end component;

	component MUX_4x1 IS
		generic(
			n : integer
		);
		
		PORT( 
			in0:  IN  std_logic_vector (n-1 DOWNTO 0);
			in1:  IN  std_logic_vector (n-1 DOWNTO 0);
			in2:  IN  std_logic_vector (n-1 DOWNTO 0);
			in3:  IN  std_logic_vector (n-1 DOWNTO 0);
			sel:  IN  std_logic_vector (1 DOWNTO 0);
			outm: OUT std_logic_vector (n-1 DOWNTO 0)
		);
	END component;

	component MUX_2x1 IS
		generic(
			n : integer
		);	

		PORT( 
			in0:  IN  std_logic_vector (n-1 DOWNTO 0);
			in1:  IN  std_logic_vector (n-1 DOWNTO 0);
			sel:  IN  std_logic;
			outm: OUT std_logic_vector (n-1 DOWNTO 0)
		);
	END component;	

	component MUX_4x1_1 IS
		PORT( 
			in0:  IN  std_logic;
			in1:  IN  std_logic;
			in2:  IN  std_logic;
			in3:  IN  std_logic;
			sel:  IN  std_logic_vector (1 DOWNTO 0);
			outm: OUT std_logic
		);
	END component;

	-- CONSTANTS
	constant ZERO : std_logic_vector(28 downto 0)    := "00000000000000000000000000000";
	constant PUSHF : std_logic_vector(28 downto 0)   := "00000000000001100011010100000";
	constant RestoreF: std_logic_vector(28 downto 0) := "00000000000110100000000000000";

	-- SIGNALS
	signal cntrl_signals : std_logic_vector(34 downto 0);
	signal regfile_RR1 : std_logic_vector(2 downto 0);
	signal regfile_WD1 : std_logic_vector(31 downto 0);
	signal regfile_RD1 : std_logic_vector(31 downto 0);
	signal next_signals_stall : std_logic_vector(28 downto 0);
	signal next_signals_hazard : std_logic_vector(28 downto 0);
	signal IMme_sig : std_logic_vector(31 downto 0);
	signal branch_RD1 : std_logic_vector(31 downto 0);
	signal select_with_flag : std_logic;
	signal jump_PC : std_logic_vector(31 downto 0);


	-- ALIASES AS SIGNALS
	signal instr_opcode : std_logic_vector(5 downto 0);
	signal instr_9to7 : std_logic_vector(2 downto 0);
	signal instr_6to4 : std_logic_vector(2 downto 0);
	signal instr_3to1 : std_logic_vector(2 downto 0);
	signal instr_31to16 : std_logic_vector(15 downto 0);
	signal instr_3to0 : std_logic_vector(3 downto 0);

	signal c_RR1S : std_logic;
	signal c_JCS : std_logic_vector(1 downto 0);
	signal c_CALL : std_logic;
	signal c_INPS : std_logic_vector(1 downto 0);
	signal c_next_signals : std_logic_vector(28 downto 0);
	
begin
	-- ALIASES AS SIGNALS
	instr_opcode <= instr(15 downto 10);
	instr_9to7 <= instr(9 downto 7);
	instr_6to4 <= instr(6 downto 4);
	instr_3to1 <= instr(3 downto 1);
	instr_31to16 <= instr(31 downto 16);
	instr_3to0 <= instr(3 downto 0);
	
	c_RR1S <= cntrl_signals(34);
	c_JCS <= cntrl_signals(33 downto 32);
	c_CALL <= cntrl_signals(31);
	c_INPS <= cntrl_signals(30 downto 29);
	c_next_signals <= cntrl_signals(28 downto 0);

	-- CONTROL UNIT
	ControlUNIT : control_unit port map(instr_opcode,int,rst_in,cntrl_signals);

	-- CONTROL SIGNALS
	control_mux1 : MUX_2x1 generic map(29) port map(c_next_signals,ZERO,HZ_NOP,next_signals_stall);
	control_mux2 : MUX_4x1 generic map(29) port map(PUSHF,next_signals_stall,RestoreF,ZERO,INS_ID,next_signals_hazard);
	WB <= next_signals_hazard(4 downto 0);
	MEM <=	next_signals_hazard(15 downto 5);
	EX <= next_signals_hazard(28 downto 16);
	opcode <= instr_opcode;
	INPS <= c_INPS;
	JCS <= c_JCS;
	CALL <= c_CALL; 

	-- EXTENDED SIGNALS
	IMMe_sig <= "0000000000000000" & instr_31to16;
	IMMe <= IMMe_sig;
	EAe <= "000000000000" & instr_3to0 & instr_31to16;

	-- REGISTER FILE
	RR1_MUX : MUX_2x1 generic map(3) port map(instr_9to7,instr_6to4,c_RR1S,regfile_RR1);
	WD1_MUX : MUX_2x1 generic map(32) port map(WB_WB,MEM_WB_RD2,MEM_WB_WDRS,regfile_WD1);
	regfile : register_file port map(clk,reset,MEM_WB_WE1R,MEM_WB_WE2R,regfile_RR1,instr_3to1,MEM_WB_WR1,MEM_WB_WR2,regfile_WD1,WB_WB,regfile_RD1,RD2);
	RD1_MUX : MUX_4x1 generic map(32) port map(regfile_RD1,INport,IMMe_sig,IMMe_sig,c_INPS,RD1);

	-- OTHER SIGNALS
	WR1 <= instr_9to7;
	WR2 <= instr_3to1;
	RR1 <= regfile_RR1;
	RR2 <= instr_3to1;

	-- BRANCHING SIGNALS
	BranchRD1_MUX : MUX_4x1 generic map(32) port map(regfile_RD1,EX_MEM_ALUr,EX_MEM_RD2,EX_MEM_RD2,F_C,branch_RD1);
	FlagSelector_MUX : MUX_4x1_1 port map(CCR(3),CCR(2),CCR(1),CCR(0),c_JCS,select_with_flag);
	Branch_MUX1 : MUX_2x1 generic map(32) port map(PCnext,branch_RD1,select_with_flag,jump_PC); 
	Branch_MUX2 : MUX_2x1 generic map(32) port map(jump_PC,branch_RD1,c_CALL,PCBranch);
	PCBranchS <= (c_CALL or select_with_flag);	

end ID_Stage_arch;

