
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY IF_Stage IS
PORT (
	   clk:        IN std_logic;
       PCbranch:   IN std_logic_vector(31 downto 0);
       BranchS:    IN std_logic;
       WB:         IN std_logic_vector(31 downto 0);
       PCreset:    IN std_logic;
       PCS:        IN std_logic;
       PCen:       IN std_logic;
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
  
  COMPONENT reg IS 
	GENERIC(n : integer);
	PORT(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic_vector(n-1 downto 0);
		   q : out std_logic_vector(n-1 downto 0));
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
  b_MUX:  MUX_2x1 GENERIC MAP (32) PORT MAP(a_PCnext,PCbranch,BranchS,b_MUXout);
  pc_MUX: MUX_2x1 GENERIC MAP (32) PORT MAP(b_MUXout,WB,PCS,pc_MUXout);
    
  pcReg: reg GENERIC MAP (32) PORT MAP(clk,PCreset,PCen,pc_MUXout,pcRegOut);
    
  I_mem: InstructionMemory PORT MAP(pcRegOut,ImemOut,clk);
  
  pc_Add: PCAdder PORT MAP(pcRegOut,InstSel,a_PCnext);
  
  CurrentPC <=  pcRegOut;
  InstSel <= ImemOut(15);  
  PCnext  <= a_PCnext;
  Instruction <= ImemOut;
  
END IF_Archi;  
    
   
  
  


     
        