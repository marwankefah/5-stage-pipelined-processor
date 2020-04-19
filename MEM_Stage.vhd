
--Main Component of Memory Stage

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY MEMstage IS
GENERIC (n : integer := 32);
PORT (	
        clk:        IN  std_logic;
		--Control Signals
		MR:			IN  std_logic;
		MW:			IN  std_logic;
		--Selector Control Lines
        SPS:        IN  std_logic_vector(1 DOWNTO 0);
        SP2:        IN  std_logic;
		WDS:		IN  std_logic_vector(1 DOWNTO 0);
		DAS:		IN  std_logic_vector(1 DOWNTO 0);
		INTCTRL:	IN  std_logic_vector(1 DOWNTO 0);
		--Data To Store
		CCR:		IN 	std_logic_vector(3 DOWNTO 0);
		PCnext:		IN 	std_logic_vector(31 DOWNTO 0);
		ALUResult: 	IN	std_logic_vector(31 DOWNTO 0);
		--Addresses
		EAe:		IN	std_logic_vector(31 DOWNTO 0);
		--Data Loaded
		RD:			OUT	std_logic_vector(31 DOWNTO 0)
);
END MEMstage;

ARCHITECTURE MEMstageArchi OF MEMstage IS 

	--Data Memory Module
	COMPONENT DataMemory IS
		GENERIC (n : integer := 32);
		PORT(	
				ADDRESS: IN  std_logic_vector(31 DOWNTO 0);
				WD:      IN  std_logic_vector(n-1 DOWNTO 0) ;
				RD:      OUT std_logic_vector (n-1 DOWNTO 0);
				MW:      IN  std_logic;
				MR:      IN  std_logic;
				clk:     IN  std_logic
			);
	END COMPONENT;

	--Generic MUX
	COMPONENT MUX_4x1 IS
	Generic ( n : Integer:=32);
	PORT( 
	        in0:  IN  std_logic_vector (n-1 DOWNTO 0);
	        in1:  IN  std_logic_vector (n-1 DOWNTO 0);
	        in2:  IN  std_logic_vector (n-1 DOWNTO 0);
	        in3:  IN  std_logic_vector (n-1 DOWNTO 0);
			sel:  IN  std_logic_vector (1 DOWNTO 0);
			outm: OUT std_logic_vector (n-1 DOWNTO 0)
		);
	END COMPONENT;
	
	--SP Processing Unit
	COMPONENT SPunit IS
	GENERIC (n : integer := 32);
	PORT(	
			clk:        IN  std_logic;
			SPS:        IN  std_logic_vector(1 DOWNTO 0);
			SP2:        IN  std_logic;
			SP:         OUT std_logic_vector(31 DOWNTO 0);
			SPplus2:    OUT std_logic_vector(31 DOWNTO 0);
			SPminus2:   OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	--address selection
	SIGNAL a_SP	:		std_logic_vector(31 DOWNTO 0);
	SIGNAL a_SPp2:		std_logic_vector(31 DOWNTO 0);
	SIGNAL a_SPm2:		std_logic_vector(31 DOWNTO 0);
	SIGNAL addrMUXout:	std_logic_vector(31 DOWNTO 0);
	SIGNAL intMUXout:	std_logic_vector(31 DOWNTO 0);
	--data selection
	SIGNAL q_PC:		std_logic_vector(31 DOWNTO 0);
	SIGNAL q_CCR:		std_logic_vector(31 DOWNTO 0);
	SIGNAL dataMUXout:	std_logic_vector(31 DOWNTO 0); 
	
	BEGIN
		
		--Multiplexers to detemrine data and address
		u_SP:		SPunit 	PORT MAP(clk,SPS,SP2,a_SP,a_SPp2,a_SPm2);
		addrMUX: 	MUX_4x1 PORT MAP(a_SP,a_SPm2,intMUXout,EAe,DAS,addrMUXout);
		intMUX: 	MUX_4x1 PORT MAP(std_logic_vector(to_unsigned(0,32)),std_logic_vector(to_unsigned(2,32)),a_SPm2,a_SPm2,INTCTRL,intMUXout);
		dataMUX:	MUX_4x1 PORT MAP(ALUResult,q_PC,PCnext,q_CCR,WDS,dataMUXout);
		--Main Data Memory Module
		datamem:	DataMemory PORT MAP(addrMUXout,dataMUXout,RD,MW,MR,clk);
		
		--Writing on CCR and PC registers
		PROCESS (clk) IS
			BEGIN
				IF falling_edge(clk) THEN
					q_PC <=PCnext;
					q_CCR <= std_logic_vector(to_unsigned(0,28)) & CCR;
				END IF;
		END PROCESS;
	
END MEMstageArchi;
	