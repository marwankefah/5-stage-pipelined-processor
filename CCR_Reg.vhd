library ieee;
use ieee.std_logic_1164.all;

entity CCR_Reg is 
	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   enF : in std_logic;
		   stC:  in std_logic;
		   clC:  in std_logic;
		   clF:	 in std_logic;
		   D_CCR : in std_logic_vector(3 downto 0);
		   Q_CCR : out std_logic_vector(3 downto 0)
	);
end ccr_reg;

architecture ccr_reg_arch of reg is

signal register_sig: std_logic_vector(3 downto 0);
begin
	process(clk, reset,enF,register_sig)
	begin
		if (reset = '1') then 
			Q_CCR <= (others=>'0');
		elsif rising_edge(clk) then
			if(enF='1') then
			Q_CCR<=register_sig;
			end if;
		
		end if;
	end process;

register_sig(2)<='0' when clF='1' else '1' when stC ='1' else '0' when clC='1' else D_CCR(2);
register_sig(0)<='0' when clF='1' else D_CCR(0);
register_sig(1)<='0' when clF='1' else D_CCR(1);
register_sig(3)<='0';
end ccr_reg_arch;
