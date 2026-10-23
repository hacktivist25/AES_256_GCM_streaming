library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftRows is
	port (
		state : IN std_logic_vector(127 DOWNTO 0);
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end ShiftRows;

architecture behavior of ShiftRows is

begin
    output_state( 7 DOWNTO 0 ) <= state( 7 DOWNTO 0); -- b(0, 0) = a( 0,  0)
    output_state( 39 DOWNTO 32 ) <= state( 39 DOWNTO 32 );
    output_state( 71 DOWNTO 64 ) <= state( 71 DOWNTO 64 );
    output_state( 103 DOWNTO 96 ) <= state( 103 DOWNTO 96 );
    output_state( 15 DOWNTO 8 ) <= state( 47 DOWNTO 40 ); -- b(1, 0) = a( 1,  1)
    output_state( 47 DOWNTO 40 ) <= state( 79 DOWNTO 72 );
    output_state( 79 DOWNTO 72 ) <= state( 111 DOWNTO 104 );
    output_state( 111 DOWNTO 104 ) <= state( 15 DOWNTO 8 );
    output_state( 23 DOWNTO 16 ) <= state( 87 DOWNTO 80 );-- b(2, 0) = a( 2,  2)
    output_state( 55 DOWNTO 48 ) <= state( 119 DOWNTO 112 );
    output_state( 87 DOWNTO 80 ) <= state( 23 DOWNTO 16 );
    output_state( 119 DOWNTO 112 ) <= state( 55 DOWNTO 48 );
    output_state( 31 DOWNTO 24 ) <= state( 127 DOWNTO 120 );-- b(3, 0) = a( 3,  3)
    output_state( 63 DOWNTO 56 ) <= state( 31 DOWNTO 24 );
    output_state( 95 DOWNTO 88 ) <= state( 63 DOWNTO 56 );
    output_state( 127 DOWNTO 120 ) <= state( 95 DOWNTO 88 );
end behavior;