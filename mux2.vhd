--GENERIC 2x1 Multiplexer

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_2x1 IS

	PORT( 
			in0:  IN  std_logic_vector (31 DOWNTO 0);
			in1:  IN  std_logic_vector (31 DOWNTO 0);
			sel:  IN  std_logic;
			outm: OUT std_logic_vector (31 DOWNTO 0)
		);

END MUX_2x1;


ARCHITECTURE MUX_2x1_Archi OF MUX_2x1 IS
  
	BEGIN	
    WITH sel SELECT
	   outm <= 	in0 WHEN '0',
		        in1 WHEN '1',
				(OTHERS=>'0') WHEN OTHERS;
  
END MUX_2x1_Archi;






