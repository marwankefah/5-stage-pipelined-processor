library ieee;
use ieee.std_logic_1164.all;

entity ID_EX_Buffer is
	port(
		clk, reset, en : std_logic;
		
		-- INPUTS 
		D_WB : in std_logic_vector(4 downto 0);
		D_MEM : in std_logic_vector(10 downto 0);
		D_EX : in std_logic_vector(10 downto 0);
		D_opcode : in std_logic_vector(5 downto 0);
		D_INPS : in std_logic_vector(1 downto 0);
		D_int : in std_logic;
		D_PC : in std_logic_vector(31 downto 0);
		D_PCnext : in std_logic_vector(31 downto 0);
		D_RD1 : in std_logic_vector(31 downto 0);
		D_RD2 : in std_logic_vector(31 downto 0);
		D_IMMe : in std_logic_vector(31 downto 0);
		D_EAe : in std_logic_vector(31 downto 0);
		D_WR1 : in std_logic_vector(2 downto 0);
		D_WR2 : in std_logic_vector(2 downto 0);
		D_RR1 : in std_logic_vector(2 downto 0);
		D_RR2 : in std_logic_vector(2 downto 0);

		-- OUTPUTS
		Q_WB : out std_logic_vector(4 downto 0);
		Q_MEM : out std_logic_vector(10 downto 0);
		Q_EX : out std_logic_vector(10 downto 0);
		Q_opcode : out std_logic_vector(5 downto 0);
		Q_INPS : out std_logic_vector(1 downto 0);
		Q_int : out std_logic;
		Q_PC : out std_logic_vector(31 downto 0);
		Q_PCnext : out std_logic_vector(31 downto 0);
		Q_RD1 : out std_logic_vector(31 downto 0);
		Q_RD2 : out std_logic_vector(31 downto 0);
		Q_IMMe : out std_logic_vector(31 downto 0);
		Q_EAe : out std_logic_vector(31 downto 0);
		Q_WR1 : out std_logic_vector(2 downto 0);
		Q_WR2 : out std_logic_vector(2 downto 0);
		Q_RR1 : out std_logic_vector(2 downto 0);
		Q_RR2 : out std_logic_vector(2 downto 0)
	);
end ID_EX_Buffer;

architecture ID_EX_Buffer_arch of ID_EX_Buffer is
	component reg is 
		generic(
			n : integer
		);

		port(
			clk : in std_logic;
		 	reset : in std_logic;
		 	en : in std_logic;
			d : in std_logic_vector(n-1 downto 0);
			q : out std_logic_vector(n-1 downto 0)
		);
	end component;

	component reg1 is 
		port(
			clk : in std_logic;
			reset : in std_logic;
			en : in std_logic;
			d : in std_logic;
			q : out std_logic
	  	);
	end component;
begin
	WB_reg : reg generic map(5) port map(clk,reset,en,D_WB,Q_WB);
	MEM_reg : reg generic map(11) port map(clk,reset,en,D_MEM,Q_MEM);
	EX_reg : reg generic map(11) port map(clk,reset,en,D_EX,Q_EX);
	opcode_reg : reg generic map(6) port map(clk,reset,en,D_opcode,Q_opcode);
	INPS_reg : reg generic map(2) port map(clk,reset,en,D_INPS,Q_INPS);
	int_reg : reg1 port map(clk,reset,en,D_int,Q_int);
	PC_reg : reg generic map(32) port map(clk,reset,en,D_PC,Q_PC);
	PCnext_reg : reg generic map(32) port map(clk,reset,en,D_PCnext,Q_PCnext);
	RD1_reg : reg generic map(32) port map(clk,reset,en,D_RD1,Q_RD1);
	RD2_reg : reg generic map(32) port map(clk,reset,en,D_RD2,Q_RD2);
	IMMe_reg : reg generic map(32) port map(clk,reset,en,D_IMMe,Q_IMMe);
	EAe_reg : reg generic map(32) port map(clk,reset,en,D_EAe,Q_EAe);
	WR1_reg : reg generic map(3) port map(clk,reset,en,D_WR1,Q_WR1);
	WR2_reg : reg generic map(3) port map(clk,reset,en,D_WR2,Q_WR2);
	RR1_reg : reg generic map(3) port map(clk,reset,en,D_RR1,Q_RR1);
	RR2_reg : reg generic map(3) port map(clk,reset,en,D_RR2,Q_RR2);	
end ID_EX_Buffer_arch;
