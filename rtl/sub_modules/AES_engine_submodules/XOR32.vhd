LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
ENTITY XOR32 IS
  PORT (
    A 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    B 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    A_XOR_B	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END XOR32;
 
ARCHITECTURE behavior OF XOR32 IS  

BEGIN  
  A_XOR_B <= A XOR B;
end behavior;