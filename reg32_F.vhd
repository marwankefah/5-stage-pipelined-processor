library ieee;
use ieee.std_logic_1164.all;

entity reg32_F is 
	port(
		clk : in std_logic;
		reset : in std_logic;
		en : in std_logic;
		d : in std_logic_vector(31 downto 0);
		q : out std_logic_vector(31 downto 0)
	);
end reg32_F;

architecture reg32_F_arch of reg32_F is
begin
	process(clk)
	begin
	  if (reset = '1') then
				q <= (others=>'0');
		elsif falling_edge(clk) then
		  if (en = '1') then
				q <= d;
			end if;		
		end if;
	end process;
end reg32_F_arch;