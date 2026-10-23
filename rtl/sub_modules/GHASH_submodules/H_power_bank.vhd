LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

use work.utils_pkg.all;
 

ENTITY H_power_bank IS
  GENERIC (
    N : NATURAL := 3
  );
  PORT (
    H_4_in 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    load 	: IN  STD_LOGIC;
    clk 	: IN  STD_LOGIC;
    counter : IN  STD_LOGIC_VECTOR(clog2(N) - 1 DOWNTO 0);
    output	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END H_power_bank;
 
ARCHITECTURE behavior OF H_power_bank IS  

TYPE H4_t is array (0 to N) OF std_logic_vector(31 DOWNTO 0);
SIGNAL H4_power : H4_t;


BEGIN      
  process(clk)
  begin
    IF rising_edge(clk) then
        IF load = '1' THEN
            H4_power(to_integer(unsigned(counter))) <= H_4_in;
        END IF;
    END IF;
  end process;
  
output <= H4_power(to_integer(unsigned(counter)));
  
end behavior;