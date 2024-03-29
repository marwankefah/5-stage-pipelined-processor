library ieee;
use ieee.std_logic_1164.all;

entity reg is 
	generic(
		n : integer
	);

	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic_vector(n-1 downto 0);
		   q : out std_logic_vector(n-1 downto 0)
	);
end reg;

architecture reg_arch of reg is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				q <= (others=>'0');
			elsif (en = '1') then
				q <= d;
			end if;
		end if;
	end process;
end reg_arch;
