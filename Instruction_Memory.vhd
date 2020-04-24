LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY InstructionMemory IS
PORT (	
       PC:          IN  std_logic_vector(31 DOWNTO 0);  
       Instruction: OUT std_logic_vector(31 DOWNTO 0);
       clk:         IN  std_logic
      );
END InstructionMemory;

ARCHITECTURE InstMemArchi OF InstructionMemory IS
  
COMPONENT GenRam IS
	GENERIC(
	  DataWidth    : INTEGER := 16;
	  AddressWidth : INTEGER := 32;
	  AddressSpace : INTEGER := 39 --(2^31-1)
	  );
	PORT(
		clk     : IN  std_logic;
		we      : IN  std_logic;
		address : IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
		datain1 : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
		datain2 : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
		dataout1: OUT std_logic_vector(DataWidth-1 DOWNTO 0);
		dataout2: OUT std_logic_vector(DataWidth-1 DOWNTO 0)
		);
  END COMPONENT;

  SIGNAL R_we:    std_logic;
  SIGNAL R_Din1:  std_logic_vector(15 DOWNTO 0);
  SIGNAL R_Din2:  std_logic_vector(15 DOWNTO 0);
  SIGNAL R_Dout1: std_logic_vector(15 DOWNTO 0);
  SIGNAL R_Dout2: std_logic_vector(15 DOWNTO 0);
    
BEGIN
  
  im_RAM: GenRam PORT MAP (clk,R_we,PC,R_Din1,R_Din2,R_Dout1,R_Dout2);
  
  R_we <= '0';
  R_Din1 <= (others => '0');
  R_Din2 <= (others => '0');
  Instruction(31 DOWNTO 16) <= R_Dout1; 
  Instruction(15 DOWNTO 0)  <= R_Dout2;

END InstMemArchi;     