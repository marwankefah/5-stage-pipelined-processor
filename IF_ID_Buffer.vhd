-- THE BUFFER BETWEEN FETCH AND DECODE

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY IF_ID_Buffer IS
PORT( 		 
		clk,reset,en : IN std_logic;
		
		-- INPUTS
	  d_PC:          IN std_logic_vector(31 DOWNTO 0);
    d_PCnext:      IN std_logic_vector(31 DOWNTO 0);
    d_Instruction: IN std_logic_vector(31 DOWNTO 0);
    d_INPORT:      IN std_logic_vector(31 DOWNTO 0);
    d_INT:         IN std_logic;
       
    -- OUTPUTS
    q_PC:          OUT std_logic_vector(31 DOWNTO 0);
    q_PCnext:      OUT std_logic_vector(31 DOWNTO 0);   
    q_Instruction: OUT std_logic_vector(31 DOWNTO 0);
    q_INPORT:      OUT std_logic_vector(31 DOWNTO 0);
    q_INT:         OUT std_logic 
   
     );
END IF_ID_Buffer;

ARCHITECTURE IF_ID_Buffer_Archi OF IF_ID_Buffer IS
	COMPONENT reg IS 
		GENERIC(
			n : integer
		);

		PORT(
			clk : IN std_logic;
		 	reset : IN std_logic;
		 	en : IN std_logic;
			d : IN std_logic_vector(n-1 downto 0);
			q : OUT std_logic_vector(n-1 downto 0)
		);
	END COMPONENT;

	COMPONENT reg1 IS 
		PORT(
			clk : IN std_logic;
			reset : IN std_logic;
			en : IN std_logic;
			d : IN std_logic;
			q : OUT std_logic
	  	);
	END COMPONENT;
	
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

	
BEGIN

 int_reg:     reg1 port map(clk,reset,en,d_int,q_int);
 PC_reg:      reg generic map(32) port map(clk,reset,en,d_PC,q_PC);
 PCnext_reg:  reg generic map(32) port map(clk,reset,en,d_PCnext,q_PCnext);
 Inst_reg:    reg generic map(32) port map(clk,reset,en,d_Instruction,q_Instruction); 
 InPort_reg:  reg generic map(32) port map(clk,reset,en,d_INPORT,q_INPORT);
     
END IF_ID_Buffer_Archi;  
    