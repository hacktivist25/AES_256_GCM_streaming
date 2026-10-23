library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)
entity RotWord is
	port(
		column : IN std_logic_vector(31 DOWNTO 0);
		output_column : OUT std_logic_vector(31 DOWNTO 0)
	);
end RotWord;

architecture behavior of RotWord is
begin

output_column (31 DOWNTO 24) <= column(23 DOWNTO 16);
output_column (23 DOWNTO 16) <= column(15 DOWNTO 8);
output_column (15 DOWNTO 8) <= column(7 DOWNTO 0);
output_column (7 DOWNTO 0) <= column(31 DOWNTO 24);

end behavior;