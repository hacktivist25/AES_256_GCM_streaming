library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.utils_pkg.all;

entity H_init is
	port(
		H : IN std_logic_vector(127 DOWNTO 0); -- H for the first one
		start : IN std_logic;
		clk : IN std_logic;
		rst: IN std_logic;
		valid: OUT std_logic;
		H_out: OUT std_logic_vector(127 DOWNTO 0)
	);
end H_init;

architecture behavior of H_init is

COMPONENT multH_32way is
	port(
		deformed_contribution_input : IN std_logic_vector(127 DOWNTO 0);
		current_sum_input : IN std_logic_vector(127 DOWNTO 0);
		H_i : IN std_logic_vector(31 DOWNTO 0);
		deformed_contribution_output : OUT std_logic_vector(127 DOWNTO 0);
		current_sum_output : OUT std_logic_vector(127 DOWNTO 0)
	);
end COMPONENT;
SIGNAL deformed_contribution_input_s : std_logic_vector(127 DOWNTO 0);
SIGNAL current_sum_input_s : std_logic_vector(127 DOWNTO 0);
SIGNAL H_i_s : std_logic_vector(31 DOWNTO 0);
SIGNAL deformed_contribution_output_s : std_logic_vector(127 DOWNTO 0);
SIGNAL current_sum_output_s : std_logic_vector(127 DOWNTO 0);

COMPONENT counter is
    generic (
        LIMIT : NATURAL := 32 -- 0 to 32
    );
	port(
		start : IN std_logic;
		clk : IN std_logic;
		rst : IN std_logic;
		count : OUT std_logic_vector(clog2(LIMIT)-1 DOWNTO 0);
		valid : OUT std_logic
	);
end COMPONENT;
constant limit_s : NATURAL := 3;
SIGNAL count_s : std_logic_vector(clog2(limit_s)-1 DOWNTO 0);


SIGNAL H_reg : std_logic_vector(127 DOWNTO 0);

begin
init_H_counter : counter 
    GENERIC MAP (LIMIT => limit_s)
    PORT MAP(
        start => start,
		clk => clk,
		rst => rst,
		count => count_s,
		valid => valid
		);

init_H_multH : multH_32way PORT MAP(
        deformed_contribution_input => deformed_contribution_input_s, 
        current_sum_input => current_sum_input_s,
        H_i => H_i_s,
        deformed_contribution_output => deformed_contribution_output_s,
        current_sum_output => current_sum_output_s
		);



process (clk, rst)
begin
    IF rst = '0' then
        deformed_contribution_input_s <= (OTHERS => '0');
        current_sum_input_s <= (OTHERS => '0');
        H_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) then
        IF start = '1' then
            H_reg <= H;
            deformed_contribution_input_s <= H;
            current_sum_input_s <= (OTHERS => '0');
        ELSE
            H_reg <= H_reg;
            deformed_contribution_input_s <= deformed_contribution_output_s;
            current_sum_input_s <= current_sum_output_s;
        END IF;
    END IF;
end process;

--output of the mulH block calculating H_power_i
H_out <= current_sum_output_s;

H_i_s <= H_reg(31 DOWNTO 0) WHEN count_s = "00"
ELSE H_reg(63 DOWNTO 32) WHEN count_s = "01"
ELSE H_reg(95 DOWNTO 64) WHEN count_s = "10"
ELSE H_reg(127 DOWNTO 96) WHEN count_s = "11";



end behavior;