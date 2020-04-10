LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_generic IS 
	Generic ( n : Integer:=16);
	PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic_vector (1 DOWNTO 0);
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END mux_generic;


ARCHITECTURE with_select_mux OF mux_generic is
	BEGIN
		
with Sel select
	out1 <= in0 when "00",
		in1 when "01",
		in2 when "10",
		in3 when "11",
	    (in0(n-1 DOWNTO 0)'range => '0')  when others;
END with_select_mux;

