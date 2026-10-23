library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AddRoundKey is
	port(
		round_key : IN std_logic_vector(127 DOWNTO 0);
		state : IN std_logic_vector(127 DOWNTO 0);
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end AddRoundKey;

architecture behavior of AddRoundKey is

begin 
    output_state <= round_key XOR state;
end behavior;