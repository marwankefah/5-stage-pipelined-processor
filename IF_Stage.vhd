
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY IF_Stage IS
PORT (
       PCbranch:   IN std_logic_vector(31 downto 0);
       BranchS:    IN std_logic;
       WB:         IN std_logic_vector(31 downto 0);
       PCS:        IN std_logic;
       NOP:        IN std_logic;
       clk:        IN std_logic;
       CurrentPC:  OUT std_logic_vector(31 downto 0);
       PCnext:     OUT std_logic_vector(31 downto 0);
       Instruction:OUT std_logic_vector(31 downto 0) 
              
     );
END  IF_Stage;

ARCHITECTURE IF_Archi OF IF_Stage IS

  COMPONENT MUX_2x1 IS
  generic(
		n : integer
	 );	
	PORT( 
			in0:  IN  std_logic_vector (31 DOWNTO 0);
			in1:  IN  std_logic_vector (31 DOWNTO 0);
			sel:  IN  std_logic;
			outm: OUT std_logic_vector (31 DOWNTO 0)
		);

  END COMPONENT;
  
  COMPONENT PC IS
    
  PORT (
       clk:    IN  std_logic;
       PC_IN:  IN  std_logic_vector(31 DOWNTO 0);
       PC_OUT: OUT std_logic_vector(31 DOWNTO 0);
       NOP:    IN  std_logic
      );
      
  END COMPONENT;  
  
  COMPONENT InstructionMemory IS
    
  PORT (	
       PC:          IN  std_logic_vector(31 DOWNTO 0);  
       Instruction: OUT std_logic_vector(31 DOWNTO 0);
       clk:         IN  std_logic
      );
      
  END COMPONENT;
  
  COMPONENT PCAdder IS
    
  PORT (
        PC:      IN  std_logic_vector(31 DOWNTO 0);  
        PCas:    IN  std_logic;
        PCnext:  OUT std_logic_vector(31 DOWNTO 0)
       );
       
  END COMPONENT;
 
SIGNAL a_PCnext:  std_logic_vector(31 DOWNTO 0);
SIGNAL b_MUXout:  std_logic_vector(31 DOWNTO 0);
SIGNAL pc_MUXout: std_logic_vector(31 DOWNTO 0);
SIGNAL pcRegOut:  std_logic_vector(31 DOWNTO 0);
SIGNAL InstSel:   std_logic;
SIGNAL ImemOut:   std_logic_vector(31 DOWNTO 0);

  
BEGIN 
  b_MUX:  MUX_2x1 GENERIC MAP (32) PORT MAP(PCbranch,a_PCnext,BranchS,b_MUXout);
  pc_MUX: MUX_2x1 GENERIC MAP (32) PORT MAP(b_MUXout,WB,PCS,pc_MUXout);
    
  pcReg: PC PORT MAP(clk,pc_MUXout,pcRegOut,NOP);
    
  I_mem: InstructionMemory PORT MAP(pcRegOut,ImemOut,clk);
  
  pc_Add: PCAdder PORT MAP(pcRegOut,InstSel,a_PCnext);
  
  CurrentPC <=  pcRegOut;
  InstSel <= ImemOut(15);  
  PCnext  <= a_PCnext;
  Instruction <= ImemOut;
  
END IF_Archi;  
    
   
  
  


     
        