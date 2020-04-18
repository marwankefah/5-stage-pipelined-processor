
--SP Arithmetic Module
--Calculates all possible next values of the Stack Pointer
--INPUTS: SP
--OUTPUTS: SP0, SPp2, SPm2, SPp4

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY SP_ALU IS
	PORT(
			SP:     IN  std_logic_vector(31 DOWNTO 0);
			SP0:    OUT std_logic_vector(31 DOWNTO 0);
			SPp2:   OUT std_logic_vector(31 DOWNTO 0);
			SPm2:   OUT std_logic_vector(31 DOWNTO 0);
			SPp4:   OUT std_logic_vector(31 DOWNTO 0)
		);
END SP_ALU;

ARCHITECTURE SP_ALU_Archi OF SP_ALU IS
  BEGIN
    
    SP0  <= SP;
    SPp2 <= std_logic_vector(unsigned(SP)+"10");
    SPm2 <= std_logic_vector(unsigned(SP)-"10");
    SPp4 <= std_logic_vector(unsigned(SP)+"100");
    
END SP_ALU_Archi;