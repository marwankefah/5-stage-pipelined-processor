library ieee;
use ieee.std_logic_1164.all;

entity reg1 is 
	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic;
		   q : out std_logic
	    );
end reg1;

architecture reg1_arch of reg1 is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				q <= '0';
			elsif (en = '1') then
				q <= d;
			end if;
		end if;
	end process;
end reg1_arch;
