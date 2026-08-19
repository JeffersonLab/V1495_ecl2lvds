library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

entity ecl2lvds IS
	port(
		
		-- INPUT ECL SIGNALS on E
		E        : INOUT  std_logic_vector (31 DOWNTO 0);  -- In/Out E (I/O Expansion)
		-- F        : INOUT  std_logic_vector (31 DOWNTO 0);  -- In/Out E (I/O Expansion)
		
		nOEE     : OUT    std_logic;                       -- Output Enable Port E (only for A395D)
		-- nOEF     : OUT    std_logic;                       -- Output Enable Port F (only for A395D)
		
		SELE     : OUT    std_logic;                       -- Output Level Select Port E (only for A395D)
		-- SELF     : OUT    std_logic;                       -- Output Level Select Port F (only for A395D)
		
		-- OUTPUT LVDS on C
		C        : OUT    std_logic_vector (31 DOWNTO 0);  -- Out C (32 x LVDS)
		
		-- LED drivers
		nLEDG		: OUT    std_logic;                      -- Green (active low)
		nLEDR		: OUT    std_logic                       -- Red (active low)
	);
end ecl2lvds;


architecture Synthesis of ecl2lvds is
	
	signal resolved_nim_signals : std_logic_vector (7 DOWNTO 0);
	
	type int_array is array(natural range <>) of integer;
	-- constant NIM_IO_MAP					: int_array(0 to 7) := (0, 16, 1, 17, 12, 28, 13, 29);   -- For output
	constant NIM_IO_MAP					: int_array(0 to 7) := (2, 18, 3, 19, 14, 30, 15, 31);		-- For input
	
begin

	nLEDR <= '1';
	
	nOEE <= '1';   -- Input
	SELE <= '0';	-- NIM
	
	gen_inputs : process(E)
   begin
		for i in 0 to 7 loop
			resolved_nim_signals(i) <= E(NIM_IO_MAP(i)); 
		end loop;
	end process;

	C(7 downto 0) <= not resolved_nim_signals(7 downto 0);
	
	nLEDG <= E(NIM_IO_MAP(0));
	
end Synthesis;
   