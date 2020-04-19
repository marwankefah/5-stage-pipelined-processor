library ieee;
use ieee.std_logic_1164.all;

entity register_file is
	port(
		clk, reset, WER1, WER2 : in std_logic;
		RR1, RR2, WR1, WR2 : in std_logic_vector(2 downto 0);
		WD1, WD2 : in std_logic_vector(31 downto 0);
		RD1, RD2 : out std_logic_vector(31 downto 0)
	);
end register_file;

architecture register_file_arch of register_file is
	component reg32_F is 
		port(
			clk : in std_logic;
			reset : in std_logic;
			en : in std_logic;
			d : in std_logic_vector(31 downto 0);
			q : out std_logic_vector(31 downto 0)
		);
	end component;

	component decoder8 is
		port(
			En : in std_logic;
			A : in std_logic_vector(2 downto 0);
			F : out std_logic_vector(7 downto 0)
		);
	end component;

	component MUX_4x1 IS
		PORT( 
			in0:  IN  std_logic_vector (31 DOWNTO 0);
			in1:  IN  std_logic_vector (31 DOWNTO 0);
			in2:  IN  std_logic_vector (31 DOWNTO 0);
			in3:  IN  std_logic_vector (31 DOWNTO 0);
			sel:  IN  std_logic_vector (1 DOWNTO 0);
			outm: OUT std_logic_vector (31 DOWNTO 0)
		);
	END component;

	component tri_buff is
		port(
			En : in std_logic;
			A : in std_logic_vector(31 downto 0);		
			F : out std_logic_vector(31 downto 0)
		);
	end component;

	signal WA1, WA2, RA1, RA2 : std_logic_vector(7 downto 0);
	signal DS0, DS1, DS2, DS3, DS4, DS5, DS6, DS7 : std_logic_vector(1 downto 0);
	signal en0, en1, en2, en3, en4, en5, en6, en7 : std_logic;
	signal R0_input, R1_input, R2_input, R3_input, R4_input, R5_input, R6_input, R7_input : std_logic_vector(31 downto 0);
	signal R0_output, R1_output, R2_output, R3_output, R4_output, R5_output, R6_output, R7_output : std_logic_vector(31 downto 0);
begin
	WA_decoder1 : decoder8 port map(WER1,WR1,WA1);
	WA_decoder2 : decoder8 port map(WER2,WR2,WA2);

	DS0 <= WA2(0) & WA1(0);
	DS1 <= WA2(1) & WA1(1);
	DS2 <= WA2(2) & WA1(2);
	DS3 <= WA2(3) & WA1(3);
	DS4 <= WA2(4) & WA1(4);
	DS5 <= WA2(5) & WA1(5);
	DS6 <= WA2(6) & WA1(6);	
	DS7 <= WA2(7) & WA1(7);

	MUX0 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS0,R0_input);
	MUX1 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS1,R1_input);
	MUX2 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS2,R2_input);
	MUX3 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS3,R3_input);
	MUX4 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS4,R4_input);
	MUX5 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS5,R5_input);
	MUX6 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS6,R6_input);
	MUX7 : MUX_4x1 port map(WD1,WD1,WD2,WD2,DS7,R7_input);

	en0 <= WA2(0) or WA1(0);
	en1 <= WA2(1) or WA1(1);
	en2 <= WA2(2) or WA1(2);
	en3 <= WA2(3) or WA1(3);
	en4 <= WA2(4) or WA1(4);
	en5 <= WA2(5) or WA1(5);
	en6 <= WA2(6) or WA1(6);
	en7 <= WA2(7) or WA1(7);

	R0 : reg32_F port map(clk,reset,en0,R0_input,R0_output);
	R1 : reg32_F port map(clk,reset,en1,R1_input,R1_output);
	R2 : reg32_F port map(clk,reset,en2,R2_input,R2_output);
	R3 : reg32_F port map(clk,reset,en3,R3_input,R3_output);
	R4 : reg32_F port map(clk,reset,en4,R4_input,R4_output);
	R5 : reg32_F port map(clk,reset,en5,R5_input,R5_output);
	R6 : reg32_F port map(clk,reset,en6,R6_input,R6_output);
	R7 : reg32_F port map(clk,reset,en7,R7_input,R7_output);

	RA_decoder1 : decoder8 port map('1',RR1,RA1);
	RA_decoder2 : decoder8 port map('1',RR2,RA2);

	TSB10 : tri_buff port map(RA1(0),R0_output,RD1);
	TSB11 : tri_buff port map(RA1(1),R1_output,RD1);
	TSB12 : tri_buff port map(RA1(2),R2_output,RD1);
	TSB13 : tri_buff port map(RA1(3),R3_output,RD1);
	TSB14 : tri_buff port map(RA1(4),R4_output,RD1);
	TSB15 : tri_buff port map(RA1(5),R5_output,RD1);
	TSB16 : tri_buff port map(RA1(6),R6_output,RD1);
	TSB17 : tri_buff port map(RA1(7),R7_output,RD1);

	TSB20 : tri_buff port map(RA2(0),R0_output,RD2);
	TSB21 : tri_buff port map(RA2(1),R1_output,RD2);
	TSB22 : tri_buff port map(RA2(2),R2_output,RD2);
	TSB23 : tri_buff port map(RA2(3),R3_output,RD2);
	TSB24 : tri_buff port map(RA2(4),R4_output,RD2);
	TSB25 : tri_buff port map(RA2(5),R5_output,RD2);
	TSB26 : tri_buff port map(RA2(6),R6_output,RD2);
	TSB27 : tri_buff port map(RA2(7),R7_output,RD2);

end register_file_arch;