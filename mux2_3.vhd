LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_2x1_3 IS
	PORT( 
		in0:  IN  std_logic_vector (2 DOWNTO 0);
		in1:  IN  std_logic_vector (2 DOWNTO 0);
		sel:  IN  std_logic;
		outm: OUT std_logic_vector (2 DOWNTO 0)
	);
END MUX_2x1_3;


ARCHITECTURE MUX_2x1_3_Archi OF MUX_2x1_3 IS  
BEGIN	
	WITH sel SELECT
		outm <=	in0 WHEN '0',
			in1 WHEN '1',
			(OTHERS=>'0') WHEN OTHERS; 
END MUX_2x1_3_Archi;






