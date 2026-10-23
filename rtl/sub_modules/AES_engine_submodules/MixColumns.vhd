library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)
entity MixColumns is
	port(
		state_column : IN std_logic_vector(31 DOWNTO 0);
		output_state_column : OUT std_logic_vector(31 DOWNTO 0)
	);
end MixColumns;

architecture behavior of MixColumns is

SIGNAL A0, A1, A2, A3 : std_logic_vector(7 DOWNTO 0);
SIGNAL TWO_A0, TWO_A1, TWO_A2, TWO_A3 : std_logic_vector(7 DOWNTO 0);

COMPONENT xtime IS
PORT (
    IN_1 	: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    OUT_1	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END COMPONENT;

begin
A0 <= state_column(31 DOWNTO 24);
A1 <= state_column(23 DOWNTO 16);
A2 <= state_column(15 DOWNTO 8);
A3 <= state_column(7 DOWNTO 0);

XTIME_0 : xtime PORT MAP (
                IN_1 => A0,
                OUT_1 => TWO_A0);
                
XTIME_1 : xtime PORT MAP (
                IN_1 => A1,
                OUT_1 => TWO_A1);

XTIME_2 : xtime PORT MAP (
                IN_1 => A2,
                OUT_1 => TWO_A2);

XTIME_3 : xtime PORT MAP (
                IN_1 => A3,
                OUT_1 => TWO_A3);

--A(0,j)
output_state_column(31 DOWNTO 24) <= TWO_A0 XOR TWO_A1 XOR A1 XOR A2 XOR A3;
--A(1,j)
output_state_column(23 DOWNTO 16) <= TWO_A1 XOR TWO_A2 XOR A2 XOR A3 XOR A0;
--A(2,j)
output_state_column(15 DOWNTO 8) <= TWO_A2 XOR TWO_A3 XOR A3 XOR A0 XOR A1;
--A(3,j)
output_state_column(7 DOWNTO 0) <= TWO_A3 XOR TWO_A0 XOR A0 XOR A1 XOR A2;

end behavior;