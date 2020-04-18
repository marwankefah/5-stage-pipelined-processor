
--GENERIC RAM MODULE
--+============================================================+
--| This RAM module will be used for our processor's memories  |
--| The RAM has a total adress space of 4GB (2^32*8-bits)(~34B)|
--| which is addressable with a 32-bit address                 |
--| to access data of width 16-bits                            |
--| This makes 2^31 addressable slots(around ~2B addreses)     |
--| The Ram module returns two slots from a single address     |
--| [address and address+1]                                    |
--+============================================================+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY GenRam IS
	GENERIC(
	  DataWidth    : INTEGER := 16;
	  AddressWidth : INTEGER := 32;
	  AddressSpace : INTEGER := 63 --(2^31-1)
	  );
	PORT(
		clk     : IN  std_logic;
		we      : IN  std_logic;
		address : IN  std_logic_vector(AddressWidth-1 DOWNTO 0);
		datain1 : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
		datain2 : IN  std_logic_vector(DataWidth-1 DOWNTO 0);
		dataout1: OUT std_logic_vector(DataWidth-1 DOWNTO 0);
		dataout2: OUT std_logic_vector(DataWidth-1 DOWNTO 0)
		);
END ENTITY GenRam;

ARCHITECTURE RamArchi OF GenRam IS

	TYPE ram_type IS ARRAY(0 TO AddressSpace) OF std_logic_vector(DataWidth-1 DOWNTO 0);
	SIGNAL ram : ram_type;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address)))   <= datain1;
						ram(to_integer(unsigned(address))+1) <= datain2;
					END IF;
				END IF;
		END PROCESS;
		dataout1 <= ram(to_integer(unsigned(address)));
		dataout2 <= ram(to_integer(unsigned(address))+1);
END RamArchi;

