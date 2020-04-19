LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PC IS
PORT (
       clk:    IN  std_logic;
       PC_IN:  IN  std_logic_vector(31 DOWNTO 0);
       PC_OUT: OUT std_logic_vector(31 DOWNTO 0);
       NOP:    IN  std_logic
      );
END PC;

ARCHITECTURE PCArchi OF PC IS  

COMPONENT reg32 is 
	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   en : in std_logic;
		   d : in std_logic_vector(31 downto 0);
		   q : out std_logic_vector(31 downto 0)
	    );
end COMPONENT;

 SIGNAL RST:  std_logic;
 SIGNAL PCen: std_logic;

BEGIN
  
PCreg : reg32 PORT MAP(clk,RST,PCen,PC_IN,PC_OUT);

RST  <= '0';
PCen <= not NOP;  

END PCArchi;       
        
       
   