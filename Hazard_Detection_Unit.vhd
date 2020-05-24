library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_detection_unit is
	port(		
		enable : in std_logic;
		clk : in std_logic;
		int : in std_logic;
		rst : in std_logic;
		opcode : in std_logic_vector(5 downto 0);
	
		-- CONTROL SIGNALS
		ID_EX_MR : in std_logic;
		ID_EX_enF : in std_logic;
		PCBranchS : in std_logic;
		ID_EX_WE1R : in std_logic;

		-- ADDRESSES
		ID_RR1 : in std_logic_vector(2 downto 0);
		ID_RR2 : in std_logic_vector(2 downto 0);		
		ID_EX_WR1 : in std_logic_vector(2 downto 0);
		ID_EX_WR2 : in std_logic_vector(2 downto 0);

		-- OUTPUTS
		NOPs : out std_logic;
		enable_PC : out std_logic;
		enable_IF_ID_buffer : out std_logic
	);
end hazard_detection_unit;

architecture harzard_detection_unit_arch of hazard_detection_unit is 
	signal counterFlush : unsigned(2 downto 0) := "000";
	signal counterStall : unsigned(2 downto 0) := "000";

	--CONSTANTS
	constant CALL_OP : std_logic_vector(5 downto 0) := "011100";
	constant RET_OP : std_logic_vector(5 downto 0) := "011101";
	constant RTI_OP : std_logic_vector(5 downto 0) := "011110";
begin
	process (clk)
	begin
		if (enable = '1') then
			if (falling_edge(clk)) then
				if (counterFlush > "000") then
					NOPs <= '1';	
					enable_PC <= '1';
					enable_IF_ID_buffer <= '1';
					counterFlush <= counterFlush - "001";
				elsif (counterStall > "000") then
					NOPs <= '1';
					enable_PC <= '0';
					enable_IF_ID_buffer <= '0';
					counterStall <= counterStall - "001";
				elsif (int = '1' or rst = '1' or opcode = CALL_OP or opcode = RET_OP or opcode = RTI_OP) then -- RST CAL RET INT RTI
					counterFlush <= "100";	
				elsif (ID_EX_MR = '1' and ID_EX_WE1R = '1' and PCBranchS = '1' and ID_RR1 = ID_EX_WR1) then -- LOAD USE CASE (JUMP OPERATIONS)
					NOPs <= '1';
					enable_PC <= '0';
					enable_IF_ID_buffer <= '0';
					counterStall <= "001"; 
				elsif (ID_EX_MR = '1' and ID_EX_WE1R = '1' and (ID_RR1 = ID_EX_WR1 or ID_RR2 = ID_EX_WR1)) then -- LOAD USE CASE (OTHER OPERATIONS)
					NOPs <= '1';
					enable_PC <= '0';
					enable_IF_ID_buffer <= '0';
				elsif (PCBranchS = '1' and ID_EX_enF = '1') then -- JUMP COMES AFTER AN OPERATION THAT CHANGES FLAGS
					NOPs <= '1';
					enable_PC <= '0';
					enable_IF_ID_buffer <= '0';
				elsif (PCBranchS = '1' and ID_EX_WE1R = '1' and (ID_RR1 = ID_EX_WR1 or ID_RR2 = ID_EX_WR1)) then -- JUMP AND RAW OPREATION
					NOPs <= '1';
					enable_PC <= '0';
					enable_IF_ID_buffer <= '0';
				else -- NO HAZARDS
					NOPs <= '0';
					enable_PC <= '1';
					enable_IF_ID_buffer <= '1';
			end if;		
		else
				NOPs <= '0';
				enable_PC <= '1';
				enable_IF_ID_buffer <= '1';
		end if;
			
		end if;
	end process;
end  harzard_detection_unit_arch;
