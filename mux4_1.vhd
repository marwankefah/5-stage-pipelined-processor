LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_4x1_1 IS
	PORT( 
		in0:  IN  std_logic;
		in1:  IN  std_logic;
		in2:  IN  std_logic;
		in3:  IN  std_logic;
		sel:  IN  std_logic_vector (1 DOWNTO 0);
		outm: OUT std_logic
	);
END MUX_4x1_1;


ARCHITECTURE MUX_4x1_1_Archi OF MUX_4x1_1 IS
BEGIN	
	WITH sel SELECT
		outm <= in0 WHEN "00",
		        in1 WHEN "01",
		        in2 WHEN "10",
		        in3 WHEN OTHERS;				
END MUX_4x1_1_Archi;
