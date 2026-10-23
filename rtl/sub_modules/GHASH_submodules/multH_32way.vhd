library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multH_32way is
	port(
		deformed_contribution_input : IN std_logic_vector(127 DOWNTO 0);
		current_sum_input : IN std_logic_vector(127 DOWNTO 0);
		H_i : IN std_logic_vector(31 DOWNTO 0);
		deformed_contribution_output : OUT std_logic_vector(127 DOWNTO 0);
		current_sum_output : OUT std_logic_vector(127 DOWNTO 0)
	);
end multH_32way;

architecture behavior of multH_32way is

COMPONENT xtime_128 IS
  PORT (
    IN_1 	: IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    OUT_1	: OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;

type deformed_contribution_t is array (0 to 32) of std_logic_vector(127 downto 0);
SIGNAL deformed_contribution : deformed_contribution_t;

type current_sum_t is array (0 to 31) of std_logic_vector(127 downto 0);
SIGNAL current_sum : current_sum_t;

begin
deformed_contribution(0) <= deformed_contribution_input;

deformed_contribution_output <= deformed_contribution(32);
current_sum_output <= current_sum(31);

current_sum(0) <= deformed_contribution(0) XOR current_sum_input WHEN H_i(0) = '1' 
ELSE current_sum_input;

gen_current_cum : for i in 1 to 31 generate
	current_sum(i) <= deformed_contribution(i) XOR current_sum(i-1) WHEN H_i(i) = '1' 
ELSE current_sum(i-1);
end generate;

gen_xtimers : for i in 0 to 31 generate
begin
    XTIMERS : xtime_128 PORT MAP(
        IN_1 => deformed_contribution(i),
        OUT_1 => deformed_contribution(i+1)
    ); 
end generate;

end behavior;