library ieee;
use ieee.std_logic_1164.all;

entity tri_buff is
	port(
		En : in std_logic;
		A : in std_logic_vector(31 downto 0);		
		F : out std_logic_vector(31 downto 0)
	);
end tri_buff;

architecture tri_buff_arch of tri_buff is
begin
	F <= A when En = '1' else
		(others => 'Z');
end tri_buff_arch;
