LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_4x1 IS
	PORT( 
		in0:  IN  std_logic_vector (31 DOWNTO 0);
		in1:  IN  std_logic_vector (31 DOWNTO 0);
		in2:  IN  std_logic_vector (31 DOWNTO 0);
		in3:  IN  std_logic_vector (31 DOWNTO 0);
		sel:  IN  std_logic_vector (1 DOWNTO 0);
		outm: OUT std_logic_vector (31 DOWNTO 0)
	);
END MUX_4x1;


ARCHITECTURE MUX_4x1_Archi OF MUX_4x1 IS
BEGIN	
	WITH sel SELECT
		outm <= in0 WHEN "00",
		        in1 WHEN "01",
		        in2 WHEN "10",
		        in3 WHEN "11",
			(OTHERS=>'0') WHEN OTHERS;				
END MUX_4x1_Archi;