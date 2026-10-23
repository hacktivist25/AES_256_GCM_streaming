LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
 -- multiplication by two in GF(2)
 -- consists of a right shift followed eventually by a XORING with 0001 1011
 -- defined in 4.7 of the NIST.FIPS.197 "announcing Advanced encryption standard"
ENTITY xtime IS
  PORT (
    IN_1 	: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    OUT_1	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END xtime;
 
ARCHITECTURE behavior OF xtime IS  

SIGNAL polynom : STD_LOGIC_VECTOR (7 DOWNTO 0):=x"1B";
	
SIGNAL IN_times_2 : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN  
  IN_times_2 <= IN_1 & '0'; -- "equivalent of a logical right shift"

  OUT_1 <= IN_times_2(7 DOWNTO 0) XOR polynom WHEN IN_times_2(8) = '1'
           ELSE IN_times_2(7 DOWNTO 0);
end behavior;