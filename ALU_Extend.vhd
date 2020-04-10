

--ALU EXTEND
--Contains Combinational circuit for ALU result + CCR
--Contains 4 muxes for execute purpose 

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY ALU_Extend IS
GENERIC (n : integer := 32);
PORT (	RD1:  IN std_logic_vector(n-1 DOWNTO 0);
 	RD2 : IN std_logic_vector(n-1 DOWNTO 0);
	CCRin:  IN std_logic_vector(2 DOWNTO 0);
	
	WB:   IN std_logic_vector(n-1 DOWNTO 0);
	ALUr: IN std_logic_vector(n-1 DOWNTO 0);
	A:    IN std_logic_vector(1 DOWNTO 0);
	B:    IN std_logic_vector(1 DOWNTO 0);
	IMMe: IN std_logic_vector(n-1 DOWNTO 0);
	--Control input begin
	Op2S :  IN std_logic_vector(1 DOWNTO 0);
	ALUop:  IN std_logic_vector(2 DOWNTO 0);
	stC:    IN std_logic;
	clC: 	IN std_logic;
	clF :   IN std_logic;
	enF:	IN std_logic;
	FlagS:	IN std_logic;
	--Control input end
	
	CCR:  	   OUT std_logic_vector(2 DOWNTO 0);
	ALUResult: OUT std_logic_vector(n-1 DOWNTO 0)
			);
END ALU_Extend;


Architecture ALU_Extend_Archi of ALU_Extend IS

COMPONENT mux_generic IS 
Generic ( n : Integer:=16);
PORT ( in0,in1,in2,in3 : IN std_logic_vector (n-1 DOWNTO 0);
	sel : IN  std_logic_vector (1 DOWNTO 0);
	out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END COMPONENT;


COMPONENT ALU IS
GENERIC (n : integer := 32);
PORT (  inA:IN std_logic_vector(n-1 DOWNTO 0);
 	inB : IN std_logic_vector(n-1 DOWNTO 0) ;
	sel: in std_logic_vector (2 DOWNTO 0);
	ALUOut: OUT std_logic_vector(n-1 DOWNTO 0);
	CCR : OUT std_logic_vector(2 DOWNTO 0));
END COMPONENT;

signal AmuxOut: std_logic_vector(n-1 DOWNTO 0);
signal BmuxOut: std_logic_vector(n-1 DOWNTO 0);
signal OP2SMux_BMux: std_logic_vector(n-1 DOWNTO 0);
signal CCROut_ALU: std_logic_vector(2 DOWNTO 0);
-- flags only take the last 3 least signifcant bits
signal flagsMuxOut:std_logic_vector(2 DOWNTO 0);
signal flagSelecExtend:std_logic_vector(1 DOWNTO 0);
Begin



OP2SMux: mux_generic generic map(n) port map (
					in0 => RD2, 
					in1 => std_logic_vector(to_unsigned(1,n)),
					in2 => IMMe , 
					in3 => IMMe,
					sel => OP2S,
					out1=> OP2SMux_BMux
						);


Amux: mux_generic generic map(n) port map (
					in3 => WB, 
					in2 => RD2 ,
					in1 => ALUr , 
					in0 => RD1,
					sel => A,
					out1=> AmuxOut
						);
Bmux: mux_generic generic map(n) port map (
					in3 => WB, 
					in2 => RD2 ,
					in1 => ALUr , 
					in0 => OP2SMux_BMux,
					sel => B,
					out1=> BmuxOut
						);
ALU_instance: ALU 	 generic map(n) port map(
					inA    =>AmuxOut,
					inB    =>BmuxOut,
					sel    =>ALUop,
					ALUOut =>ALUResult,
					CCR    => CCROut_ALU
						);

flagSelecExtend<='0' &FlagS;
FlagsMux: mux_generic generic map(3) port map (
					in0 => CCROut_ALU, 
					in1 => WB(2 DOWNTO 0) ,
					in2 => CCROut_ALU , 
					in3 => WB(2 DOWNTO 0),
					sel =>flagSelecExtend,
					out1=> flagsMuxOut
						);



CCR(2)<=CCRin(2) when enF='0' else '0' when clF='1' else '1' when stC ='1' else '0' when clC='1' else flagsMuxOut(2);
CCR(0)<=CCRin(0) when enF='0' else '0' when clF='1' else flagsMuxOut(0);
CCR(1)<=CCRin(1) when enF='0' else '0' when clF='1' else flagsMuxOut(1);


END ALU_Extend_Archi;




