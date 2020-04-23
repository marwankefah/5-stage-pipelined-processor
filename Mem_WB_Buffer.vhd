
-- THE BUFFER BETWEEN MEMORY AND WRITEBACK


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY MEM_WB_Buffer IS
PORT( 		 
		Clk,Rst,en : IN std_logic;
		
		--BEGIN INPUT_BUFFER
		  
			--WB CONTROL REGISTER INPUT
				D_WB : 		IN std_logic_vector(4 downto 0);
			--END WB CONTROL REGISTER INPUT

			--Memory Data REGISTER INPUT 
				D_MemR: 		IN std_logic_vector (31 DOWNTO 0);
				D_ALUResult:	IN std_logic_vector(31 DOWNTO 0);
				D_RD2:			IN std_logic_vector(31 DOWNTO 0);
				D_WR1:			IN std_logic_vector(2 DOWNTO 0);
				D_WR2:			IN std_logic_vector(2 DOWNTO 0);
			--END Memory Data REGISTER INPUT 

		--END INPUT BUFFER

		--BEGIN OUTPUT_BUFFER
		
			--WB CONTROL REGISTER OUTPUT
				Q_WB :  OUT std_logic_vector(4 downto 0);
			--END WB CONTROL REGISTER OUTPUT

			--Memory Data REGISTER OUTPUT 
				Q_MemR: 		OUT std_logic_vector (31 DOWNTO 0);
				Q_ALUResult:	OUT std_logic_vector(31 DOWNTO 0);
				Q_RD2:			OUT std_logic_vector(31 DOWNTO 0);
				Q_WR1:			OUT std_logic_vector(2 DOWNTO 0);
				Q_WR2:			OUT std_logic_vector(2 DOWNTO 0)
			--Memory Data REGISTER OUTPUT 
		   
		--END OUTPUT BUFFER
		
	);
		  
END MEM_WB_Buffer;

ARCHITECTURE MEM_WB_Buffer_Archi OF MEM_WB_Buffer IS

COMPONENT Reg is
GENERIC (n : integer := 32);
	PORT(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic_vector(n-1 downto 0);
		   q : out std_logic_vector(n-1 downto 0)
	    );
		
END COMPONENT;

BEGIN

		--WB CONTROL PROPAGATION
	MEM_WB_Reg:	Reg GENERIC MAP(5) PORT MAP(clk,Rst,en,D_WB,Q_WB);
		--END WB CONTROL PROPAGATION
		
		--MEM_Stage Data PROPAGATION
	MEM_MemR_Reg: 		Reg GENERIC MAP(32) PORT MAP(clk,Rst,en,D_MemR,Q_MemR);
	MEM_ALUResult_Reg:	Reg GENERIC MAP(32) PORT MAP(clk,Rst,en,D_ALUResult,Q_ALUResult);
	MEM_RD2_Reg:		Reg GENERIC MAP(32) PORT MAP(clk,Rst,en,D_RD2,Q_RD2);	
	MEM_WR1_Reg:		Reg GENERIC MAP(3) PORT MAP(clk,Rst,en,D_WR1,Q_WR1);	
	MEM_WR2_Reg:		Reg GENERIC MAP(3) PORT MAP(clk,Rst,en,D_WR2,Q_WR2);		
		--END MEM_Stage Data PROPAGATION
	
END MEM_WB_Buffer_Archi;















