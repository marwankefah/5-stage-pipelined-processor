
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
PORT (	
  prevC: IN std_logic;
  inA:IN std_logic_vector(31 DOWNTO 0);
 	inB : IN std_logic_vector(31 DOWNTO 0) ;
	sel: IN std_logic_vector (2 DOWNTO 0);
	ALUOut: OUT std_logic_vector(31 DOWNTO 0);
	CCR : OUT std_logic_vector(3 DOWNTO 0));
END ALU;



Architecture ALUArchi of ALU IS
signal extendedOutput:  unsigned(32 DOWNTO 0):=(others=>'0');
signal inAUnsigned:	unsigned(31 DOWNTO 0);
signal inBUnsigned:	unsigned(31 DOWNTO 0);

Begin

inAUnsigned<=unsigned(inA);
inBUnsigned<=unsigned(inB);


process(sel,inAUnsigned,inBUnsigned)
variable shiftCount:integer :=0;
begin
shiftCount:=   to_integer(unsigned(inB)); -- can be more optimized
case sel is 
when "000"   =>   extendedOutput<= ('0'&inAUnsigned)  +  ('0'&inBUnsigned); 
when "001"   =>   extendedOutput<= ('0'&inAUnsigned)  -  ('0'&inBUnsigned);
when "010"   =>   extendedOutput<= ('0'&inAUnsigned) and ('0'&inBUnsigned);
when "011"   =>   extendedOutput<= ('0'&inAUnsigned)  or ('0'&inBUnsigned);
when "100"   =>   extendedOutput<= '0'& (not inAUnsigned);

when "101"   =>   
if shiftCount>0 and shiftCount<33 then
 		  extendedOutput<= inAUnsigned(32-shiftCount)& unsigned(std_logic_vector(shift_left(inAUnsigned,shiftCount))); -- Shift left
ELSIF shiftCount=0 THEN
		  extendedOutput<= '0'& inAUnsigned;
ELSE 
		  extendedOutput<= (extendedOutput(32 DOWNTO 0)'range => '0');
end if;

when "110"   => 
IF shiftCount>0 and shiftCount<33 THEN
  		  extendedOutput<= inAUnsigned(shiftCount-1)& unsigned(std_logic_vector(shift_right(inAUnsigned,shiftCount))); --Shift right
ELSIF shiftCount=0 THEN
		  extendedOutput<= '0'& inAUnsigned;
ELSE 
		  extendedOutput<= (extendedOutput(32 DOWNTO 0)'range => '0');
END IF;

when "111"   =>   extendedOutput<= '0'& inAUnsigned;
when others  =>   extendedOutput<= (extendedOutput(32 DOWNTO 0)'range => '0');
end case; 
end process;



--Output after operation
ALUOut<= std_logic_vector(extendedOutput(31 DOWNTO 0));
-- Zero Flag
CCR(0)<='1' when extendedOutput(31 DOWNTO 0) = (extendedOutput(31 DOWNTO 0)'range => '0') else '0';
--Negative Flag knows as Sign Flag
CCR(1)<=extendedOutput(31);
--Carry out flag
CCR(2)<= not(extendedOutput(32)) when (sel = "001")
         else extendedOutput(32) when (sel = "000" or sel = "101" or sel = "110")
         else  prevC;
CCR(3)<='0';
END ALUArchi;

