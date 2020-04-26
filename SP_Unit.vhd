--================================
--Stack Pointer Processing Unit
--Handles all arithmetic updates to Stack Pointer while outputing
--relevent values to the memory address selectors
--================================
--INPUTS: clk, SPS, SP2
--OUTPUTS: SP, SPplus2, SPminus2
--================================

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY SPunit IS

PORT (	
        clk:        IN  std_logic;
        SPS:        IN  std_logic_vector(1 DOWNTO 0);
        SP2:        IN  std_logic;
        SP:         OUT std_logic_vector(31 DOWNTO 0);
        SPplus2:    OUT std_logic_vector(31 DOWNTO 0);
        SPminus2:   OUT std_logic_vector(31 DOWNTO 0)
);
END SPunit;

ARCHITECTURE SPunitArchi OF SPunit IS
  
  COMPONENT SP_ALU IS
    PORT (
          SP:     IN  std_logic_vector(31 DOWNTO 0);
          SP0:    OUT std_logic_vector(31 DOWNTO 0);
          SPp2:   OUT std_logic_vector(31 DOWNTO 0);
          SPm2:   OUT std_logic_vector(31 DOWNTO 0);
          SPp4:   OUT std_logic_vector(31 DOWNTO 0)
          );
  END COMPONENT;
  
  COMPONENT MUX_4x1 IS
	generic(
		n : integer
	);	
	PORT( 
	        in0:  IN  std_logic_vector (31 DOWNTO 0);
	        in1:  IN  std_logic_vector (31 DOWNTO 0);
	        in2:  IN  std_logic_vector (31 DOWNTO 0);
	        in3:  IN  std_logic_vector (31 DOWNTO 0);
			sel:  IN  std_logic_vector (1 DOWNTO 0);
			outm: OUT std_logic_vector (31 DOWNTO 0)
		);
  END COMPONENT;
  
  COMPONENT MUX_2x1 IS
	generic(
		n : integer
	);	
	PORT( 
	        in0:  IN  std_logic_vector (31 DOWNTO 0);
	        in1:  IN  std_logic_vector (31 DOWNTO 0);
			sel:  IN  std_logic;
			outm: OUT std_logic_vector (31 DOWNTO 0)
		);
  END COMPONENT;
  
  SIGNAL q_SP:     std_logic_vector(31 DOWNTO 0);
  SIGNAL s_SP0:    std_logic_vector(31 DOWNTO 0);
  SIGNAL s_SPp2:   std_logic_vector(31 DOWNTO 0);
  SIGNAL s_SPm2:   std_logic_vector(31 DOWNTO 0);
  SIGNAL s_SPp4:   std_logic_vector(31 DOWNTO 0);
  SIGNAL outSPSm:  std_logic_vector(31 DOWNTO 0);
  SIGNAL outSP2m:  std_logic_vector(31 DOWNTO 0);
  
  BEGIN
    
    SPaluUnit: SP_ALU  PORT MAP (q_SP,s_SP0,s_SPp2,s_SPm2,s_SPp4);
    SPSmux:    MUX_4x1 GENERIC MAP (32)PORT MAP (std_logic_vector(to_unsigned(100,32)),s_SP0,s_SPp2,s_SPm2,SPS,outSPSm);
    SP2mux:    MUX_2x1 GENERIC MAP (32)PORT MAP (outSPSm,s_SPp4,SP2,outSP2m);
    
    PROCESS(clk) IS
      BEGIN 
        IF falling_edge(clk) THEN 
          q_SP <= outSP2m;
        END IF;
    END PROCESS;
     
    SP       <= s_SP0;
    SPplus2  <= s_SPp2;
    SPminus2 <= s_SPm2;
      
END SPunitArchi;
