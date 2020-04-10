
--INPUT A	the first operand
--INPUT B	the second operand
--INPUT	sel	the selection lines from the control register
--OUTPUT ALUResult 	the output of the alu sized 32 bit
--OUTPUT CCR		condition flags sized 3 bits
	-- Z<0>:=CCR<0> ; zero flag, change after arithmetic, logical, or shift operations
	--N<0>:=CCR<1> ; negative flag, change after arithmetic, logical, or shift operations
	--C<0>:=CCR<2> ; carry flag, change after arithmetic or shift operations.


-- ALU OPERATIONs
--	SEL	Result
--	000	A+B
--	001	A-B
--	010	A&B
--	011	A|B
--	100	!A
--	101	SHL A
--	110	SHR A
--	111	Pass A

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY ALU IS
GENERIC (n : integer := 32);
PORT (	inA:IN std_logic_vector(n-1 DOWNTO 0);
 	inB : IN std_logic_vector(n-1 DOWNTO 0) ;
	sel: in std_logic_vector (2 DOWNTO 0);
	ALUOut: OUT std_logic_vector(n-1 DOWNTO 0);
	CCR : OUT std_logic_vector(2 DOWNTO 0));
END ALU;



Architecture ALUArchi of ALU IS
signal extendedOutput:  unsigned(n DOWNTO 0);
signal inAUnsigned:	unsigned(n-1 DOWNTO 0);
signal inBUnsigned:	unsigned(n-1 DOWNTO 0);
Begin

inAUnsigned<=unsigned(inA);
inBUnsigned<=unsigned(inB);


process(sel,inAUnsigned,inBUnsigned)
begin
case sel is 
when "000"   =>   extendedOutput<= ('0'&inAUnsigned)  +  ('0'&inBUnsigned); 
when "001"   =>   extendedOutput<= ('0'&inAUnsigned)  -  ('0'&inBUnsigned);
when "010"   =>   extendedOutput<= ('0'&inAUnsigned) and ('0'&inBUnsigned);
when "011"   =>   extendedOutput<= ('0'&inAUnsigned)  or ('0'&inBUnsigned);
when "100"   =>   extendedOutput<= '0'& (not inAUnsigned);
when "101"   =>   extendedOutput<= inAUnsigned(n-1)&inAUnsigned(n-2 DOWNTO 0)&'0';
when "110"   =>   extendedOutput<= inAUnsigned(0)&'0'&inAUnsigned(n-1 DOWNTO 1);
when "111"   =>   extendedOutput<= '0'& inAUnsigned;
when others   =>  extendedOutput<= (extendedOutput(n DOWNTO 0)'range => '0');
end case; 
end process;

--Output after operation
ALUOut<=std_logic_vector(extendedOutput(n-1 DOWNTO 0));
-- Zero Flag
CCR(0)<='1' when extendedOutput(n-1 DOWNTO 0) = (extendedOutput(n-1 DOWNTO 0)'range => '0') else '0';
--Negative Flag knows as Sign Flag
CCR(1)<=extendedOutput(n-1);
--Carry out flag
CCR(2)<=extendedOutput(n);
END ALUArchi;








