LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Processor IS
	PORT (
		--EXTERNAL INPUT
		CLK:		IN std_logic;
		Reset :	 	IN std_logic; 
		INTR_IN:	IN std_logic;
		IN_PORT:	IN std_logic_vector(31 DOWNTO 0);

		--OUTPUT
		OUT_PORT:	OUT std_logic_vector(31 DOWNTO 0)
	);
END Processor;

Architecture Processor_Archi of Processor IS
	COMPONENT reg is 
		generic(
			n : integer
		);

		port(
			clk : in std_logic;
			reset : in std_logic;
			en : in std_logic;
			d : in std_logic_vector(n-1 downto 0);
			q : out std_logic_vector(n-1 downto 0)
		);
	end COMPONENT;

	component ID_Stage is
		port(
			-- INPUTS

			-- EXTERNAL INPUT
			clk : std_logic;
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
			EX : out std_logic_vector(10 downto 0);
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
	end component;

	component ID_EX_Buffer is
		port(
			clk, reset, en : std_logic;
		
			-- INPUTS 
			D_WB : in std_logic_vector(4 downto 0);
			D_MEM : in std_logic_vector(10 downto 0);
			D_EX : in std_logic_vector(10 downto 0);
			D_opcode : in std_logic_vector(5 downto 0);
			D_INPS : in std_logic_vector(1 downto 0);
			D_int : in std_logic;
			D_PC : in std_logic_vector(31 downto 0);
			D_PCnext : in std_logic_vector(31 downto 0);
			D_RD1 : in std_logic_vector(31 downto 0);
			D_RD2 : in std_logic_vector(31 downto 0);
			D_IMMe : in std_logic_vector(31 downto 0);
			D_EAe : in std_logic_vector(31 downto 0);
			D_WR1 : in std_logic_vector(2 downto 0);
			D_WR2 : in std_logic_vector(2 downto 0);
			D_RR1 : in std_logic_vector(2 downto 0);
			D_RR2 : in std_logic_vector(2 downto 0);
	
			-- OUTPUTS
			Q_WB : out std_logic_vector(4 downto 0);
			Q_MEM : out std_logic_vector(10 downto 0);
			Q_EX : out std_logic_vector(10 downto 0);
			Q_opcode : out std_logic_vector(5 downto 0);
			Q_INPS : out std_logic_vector(1 downto 0);
			Q_int : out std_logic;
			Q_PC : out std_logic_vector(31 downto 0);
			Q_PCnext : out std_logic_vector(31 downto 0);
			Q_RD1 : out std_logic_vector(31 downto 0);
			Q_RD2 : out std_logic_vector(31 downto 0);
			Q_IMMe : out std_logic_vector(31 downto 0);
			Q_EAe : out std_logic_vector(31 downto 0);
			Q_WR1 : out std_logic_vector(2 downto 0);
			Q_WR2 : out std_logic_vector(2 downto 0);
			Q_RR1 : out std_logic_vector(2 downto 0);
			Q_RR2 : out std_logic_vector(2 downto 0)
		);
	end component;

	COMPONENT Execute_Stage IS
		PORT (	
			--EXTERNAL INPUT
			CLK:		std_logic;
			Reset :	 	std_logic; 
			EX_INTS:	std_logic_vector(1 DOWNTO 0);
			RD1: 		IN std_logic_vector(31 DOWNTO 0);
 			RD2 : 		IN std_logic_vector(31 DOWNTO 0);
			--RD2 comming from memory stage
			RD2N: 		IN std_logic_vector(31 DOWNTO 0);
			WB:   		IN std_logic_vector(31 DOWNTO 0);
			ALUr: 		IN std_logic_vector(31 DOWNTO 0);
			A:    		IN std_logic_vector(1  DOWNTO 0);
			B:    		IN std_logic_vector(1  DOWNTO 0);
			IMMe: 		IN std_logic_vector(31 DOWNTO 0);
			--Control input begin
			ID_EX_EX:  	IN std_logic_vector(10 DOWNTO 0);
			ID_EX_MEM: 	IN std_logic_vector(10 DOWNTO 0);
			ID_EX_WB:  	IN std_logic_vector(4 DOWNTO 0);
			--Control input end
			--outputs
			EX_MEM_MEM: 	OUT std_logic_vector(10 DOWNTO 0);
			EX_MEM_WB:  	OUT std_logic_vector(4 DOWNTO 0);
			CCR:  	   	OUT std_logic_vector(3 DOWNTO 0);
			ALUResult: 	OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT EX_MEM_Buffer IS
		PORT( 		 
			Clk,Rst,en: 	IN stD_logic;
			--BEGIN INPUT_BUFFER
			--WB CONTROL PROPAGATION
			D_WB: 		IN std_logic_vector(4 downto 0);
			--END WB CONTROL PROPAGATION
			--MEMORY CONTROL PROPAGATION
			D_MEM:	 	IN std_logic_vector(10 downto 0);
			--END MEMORY CONTROL PROPAGATION
			--Execute Data PROPAGATION
			D_ALUResult:	IN stD_logic_vector(31 DOWNTO 0);
			D_PC: 		IN std_logic_vector(31 downto 0);
			D_PCnext: 	IN std_logic_vector(31 downto 0);
			D_RD1:		IN stD_logic_vector(31 DOWNTO 0);
			D_RD2:		IN stD_logic_vector(31 DOWNTO 0);
			D_EAe:		IN stD_logic_vector(31 DOWNTO 0);
			D_WR1:		IN stD_logic_vector(2 DOWNTO 0);
			D_WR2:		IN stD_logic_vector(2 DOWNTO 0);
			D_RR1:		IN stD_logic_vector(2 DOWNTO 0);
			D_RR2:		IN stD_logic_vector(2 DOWNTO 0);
			--END Execute Data PROPAGATION
			--OTHER PROPAGATION
			D_OPCODE:	IN stD_logic_vector(5 DOWNTO 0);
			D_INT:		IN stD_logic;
			--END OTHER PROPAGATION
			--END INPUT BUFFER
			--BEGIN OUTPUT_BUFFER		
			--WB CONTROL PROPAGATION
			Q_WB:  		OUT std_logic_vector(4 downto 0);
			--END WB CONTROL PROPAGATION
			--MEMORY CONTROL PROPAGATION
			Q_MEM:	 	OUT std_logic_vector(10 downto 0);
			--END MEMORY CONTROL PROPAGATION
			--Execute Data PROPAGATION
			Q_ALUResult:	OUT stD_logic_vector(31 DOWNTO 0);
			Q_PC:	 	OUT stD_logic_vector(31 DOWNTO 0);
			Q_PCnext:	OUT stD_logic_vector(31 DOWNTO 0);
			Q_RD1:		OUT stD_logic_vector(31 DOWNTO 0);
			Q_RD2:		OUT stD_logic_vector(31 DOWNTO 0);
			Q_EAe:		OUT stD_logic_vector(31 DOWNTO 0);
			Q_WR1:		OUT stD_logic_vector(2 DOWNTO 0);
			Q_WR2:		OUT stD_logic_vector(2 DOWNTO 0);
			Q_RR1:		OUT stD_logic_vector(2 DOWNTO 0);
			Q_RR2:		OUT stD_logic_vector(2 DOWNTO 0);
			--END Execute Data PROPAGATION
			--OTHER PROPAGATION
			Q_OPCODE:	OUT stD_logic_vector(5 DOWNTO 0);
			Q_INT:		OUT stD_logic
			--END OTHER PROPAGATION  
			--END OUTPUT BUFFER			
		);		  
	END COMPONENT;
--=================================================================================================================================================
	--FETCH STAGE OUTPUTS

--ANOUD

	--END FETCH STAGE OUTPUTS
--=================================================================================================================================================
	--OUTPUT OF FETCH/DECODE BUFFER
--ANOUD
	signal IF_ID_OUT_instr : 	std_logic_vector(31 downto 0);
	signal IF_ID_OUT_int : 		std_logic;
	signal IF_ID_OUT_PC : 		std_logic_vector(31 downto 0);
	signal IF_ID_OUT_PCnext : 	std_logic_vector(31 downto 0);
	signal IF_ID_OUT_INport : 	std_logic_vector(31 downto 0);
 
	--END OUTPUT OF FETCH/DECODE BUFFER
--=================================================================================================================================================
	--DECODE STAGE OUTPUTS
	
	signal ID_OUT_WB : 		std_logic_vector(4 downto 0);
	signal ID_OUT_MEM :		std_logic_vector(10 downto 0);
	signal ID_OUT_EX : 		std_logic_vector(10 downto 0);
	signal ID_OUT_opcode : 		std_logic_vector(5 downto 0);
	signal ID_OUT_INPS : 		std_logic_vector(1 downto 0);
	signal ID_OUT_RD1 : 		std_logic_vector(31 downto 0);
	signal ID_OUT_RD2 : 		std_logic_vector(31 downto 0);
	signal ID_OUT_IMMe : 		std_logic_vector(31 downto 0);
	signal ID_OUT_EAe : 		std_logic_vector(31 downto 0);
	signal ID_OUT_WR1 : 		std_logic_vector(2 downto 0);
	signal ID_OUT_WR2 : 		std_logic_vector(2 downto 0);
	signal ID_OUT_RR1 : 		std_logic_vector(2 downto 0);
	signal ID_OUT_RR2 : 		std_logic_vector(2 downto 0);
	signal ID_OUT_JCS : 		std_logic_vector(1 downto 0);
	signal ID_OUT_CALL :		std_logic;
	signal ID_OUT_PCBranch : 	std_logic_vector(31 downto 0);
	signal ID_OUT_PCBranchS : 	std_logic;
	
	--END DECODE STAGE OUTPUTS
--=================================================================================================================================================
	--OUTPUT OF DECODE/EXECUTE BUFFER

	Signal ID_EX_OUT_WB : 		std_logic_vector(4 downto 0);
	Signal ID_EX_OUT_MEM : 		std_logic_vector(10 downto 0);
	Signal ID_EX_OUT_EX :  		std_logic_vector(10 downto 0);
	Signal ID_EX_OUT_opcode :  	std_logic_vector(5 downto 0);
	Signal ID_EX_OUT_INPS :  	std_logic_vector(1 downto 0);
	Signal ID_EX_OUT_int :  	std_logic;
	Signal ID_EX_OUT_PC :  		std_logic_vector(31 downto 0);
	Signal ID_EX_OUT_PCnext :	std_logic_vector(31 downto 0);
	Signal ID_EX_OUT_RD1 :  	std_logic_vector(31 downto 0);
	Signal ID_EX_OUT_RD2 :  	std_logic_vector(31 downto 0);
	Signal ID_EX_OUT_IMMe :  	std_logic_vector(31 downto 0);
	Signal ID_EX_OUT_EAe :  	std_logic_vector(31 downto 0);
	Signal ID_EX_OUT_WR1 :  	std_logic_vector(2 downto 0);
	Signal ID_EX_OUT_WR2 :  	std_logic_vector(2 downto 0);
	Signal ID_EX_OUT_RR1 :  	std_logic_vector(2 downto 0);
	Signal ID_EX_OUT_RR2 :  	std_logic_vector(2 downto 0);

	--END OUTPUT OF DECODE/EXECUTE BUFFER
--=================================================================================================================================================
	--EXECUTE STAGE OUTPUTS

	signal EX_OUT_MEM:  	std_logic_vector(10 downto 0);
	signal EX_OUT_WB:   	std_logic_vector(4 downto 0);
	signal CCR:      	std_logic_vector(3 downto 0);
	signal EX_ALUResult: 	std_logic_vector(31 downto 0);

	--END EXECUTE STAGE OUTPUTS
--=================================================================================================================================================
	--OUTPUT OF  EXECUTE/MEMORY BUFFER
--AHMED
	Signal EX_MEM_OUT_WB:     	std_logic_vector(4 downto 0);
	Signal EX_MEM_OUT_MEM:     	std_logic_vector(10 downto 0);
	Signal EX_MEM_OUT_ALUResult:	std_logic_vector(31 downto 0);
	Signal EX_MEM_OUT_PC:		std_logic_vector(31 downto 0);
	Signal EX_MEM_OUT_PCnext:	std_logic_vector(31 downto 0);
	Signal EX_MEM_OUT_RD1:		std_logic_vector(31 downto 0);
	Signal EX_MEM_OUT_RD2:		std_logic_vector(31 downto 0);
	Signal EX_MEM_OUT_EAe:		std_logic_vector(31 downto 0);
	Signal EX_MEM_OUT_WR1:		std_logic_vector(2 downto 0);
	Signal EX_MEM_OUT_WR2:		std_logic_vector(2 downto 0);
	Signal EX_MEM_OUT_RR1:		std_logic_vector(2 downto 0);
	Signal EX_MEM_OUT_RR2:		std_logic_vector(2 downto 0);
	Signal EX_MEM_OUT_OPCODE:	std_logic_vector(5 downto 0);
	Signal EX_MEM_OUT_INT:		std_logic;

	--END EXECUTE/MEMORY BUFFER
--=================================================================================================================================================
	--MEMORY STAGE OUTPUTS

--AHMED

	--END MEMORY STAGE OUTPUTS
--=================================================================================================================================================	
	--OUTPUT OF  MEMORY/WB BUFFER
--AHMED
--ANOUD	
	signal MEM_WB_OUT_WR1 : 	std_logic_vector(2 downto 0);
	signal MEM_WB_OUT_WR2 : 	std_logic_vector(2 downto 0);
	signal MEM_WB_OUT_RD2 : 	std_logic_vector(31 downto 0);
	signal MEM_WB_OUT_WE1R : 	std_logic;
	signal MEM_WB_OUT_WE2R : 	std_logic;
	signal MEM_WB_OUT_WDRS : 	std_logic;

	--END MEMORY/WB BUFFER
--=================================================================================================================================================
	--WRITE BACK STAGE OUTPUTS
--ANOUD
	signal WB_OUT_WB : 		std_logic_vector(31 downto 0);

	--END WRITE BACK STAGE OUPUTS
--=================================================================================================================================================
BEGIN
	--FETCH STAGE

--ANOUD

	--END FETCH STAGE
--=================================================================================================================================================
	--FETCH/DECODE BUFFER

--ANOUD

	--END FETCH/DECODE BUFFER
--=================================================================================================================================================
	--DECODE STAGE

	Decode_Stage : ID_Stage
		port map(
			-- INPUTS

			-- EXTERNAL INPUT
			clk 		=>	CLK,
			reset		=>	Reset,
	
			-- FROM IF/ID BUFFER
			instr 		=>	IF_ID_OUT_instr,
			int 		=>	IF_ID_OUT_int,
			PCnext 		=>	IF_ID_OUT_PCnext,
			INport 		=>	IF_ID_OUT_INport,
	
			-- FROM MEM/WB BUFFER
			MEM_WB_WR1	=>	MEM_WB_OUT_WR1,			
			MEM_WB_WR2	=>	MEM_WB_OUT_WR2, 	
			MEM_WB_RD2	=>	MEM_WB_OUT_RD2,	
			MEM_WB_WE1R	=>	MEM_WB_OUT_WE1R, 
			MEM_WB_WE2R	=>	MEM_WB_OUT_WE2R,
			MEM_WB_WDRS 	=>	MEM_WB_OUT_WDRS,

			--FROM WB STAGE
			WB_WB 		=>	WB_OUT_WB,
	
			-- FROM EX/MEM BUFFER
			EX_MEM_RD2 	=>	EX_MEM_OUT_RD2,
			EX_MEM_ALUr 	=>	EX_MEM_OUT_ALUResult,
	
			-- FROM FORWARDING UNIT
			F_C 		=>	"00",		--TODO to be replaced with forwarding unit output
			
			-- FROM EX STAGE
			CCR		=>	CCR, 
		
			-- FROM HAZARD DETECTION UNIT
			HZ_NOP		=>	'0', 		--TODO to be replaced with hazard_detection_unit output
	
			-- FROM INTERRUPT HANDLING UNIT
			INS_ID 		=>	"01",		--TODO TO BE REPLACED WITH INT_HANDLING_UNIT OUTPUT 
	
	
			-- OUTPUTS

			-- CONTROL SIGNALS TO ID/EX BUFFER
			WB 		=>	ID_OUT_WB, 
			MEM 		=>	ID_OUT_MEM, 
			EX 		=>	ID_OUT_EX,
			opcode 		=>	ID_OUT_opcode, 
			INPS 		=>	ID_OUT_INPS,
		
			-- DATA AND ADDRESSES TO ID/EX BUFFER
			RD1 		=>	ID_OUT_RD1, 
			RD2 		=>	ID_OUT_RD2, 
			IMMe 		=>	ID_OUT_IMMe, 
			EAe 		=>	ID_OUT_EAe, 
			WR1 		=>	ID_OUT_WR1,
			WR2 		=>	ID_OUT_WR2, 
			RR1 		=>	ID_OUT_RR1, 
			RR2 		=>	ID_OUT_RR2,

			-- CONTROL SIGNALS TO HAZARD DETECTION UNIT
			JCS 		=>	ID_OUT_JCS,
			CALL		=>	ID_OUT_CALL,
	
			-- SELECTOR AND VALUE TO FETCH STAGE
			PCBranch 	=>	ID_OUT_PCBranch,
			PCBranchS 	=>	ID_OUT_PCBranchS
		);

	--END DECODE STAGE
--=================================================================================================================================================
	--DECODE/EXECUTE BUFFER

	ID_EX_BUFF : ID_EX_Buffer
		port map(
			clk		=>	CLK,
			reset		=>	Reset,
			en		=>	'1',
		
			-- INPUTS 
			D_WB		=>	ID_OUT_WB,
			D_MEM		=>	ID_OUT_MEM,
			D_EX		=>	ID_OUT_EX,
			D_opcode	=>	ID_OUT_opcode,
			D_INPS		=>	ID_OUT_INPS,
			D_int		=>	IF_ID_OUT_int,
			D_PC		=>	IF_ID_OUT_PC,
			D_PCnext	=>	IF_ID_OUT_PCnext,
			D_RD1		=>	ID_OUT_RD1,
			D_RD2		=>	ID_OUT_RD2,
			D_IMMe		=>	ID_OUT_IMMe,
			D_EAe		=>	ID_OUT_EAe,
			D_WR1		=>	ID_OUT_WR1,
			D_WR2		=>	ID_OUT_WR2,
			D_RR1		=>	ID_OUT_RR1,
			D_RR2		=>	ID_OUT_RR2,
	
			-- OUTPUTS
			Q_WB		=>	ID_EX_OUT_WB,
			Q_MEM		=>	ID_EX_OUT_MEM,
			Q_EX		=>	ID_EX_OUT_EX,
			Q_opcode	=>	ID_EX_OUT_opcode,
			Q_INPS		=>	ID_EX_OUT_INPS,
			Q_int		=>	ID_EX_OUT_int,
			Q_PC		=>	ID_EX_OUT_PC,
			Q_PCnext	=>	ID_EX_OUT_PCnext,
			Q_RD1		=>	ID_EX_OUT_RD1,
			Q_RD2		=>	ID_EX_OUT_RD2,
			Q_IMMe		=>	ID_EX_OUT_IMMe,
			Q_EAe		=>	ID_EX_OUT_EAe,
			Q_WR1		=>	ID_EX_OUT_WR1,
			Q_WR2		=>	ID_EX_OUT_WR2,
			Q_RR1		=>	ID_EX_OUT_RR1,
			Q_RR2		=>	ID_EX_OUT_RR2
		);

	--END DECODE/EXECUTE BUFFER
--=================================================================================================================================================
	--Execute STAGE 

	EX_STAGE: Execute_Stage
		PORT MAP (
			--EXTERNAL INPUT
			CLK		=>	CLK,
			Reset 		=>	Reset, 
			EX_INTS		=>	"01",		--TODO TO BE REPLACED WITH INT_HANDLING_UNIT OUTPUT
			RD1		=> 	ID_EX_OUT_RD1,
			RD2 		=>  	ID_EX_OUT_RD2,
			RD2N		=>  	ID_EX_OUT_RD2,	-- TODO to be replaced with Forwarding out
			WB		=>    	ID_EX_OUT_RD2,	-- TODO to be replaced with Forwarding out
			ALUr		=>  	ID_EX_OUT_RD2, 	-- TODO to be replaced with Forwarding out
			A		=>      "00",   	-- TODO to be replaced with Forwarding out
			B		=>      "00",	  	-- TODO to be replaced with forwarding out
			IMMe		=> 	ID_EX_OUT_IMMe,
			--Control input begin
			ID_EX_EX	=>	ID_EX_OUT_EX,
			ID_EX_MEM	=>     	ID_EX_OUT_MEM,
			ID_EX_WB	=>      ID_EX_OUT_WB,
			--Control input end
			EX_MEM_MEM	=>    	EX_OUT_MEM,
			EX_MEM_WB	=>	EX_OUT_WB,
			CCR		=>    	CCR,
			ALUResult	=> 	EX_ALUResult
		);

	--END Execute STAGE 
--=================================================================================================================================================
	--OUTPUT PORT REGISTER

	OUTPUT_PORT_REG : REG
		Generic map(32)
		port map(
			clk		=>	clk,
			reset		=>	reset,
			en		=>	ID_EX_OUT_EX(10),
			d		=>	EX_ALUResult,
			q		=>	OUT_PORT
		);

	--END OUTPUT PORT REGISTER
--=================================================================================================================================================
	--EXECUTE/MEM  BUFFER

	EX_MEM_BUFF: EX_MEM_Buffer
		PORT MAP( 		 
			Clk		=>	CLK,
			Rst		=>	Reset,
			en 		=>	'1',   		-- TODO UNDERSTAND
			--BEGIN INPUT_BUFFER
			--WB CONTROL PROPAGATION
			D_WB 		=> 	EX_OUT_WB,
			--END WB CONTROL PROPAGATION
			--MEMORY CONTROL PROPAGATION
			D_MEM		=> 	EX_OUT_MEM,
			--END MEMORY CONTROL PROPAGATION
			--Execute Data PROPAGATION
			D_ALUResult	=>	EX_ALUResult,
			D_PC		=> 	ID_EX_OUT_PC,
			D_PCnext 	=> 	ID_EX_OUT_PCnext,
			D_RD1		=>	ID_EX_OUT_RD1,
			D_RD2		=>	ID_EX_OUT_RD2,
			D_EAe		=>	ID_EX_OUT_EAe,
			D_WR1		=>	ID_EX_OUT_WR1,
			D_WR2		=>	ID_EX_OUT_WR2,
			D_RR1		=>	ID_EX_OUT_RR1,
			D_RR2		=>	ID_EX_OUT_RR2,
			--END Execute Data PROPAGATION
			--OTHER PROPAGATION
			D_OPCODE	=>	ID_EX_OUT_OPCODE,
			D_INT		=>	ID_EX_OUT_INT,
			--END OTHER PROPAGATION
			--END INPUT BUFFER
			--BEGIN OUTPUT_BUFFER		
			--WB CONTROL PROPAGATION
			Q_WB 		=> 	EX_MEM_OUT_WB,
			--END WB CONTROL PROPAGATION
			--MEMORY CONTROL PROPAGATION
			Q_MEM 		=> 	EX_MEM_OUT_MEM,
			--END MEMORY CONTROL PROPAGATION
			--Execute Data PROPAGATION
			Q_ALUResult	=>	EX_MEM_OUT_ALUResult,
			Q_PC 		=> 	EX_MEM_OUT_PC,
			Q_PCnext 	=> 	EX_MEM_OUT_PCnext,
			Q_RD1		=>	EX_MEM_OUT_RD1,
			Q_RD2		=>	EX_MEM_OUT_RD2,
			Q_EAe		=>	EX_MEM_OUT_EAe,
			Q_WR1		=>	EX_MEM_OUT_WR1,
			Q_WR2		=>	EX_MEM_OUT_WR2,
			Q_RR1		=>	EX_MEM_OUT_RR1,
			Q_RR2		=>	EX_MEM_OUT_RR2,
			--END Execute Data PROPAGATION
			--OTHER PROPAGATION
			Q_OPCODE	=>	EX_MEM_OUT_OPCODE,
			Q_INT		=>	EX_MEM_OUT_INT
			--END OTHER PROPAGATION
			--END OUTPUT BUFFER			
		);

	--END EXECUTE/MEM  BUFFER
--=================================================================================================================================================
	--MEMORY STAGE

--AHMED

	--END MEMORY STAGE
--=================================================================================================================================================
	--MEM/WB BUFFER

--AHMED

	--END MEM/WB BUFFER
--=================================================================================================================================================
	--WRITE BACK STAGE

--ANOUD

	--END WRITE BACK STAGE 
END Processor_Archi;