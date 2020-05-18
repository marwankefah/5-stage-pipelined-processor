LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY Forwarding_Unit IS
PORT (	en:		IN std_logic;
	ID_EX_RR1 :	IN std_logic_vector (2 DOWNTO 0);
 	ID_EX_RR2 : 	IN std_logic_vector (2 DOWNTO 0) ;
	
	IF_ID_RR1 : 	IN std_logic_vector (2 DOWNTO 0);
	
	ID_EX_INPS: 	IN std_logic_vector (1 DOWNTO 0);
	
	EX_MEM_WR1 : 	IN std_logic_vector (2 DOWNTO 0);
	EX_MEM_WR2 : 	IN std_logic_vector (2 DOWNTO 0);
	
	MEM_WB_WR1 : 	IN std_logic_vector (2 DOWNTO 0);
	MEM_WB_WR2 : 	IN std_logic_vector (2 DOWNTO 0);
	
	EX_MEM_WE1R:	IN std_logic;	
	EX_MEM_WE2R:	IN std_logic;
	
	MEM_WB_WE1R:	IN std_logic;	
	MEM_WB_WE2R:	IN std_logic;
	
	
	EX_MEM_RD2:	IN std_logic_vector (31 DOWNTO 0);
	MEM_WB_RD2:	IN std_logic_vector (31 DOWNTO 0);

	RD2N1: 		OUT std_logic_vector(31 DOWNTO 0);
	RD2N2: 		OUT std_logic_vector(31 DOWNTO 0);
	A,B,C : 	OUT std_logic_vector(1  DOWNTO 0));   
END Forwarding_Unit;



Architecture FU_ARCHI of Forwarding_Unit IS
COMPONENT  MUX_2x1 IS
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



signal SD2S1:  std_logic:='0';
signal SD2S2:  std_logic:='0';


Begin


swapMuxop1: MUX_2x1 generic map(32) port map(in0=>EX_MEM_RD2,
					  in1=>MEM_WB_RD2,
					  sel=>SD2S1,
					  outm=>RD2N1	
					);

swapMuxop2: MUX_2x1 generic map(32) port map(in0=>EX_MEM_RD2,
					  in1=>MEM_WB_RD2,
					  sel=>SD2S2,
					  outm=>RD2N2	
					); 
SD2S1<= '0' when EX_MEM_WE2R='1' and ID_EX_RR1=EX_MEM_WR1 else '1' when MEM_WB_WE2R='1' and ID_EX_RR1=MEM_WB_WR1 else '0'; 
SD2S2<= '0' when EX_MEM_WE2R='1' and ID_EX_RR2=EX_MEM_WR1 else '1' when MEM_WB_WE2R='1' and ID_EX_RR2=MEM_WB_WR1 else '0'; 

-- For OP1
A<="00" when not(ID_EX_INPS="00") or en='0'  else "10" when EX_MEM_WE2R='1' and ID_EX_RR1=EX_MEM_WR1
					     else "01" when EX_MEM_WE2R='1' and ID_EX_RR1=EX_MEM_WR2
					     else "01" when EX_MEM_WE1R='1' and ID_EX_RR1=EX_MEM_WR1  -- most familiar case EX-->EX
					     else "10" when MEM_WB_WE2R='1' and ID_EX_RR1=MEM_WB_WR1
					     else "11" when MEM_WB_WE2R='1' and ID_EX_RR1=MEM_WB_WR2
					     else "11" when MEM_WB_WE1R='1' and iD_EX_RR1=MEM_WB_WR1 --second familiar case MEM-->EX
					     else "00";

-- FOR OP2
B<="00" when not(ID_EX_INPS="00") or en='0'  else "10" when EX_MEM_WE2R='1' and ID_EX_RR2=EX_MEM_WR1
					     else "01" when EX_MEM_WE2R='1' and ID_EX_RR2=EX_MEM_WR2
					     else "01" when EX_MEM_WE1R='1' and ID_EX_RR2=EX_MEM_WR1  -- most familiar case EX-->EX
					     else "10" when MEM_WB_WE2R='1' and ID_EX_RR2=MEM_WB_WR1
					     else "11" when MEM_WB_WE2R='1' and ID_EX_RR2=MEM_WB_WR2
					     else "11" when MEM_WB_WE1R='1' and iD_EX_RR2=MEM_WB_WR1 --second familiar case MEM-->EX
					     else "00";


-- FORWarding For Branching 
C<="00" when not(ID_EX_INPS="00") or en='0'  else "10" when EX_MEM_WE2R='1' and IF_ID_RR1=EX_MEM_WR1
					     else "01" when EX_MEM_WE2R='1' and IF_ID_RR1=EX_MEM_WR2
					     else "01" when EX_MEM_WE1R='1' and IF_ID_RR1=EX_MEM_WR1  -- most familiar case EX-->EX
					     else "00";



END FU_ARCHI;
