
-- THE BUFFER BETWEEN EXCUTE AND MEMORY


-- TODO 1-CHECK SIZE OF EACH IN AND OUT
--	2- MUX IN EXECUTE STAGE SIGNALS AND IMPLMENTATION

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY EX_MEM_Buffer IS
GENERIC ( n : integer := 32);
PORT( 		 
		Clk,Rst,en : IN std_logic;
	         --BEGIN INPUT_BUFFER
		  
			--WB CONTROL PROPAGATION

			d_WBS:  IN std_logic;
			d_PCS:  IN std_logic;
			d_WDRS: IN std_logic;
			d_WE1R: IN std_logic;
			d_WE2R: IN std_logic;

			--END WB CONTROL PROPAGATION


			--MEMORY CONTROL PROPAGATION
			
			d_SPS: 		IN std_logic_vector(1 DOWNTO 0);
			d_SP2: 		IN std_logic;
			d_INTCTRL: 	IN std_logic_vector(1 DOWNTO 0);
			d_WDS:	 	IN std_logic_vector(1 DOWNTO 0);
			d_DAS:	 	IN std_logic_vector(1 DOWNTO 0);
			d_MR:	 	IN std_logic;
			d_MW:	 	IN std_logic;

			--END MEMORY CONTROL PROPAGATION


			--Execute Data PROPAGATION

 			d_PCnext: 	IN std_logic_vector(31 DOWNTO 0);
			d_ALUResult:	IN std_logic_vector(n-1 DOWNTO 0);
			d_RD1:		IN std_logic_vector(n-1 DOWNTO 0);
			d_RD2:		IN std_logic_vector(n-1 DOWNTO 0);
			d_EAe:		IN std_logic_vector(n-1 DOWNTO 0);
			d_WR1:		IN std_logic_vector(2 DOWNTO 0);
			d_WR2:		IN std_logic_vector(2 DOWNTO 0);
			d_RR1:		IN std_logic_vector(2 DOWNTO 0);
			d_RR2:		IN std_logic_vector(2 DOWNTO 0);

			--END Execute Data PROPAGATION
			
			--OTHER PROPAGATION
			d_OPCODE:	IN std_logic_vector(4 DOWNTO 0);
			d_INT:		IN std_logic;

			--END OTHER PROPAGATION
		   
		--END INPUT BUFFER

	           --BEGIN OUTPUT_BUFFER
		
			--WB CONTROL PROPAGATION

			q_WBS:  OUT std_logic;
			q_PCS:  OUT std_logic;
			q_WDRS: OUT std_logic;
			q_WE1R: OUT std_logic;
			q_WE2R: OUT std_logic;

			--END WB CONTROL PROPAGATION


			--MEMORY CONTROL PROPAGATION
			
			q_SPS: 		OUT std_logic_vector(1 DOWNTO 0);
			q_SP2: 		OUT std_logic;
			q_INTCTRL: 	OUT std_logic_vector(1 DOWNTO 0);
			q_WDS:	 	OUT std_logic_vector(1 DOWNTO 0);
			q_DAS:	 	OUT std_logic_vector(1 DOWNTO 0);
			q_MR:	 	OUT std_logic;
			q_MW:	 	OUT std_logic;

			--END MEMORY CONTROL PROPAGATION


			--Execute Data PROPAGATION

 			q_PCnext: 	OUT std_logic_vector(31 DOWNTO 0);
			q_ALUResult:	OUT std_logic_vector(n-1 DOWNTO 0);
			q_RD1:		OUT std_logic_vector(n-1 DOWNTO 0);
			q_RD2:		OUT std_logic_vector(n-1 DOWNTO 0);
			q_EAe:		OUT std_logic_vector(n-1 DOWNTO 0);
			q_WR1:		OUT std_logic_vector(2 DOWNTO 0);
			q_WR2:		OUT std_logic_vector(2 DOWNTO 0);
			q_RR1:		OUT std_logic_vector(2 DOWNTO 0);
			q_RR2:		OUT std_logic_vector(2 DOWNTO 0);

			--END Execute Data PROPAGATION
			
			--OTHER PROPAGATION
			q_OPCODE:	OUT std_logic_vector(4 DOWNTO 0);
			q_INT:		OUT std_logic

			--END OTHER PROPAGATION
		   


		--END OUTPUT BUFFER
		
					);
		  
END EX_MEM_Buffer;



ARCHITECTURE EX_MEM_Buffer_Archi OF EX_MEM_Buffer IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
			
		--WB CONTROL PROPAGATION
			q_WBS <=  	'0';
			q_PCS <=  	'0';
			q_WDRS<=  	'0';
			q_WE1R<=  	'0';
			q_WE2R<=  	'0';
			--END WB CONTROL PROPAGATION

			--MEMORY CONTROL PROPAGATION
			q_SPS<=  	(OTHERS=>'0');
			q_SP2<=  	'0';		
			q_INTCTRL<=	(OTHERS=>'0'); 	
			q_WDS<=  	(OTHERS=>'0'); 	
			q_DAS<=  	(OTHERS=>'0');	 	
			q_MR<=  	'0';	 	
			q_MW<=  	'0'; 	
			--END MEMORY CONTROL PROPAGATION

			--Execute Data PROPAGATION

 			q_PCnext<=  	(OTHERS=>'0');	
			q_ALUResult<=  	(OTHERS=>'0');	
			q_RD1<=  	(OTHERS=>'0');	
			q_RD2<=  	(OTHERS=>'0');	
			q_EAe<=  	(OTHERS=>'0');	
			q_WR1<=  	(OTHERS=>'0');	
			q_WR2<=  	(OTHERS=>'0');	
			q_RR1<=  	(OTHERS=>'0');	
			q_RR2<=  	(OTHERS=>'0');	
			--END Execute Data PROPAGATION
			
			--OTHER PROPAGATION
			q_OPCODE<=  	(OTHERS=>'0');	
			q_INT<=  	'0';	

			--END OTHER PROPAGATION
	
ELSIF rising_edge(Clk) 	  THEN
		IF EN='1' THEN

		--WB CONTROL PROPAGATION
			q_WBS <=  	d_WBS;
			q_PCS <=	d_PCS;  	
			q_WDRS<=	d_WDRS;  	
			q_WE1R<=	d_WE1R;  	
			q_WE2R<=	D_WE2R;  	
			--END WB CONTROL PROPAGATION

			--MEMORY CONTROL PROPAGATION
			q_SPS<= 	d_SPS; 	
			q_SP2<= 	d_SP2; 			
			q_INTCTRL<=	d_INTCTRL;	
			q_WDS<=  	d_WDS;	 	
			q_DAS<=  	d_DAS;	 	
			q_MR<=  	d_MR;	 	
			q_MW<=  	d_MW;	
			--END MEMORY CONTROL PROPAGATION

			--Execute Data PROPAGATION

 			q_PCnext<=  	d_PCnext;
			q_ALUResult<=	d_ALUResult;  	
			q_RD1<=  	d_RD1;
			q_RD2<=  	d_RD2;
			q_EAe<=  	d_EAe;
			q_WR1<=  	d_WR1;
			q_WR2<=  	d_WR2;	
			q_RR1<=  	d_RR1;	
			q_RR2<=  	d_RR2;	
			--END Execute Data PROPAGATION
			
			--OTHER PROPAGATION
			q_OPCODE<=  	d_OPCODE;		
			q_INT<=  	d_INT;	

			--END OTHER PROPAGATION
		   
		END IF;
END IF;
END PROCESS;
END EX_MEM_Buffer_Archi;




