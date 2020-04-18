
--Data Memory Module

--INPUTS: ADDRESS (R&W), WD (Write Data), MW (Write Enable), MR (Read Enable)
--OUTPUTS: RD (Read Data)

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DataMemory IS
GENERIC (n : integer := 32);
PORT (	
       ADDRESS: IN  std_logic_vector(31 DOWNTO 0);
 	     WD:      IN  std_logic_vector(n-1 DOWNTO 0) ;
	     RD:      OUT std_logic_vector (n-1 DOWNTO 0);
	     MW:      IN  std_logic;
	     MR:      IN  std_logic;
	     clk:     IN  std_logic
	    );
END DataMemory;

ARCHITECTURE DataMemArchi OF DataMemory IS
  
  COMPONENT GenRam IS
	GENERIC(
	  DataWidth    : INTEGER := 16;
	  AddressWidth : INTEGER := 32;
	  AddressSpace : INTEGER := 63 --(2^31-1)
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
  
  R_Din1 <= WD(31 DOWNTO 16);
  R_Din2 <= WD(15 DOWNTO 0);
  dm_RAM: GenRam PORT MAP (clk,MW,ADDRESS,R_Din1,R_Din2,R_Dout1,R_Dout2); 

PROCESS (MR,clk) IS
  BEGIN
		IF MR = '1' AND falling_edge(clk) THEN
			RD(31 DOWNTO 16) <= R_Dout1;
			RD(15 DOWNTO 0) <= R_Dout2;
		ELSE
			RD <= (OTHERS=>'Z');	
		END IF;
  END PROCESS;
  
END DataMemArchi;