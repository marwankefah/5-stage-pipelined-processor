
-- THE BUFFER BETWEEN EXCUTE AND MEMORY


-- TODO 1-CHECK SIZE OF EACH IN AND OUT
--	2- MUX IN EXECUTE STAGE SIGNALS AND IMPLMENTATION

LIBRARY IEEE;
USE IEEE.stD_logic_1164.all;
ENTITY EX_MEM_Buffer IS
PORT( 		 
		Clk,Rst,en : IN stD_logic;
	         --BEGIN INPUT_BUFFER
		  
			--WB CONTROL PROPAGATION
				D_WB : 		IN std_logic_vector(4 downto 0);
			--END WB CONTROL PROPAGATION


			--MEMORY CONTROL PROPAGATION
				D_MEM : 	IN std_logic_vector(10 downto 0);
			--END MEMORY CONTROL PROPAGATION


			--Execute Data PROPAGATION
				D_ALUResult:	IN stD_logic_vector(31 DOWNTO 0);
				D_PC : 		IN std_logic_vector(31 downto 0);
 				D_PCnext : 	IN std_logic_vector(31 downto 0);
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
				Q_WB :  OUT std_logic_vector(4 downto 0);
			--END WB CONTROL PROPAGATION


			--MEMORY CONTROL PROPAGATION
				Q_MEM : OUT std_logic_vector(10 downto 0);
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
		  
END EX_MEM_Buffer;



ARCHITECTURE EX_MEM_Buffer_Archi OF EX_MEM_Buffer IS

COMPONENT Reg is
GENERIC (n : integer := 32);
	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic_vector(n-1 downto 0);
		   q : out std_logic_vector(n-1 downto 0)
	    );
END COMPONENT;
COMPONENT reg1 is 
	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic;
		   q : out std_logic
	    );
end COMPONENT;


BEGIN
			--WB CONTROL PROPAGATION
	EX_WB_Reg:		Reg generic map(5) port map(Clk,Rst,en,D_WB,Q_WB);

			--END WB CONTROL PROPAGATION

			--MEMORY CONTROL PROPAGATION
	EX_MEM_Reg:		Reg generic map(11) port map(Clk,Rst,en,D_MEM,Q_MEM);
		
			--END MEMORY CONTROL PROPAGATION

			--Execute Data PROPAGATION
	EX_PC_Reg:		Reg generic map(32) port map(Clk,Rst,en,D_PC,Q_PC);
	EX_PCnext_Reg:		Reg generic map(32) port map(Clk,Rst,en,D_PCnext,Q_PCnext);
	EX_ALURes_Reg:		Reg generic map(32) port map(Clk,Rst,en,D_ALUResult,Q_ALUResult);
	EX_RD1_Reg:		Reg generic map(32) port map(Clk,Rst,en,D_RD1,Q_RD1);	
	EX_RD2_Reg:		Reg generic map(32) port map(Clk,Rst,en,D_RD2,Q_RD2);	
	EX_EAe_Reg:		Reg generic map(32) port map(Clk,Rst,en,D_EAe,Q_EAe); 
	EX_WR1_Reg:		Reg generic map(3) port map(Clk,Rst,en,D_WR1,Q_WR1); 
	EX_WR2_Reg:		Reg generic map(3) port map(Clk,Rst,en,D_WR2,Q_WR2); 
	EX_RR1_Reg:		Reg generic map(3) port map(Clk,Rst,en,D_RR1,Q_RR1); 
	EX_RR2_Reg:		Reg generic map(3) port map(Clk,Rst,en,D_RR2,Q_RR2); 

			--END Execute Data PROPAGATION
			
			--OTHER PROPAGATION
	EX_OPCODE_Reg:		Reg generic map(6) port map(Clk,Rst,en,D_OPCODE,Q_OPCODE); 
	EX_INT_Reg:		Reg1 		   port map(Clk,Rst,en,D_INT,Q_INT); 

			--END OTHER PROPAGATION
		   

END EX_MEM_Buffer_Archi;




