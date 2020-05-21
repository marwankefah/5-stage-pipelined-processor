LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity InterruptHandling is
port (
       INT:            in std_logic;
       RST:            in std_logic;
       OPCODE:         in std_logic_vector(5 DOWNTO 0); 
       ID_INTS:        out std_logic_vector(1 DOWNTO 0); 
       EX_INTS:        out std_logic_vector(1 DOWNTO 0)
    );
end InterruptHandling;

 architecture Arch_INThandling of InterruptHandling is
 begin
 
  ID_INTS <= "00" when INT = '1' else 
             "10" when OPCODE = "011110" else --RTI_OP 
             "11" when RST = '1' else 
             "01";
          
  EX_INTS <= "00" when RST = '1' else 
             "10" when INT = '1' else
             "01";
                      
 end Arch_INThandling;
       

