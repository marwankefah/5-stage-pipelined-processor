

--ALU EXTEND
--Contains Combinational circuit for ALU result + CCR
--Contains 4 muxes for execute purpose 

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY Execute_Stage IS
PORT (	--EXTERNAL INPUT
	clk:		std_logic;
	reset :	 	std_logic; 
	EX_INTS:	std_logic_vector(1 DOWNTO 0);
	RD1:  IN std_logic_vector(31 DOWNTO 0);
 	RD2 : IN std_logic_vector(31 DOWNTO 0);
	--RD2 comming from memory stage
	RD12N: IN std_logic_vector(31 DOWNTO 0);
	RD22N: IN std_logic_vector(31 DOWNTO 0);
	WB:   IN std_logic_vector(31 DOWNTO 0);
	MEMR: IN std_logic_vector(31 DOWNTO 0);
	ALUr: IN std_logic_vector(31 DOWNTO 0);
	A:    IN std_logic_vector(1  DOWNTO 0);
	B:    IN std_logic_vector(1  DOWNTO 0);
	IMMe: IN std_logic_vector(31 DOWNTO 0);
	--Control input begin
	ID_EX_EX:   IN std_logic_vector(12 DOWNTO 0);
	ID_EX_MEM:  IN std_logic_vector(10 DOWNTO 0);
	ID_EX_WB:   IN std_logic_vector(4 DOWNTO 0);
	--Control input end

	EX_MEM_MEM: OUT std_logic_vector(10 DOWNTO 0);
	EX_MEM_WB:  OUT std_logic_vector(4 DOWNTO 0);
	CCR:  	   OUT std_logic_vector(3 DOWNTO 0);
	ALUResult: OUT std_logic_vector(31 DOWNTO 0)
			);
END Execute_Stage;


Architecture Execute_Stage_Archi of Execute_Stage IS
COMPONENT CCR_Reg is 
	port(
		   clk : in std_logic;
		   reset : in std_logic;
		   enF : in std_logic;
		   stC:  in std_logic;
		   clC:  in std_logic;
		   clZ:  in std_logic;
		   clN:  in std_logic;
		   clF:	 in std_logic;
		   D_CCR : in std_logic_vector(3 downto 0);
		   Q_CCR : out std_logic_vector(3 downto 0)
	);
end COMPONENT;
COMPONENT MUX_2x1 IS
	generic(
		n : integer
	);	
	PORT( 
		in0:  IN  std_logic_vector (n-1 DOWNTO 0);
		in1:  IN  std_logic_vector (n-1 DOWNTO 0);
		sel:  IN  std_logic;
		outm: OUT std_logic_vector (n-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT MUX_4x1 IS
	generic(
		n : integer
	);
	PORT( 
		in0:  IN  std_logic_vector (n-1 DOWNTO 0);
		in1:  IN  std_logic_vector (n-1 DOWNTO 0);
		in2:  IN  std_logic_vector (n-1 DOWNTO 0);
		in3:  IN  std_logic_vector (n-1 DOWNTO 0);
		sel:  IN  std_logic_vector (1 DOWNTO 0);
		outm: OUT std_logic_vector (n-1 DOWNTO 0)
	);
END COMPONENT;
COMPONENT ALU IS
PORT (  
  en:IN std_logic;
  inA:IN std_logic_vector(31 DOWNTO 0);
 	inB : IN std_logic_vector(31 DOWNTO 0) ;
	sel: in std_logic_vector (2 DOWNTO 0);
	ALUOut: OUT std_logic_vector(31 DOWNTO 0);
	CCR : OUT std_logic_vector(3 DOWNTO 0));
END COMPONENT;

signal AmuxOut: std_logic_vector(31 DOWNTO 0);
signal BmuxOut: std_logic_vector(31 DOWNTO 0);
signal OP2SMux_BMux: std_logic_vector(31 DOWNTO 0);
signal CCROut_ALU: std_logic_vector(3 DOWNTO 0);
-- flags only take the last 3 least signifcant bits
signal flagsMuxOut:std_logic_vector(3 DOWNTO 0);
signal flagSelecExtend:std_logic_vector(1 DOWNTO 0);


constant PUSHPC : std_logic_vector(15 downto 0) := "1100001010100000";                                                             
constant POPF : std_logic_vector(15 downto 0)   := "0010000001010000";
constant NOP : std_logic_vector(15 downto 0)    := "0100000000000000";

Begin

EX_INT_MUX_MEM: MUX_4x1 generic map(11) port map(
					in0 => POPF(15 DOWNTO 5), 
					in1 => ID_EX_MEM,
					in2 => PUSHPC(15 DOWNTO 5), 
					in3 => (others=>'0'),
					sel => EX_INTS,
					outm=> EX_MEM_MEM
						);
EX_INT_MUX_WB: MUX_4x1 generic map(5) port map(
					in0 => POPF(4 DOWNTO 0), 
					in1 => ID_EX_WB,
					in2 => PUSHPC(4 DOWNTO 0) , 
					in3 => (others=>'0'),
					sel => EX_INTS,
					outm=> EX_MEM_WB
						);

OP2SMux: MUX_4x1 generic map(32) port map (
					in0 => RD2, 
					in1 => std_logic_vector(to_unsigned(1,32)),
					in2 => IMMe , 
					in3 => IMMe,
					sel => ID_EX_EX(11 DOWNTO 10), --OP2S
					outm=> OP2SMux_BMux
						);


Amux: MUX_4x1 generic map(32) port map (
					in3 => WB, 
					in2 => RD12N ,
					in1 => ALUr , 
					in0 => RD1,
					sel => A,
					outm=> AmuxOut
						);
Bmux: MUX_4x1 generic map(32) port map (
					in3 => WB, 
					in2 => RD22N ,
					in1 => ALUr , 
					in0 => OP2SMux_BMux,
					sel => B,
					outm=> BmuxOut
						);
ALU_instance: ALU 	port map(
          en     =>ID_EX_EX(1),
					inA    =>AmuxOut,
					inB    =>BmuxOut,
					sel    =>ID_EX_EX(9 DOWNTO 7),  --ALUOP
					ALUOut =>ALUResult,
					CCR    => CCROut_ALU
						);

FlagsMux: MUX_2x1 generic map(4) port map (
					in0 => CCROut_ALU, 
					in1 => MEMR(3 DOWNTO 0) ,
					sel =>ID_EX_EX(0), 		  --FLAGS
					outm=> flagsMuxOut
						);


CCR_REG_EX: CCR_Reg		 port map (
					clk =>clk,
		   			reset => reset,
		   			stC=> ID_EX_EX(6),
		   			clC=> ID_EX_EX(5),
		   			clZ=> ID_EX_EX(4),
		   			clN=> ID_EX_EX(3),
		   			clF=> ID_EX_EX(2),
					enF =>ID_EX_EX(1),
		   			D_CCR=>flagsMuxOut,
		   			Q_CCR=>CCR
					);
END Execute_Stage_Archi;




