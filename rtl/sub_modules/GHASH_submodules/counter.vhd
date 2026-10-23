library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.utils_pkg.all;


-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)
entity counter is
    generic (
        LIMIT : NATURAL := 32
    );
	port(
		start : IN std_logic;
		clk : IN std_logic;
		rst : IN std_logic;
		count : OUT std_logic_vector(clog2(LIMIT)-1 DOWNTO 0);
		valid : OUT std_logic
	);
end counter;

architecture behavior of counter is

SIGNAL count_s : NATURAL RANGE 0 TO LIMIT;

begin
process(clk, rst)
begin
    IF rst = '0' then
        count_s <= 0;
    ELSIF rising_edge(clk) then
        IF start = '1' then
            count_s <= 0;
        ELSE
            IF count_s < LIMIT then
                count_s <= count_s + 1;
            ELSE
                count_s <= 0;
            END IF;
        END IF;
    END IF;
end process;

valid <= '1' WHEN count_s = 3 ELSE '0';
count <= std_logic_vector(to_unsigned(count_s, clog2(LIMIT)));

end behavior;