--PCnext is PC+1 or PC+2 for operations with immediate value/effective address

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY PCAdder IS
PORT (
        PC:      IN  std_logic_vector(31 DOWNTO 0);  
        PCas:    IN  std_logic;
        PCnext:  OUT std_logic_vector(31 DOWNTO 0)
     );
END PCAdder;

ARCHITECTURE PCAdderArchi OF PCAdder IS
  
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

  SIGNAL a_MUXout: std_logic_vector (31 DOWNTO 0);
  
  BEGIN
    a_MUX: MUX_2x1 GENERIC MAP (32) PORT MAP(std_logic_vector(to_unsigned(1,32)),std_logic_vector(to_unsigned(2,32)),PCas,a_MUXout);
     
    PCnext <= std_logic_vector(unsigned(PC) + unsigned(a_MUXout));
    
END PCAdderArchi;     




      
    