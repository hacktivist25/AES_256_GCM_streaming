LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
ENTITY shift_reg_128bx32 IS
  PORT (
    input 	: IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    load 	: IN  STD_LOGIC;
    clk 	: IN  STD_LOGIC;
    rst 	: IN  STD_LOGIC;
    output	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END shift_reg_128bx32;
 
ARCHITECTURE behavior OF shift_reg_128bx32 IS  

SIGNAL shift_register : STD_LOGIC_VECTOR(127 DOWNTO 0);

BEGIN  
  output <= shift_register(1 DOWNTO 0) WHEN rst = '1' ELSE "00";  
    
  process(clk, rst)
  begin
    IF rst = '0' then
        shift_register <= (OTHERS => '0');
    ELSIF rising_edge(clk) then
        IF load = '1' THEN
            shift_register <= input;
        ELSE
            shift_register(125 DOWNTO 0) <= shift_register(127 DOWNTO 2);
        END IF;
    END IF;
  end process;
end behavior;