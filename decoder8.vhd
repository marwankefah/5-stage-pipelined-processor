library ieee;
use ieee.std_logic_1164.all;

entity decoder8 is
	port(
		En : in std_logic;
		A : in std_logic_vector(2 downto 0);
		F : out std_logic_vector(7 downto 0)
	);
end decoder8;

architecture decoder8_arch of decoder8 is
	signal F_signal : std_logic_vector(7 downto 0);
begin
	with A select
		F_signal <= "00000001" when "000",
			    "00000010" when "001",
			    "00000100" when "010",
			    "00001000" when "011",
			    "00010000" when "100",
			    "00100000" when "101",
			    "01000000" when "110",
			    "10000000" when others;

	F <= F_signal when En = '1' else
	     (others=>'0');
end decoder8_arch;