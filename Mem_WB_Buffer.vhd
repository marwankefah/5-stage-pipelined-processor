
-- THE BUFFER BETWEEN MEMORY AND WRITEBACK


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY MEM_WB_Buffer IS
GENERIC ( n : integer := 32);
PORT( 		 
		Clk,Rst,en : IN std_logic;
		
		--BEGIN INPUT_BUFFER
		  
			--WB CONTROL REGISTER INPUT
				d_WBS:  IN std_logic;
				d_PCS:  IN std_logic;
				d_WDRS: IN std_logic;
				d_WE1R: IN std_logic;
				d_WE2R: IN std_logic;
			--END WB CONTROL REGISTER INPUT

			--Memory Data REGISTER INPUT 
				d_MemR: 		IN std_logic_vector (n-1 DOWNTO 0);
				d_ALUResult:	IN std_logic_vector(n-1 DOWNTO 0);
				d_RD2:			IN std_logic_vector(n-1 DOWNTO 0);
				d_WR1:			IN std_logic_vector(2 DOWNTO 0);
				d_WR2:			IN std_logic_vector(2 DOWNTO 0);
				d_RR1:			IN std_logic_vector(2 DOWNTO 0);
				d_RR2:			IN std_logic_vector(2 DOWNTO 0);
			--END Memory Data REGISTER INPUT 

		--END INPUT BUFFER

		--BEGIN OUTPUT_BUFFER
		
			--WB CONTROL REGISTER OUTPUT
				q_WBS:  OUT std_logic;
				q_PCS:  OUT std_logic;
				q_WDRS: OUT std_logic;
				q_WE1R: OUT std_logic;
				q_WE2R: OUT std_logic;
			--END WB CONTROL REGISTER OUTPUT

			--Memory Data REGISTER OUTPUT 
				q_MemR: 		OUT std_logic_vector (n-1 DOWNTO 0);
				q_ALUResult:	OUT std_logic_vector(n-1 DOWNTO 0);
				q_RD2:			OUT std_logic_vector(n-1 DOWNTO 0);
				q_WR1:			OUT std_logic_vector(2 DOWNTO 0);
				q_WR2:			OUT std_logic_vector(2 DOWNTO 0)
			--Memory Data REGISTER OUTPUT 
		   
		--END OUTPUT BUFFER
		
	);
		  
END MEM_WB_Buffer;

ARCHITECTURE MEM_WB_Buffer_Archi OF MEM_WB_Buffer IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
		
	--Reset State Zero Propagation
	
		--WB CONTROL PROPAGATION
			q_WBS <=  	'0';
			q_PCS <=  	'0';
			q_WDRS<=  	'0';
			q_WE1R<=  	'0';
			q_WE2R<=  	'0';
		--END WB CONTROL PROPAGATION

		--Memory Data PROPAGATION
 			q_MemR<=  	(OTHERS=>'0');	
			q_ALUResult<=  	(OTHERS=>'0');
			q_RD2<=  	(OTHERS=>'0');	
			q_WR1<=  	(OTHERS=>'0');	
			q_WR2<=  	(OTHERS=>'0');
		--END Memory Data PROPAGATION
			
	
ELSIF rising_edge(Clk) THEN
		
		IF EN='1' THEN

	--Normal Case Pipeline Propagation
	
		--WB CONTROL PROPAGATION
			q_WBS <= d_WBS;
			q_PCS <=	d_PCS;  	
			q_WDRS<=	d_WDRS;  	
			q_WE1R<=	d_WE1R;  	
			q_WE2R<=	D_WE2R;  	
		--END WB CONTROL PROPAGATION

		--Memory Data PROPAGATION
 			q_MemR<=  	d_MemR;
			q_ALUResult<=	d_ALUResult;
			q_RD2<=  	d_RD2;
			q_WR1<=  	d_WR1;
			q_WR2<=  	d_WR2;
		--END Memory Data PROPAGATION
		   
		END IF;
END IF;
END PROCESS;
END MEM_WB_Buffer_Archi;