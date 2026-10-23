library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multH_16way_benchmark_top is
	port(
		clk : IN std_logic;
		rst : IN std_logic;
		void : OUT std_logic
	);
end multH_16way_benchmark_top;

architecture behavior of multH_16way_benchmark_top is

COMPONENT multH_16way is
	port(
		deformed_contribution_input : IN std_logic_vector(127 DOWNTO 0);
		current_sum_input : IN std_logic_vector(127 DOWNTO 0);
		H_i : IN std_logic_vector(15 DOWNTO 0);
		deformed_contribution_output : OUT std_logic_vector(127 DOWNTO 0);
		current_sum_output : OUT std_logic_vector(127 DOWNTO 0)
	);
end COMPONENT;

SIGNAL deformed_contribution_input_bench : std_logic_vector(127 DOWNTO 0) := X"11223344112233441122334411223344";   
SIGNAL current_sum_input_bench : std_logic_vector(127 DOWNTO 0) := X"11223344112233441122334411223344";               


SIGNAL deformed_contribution_input_reg : std_logic_vector(127 DOWNTO 0);   
SIGNAL current_sum_input_reg : std_logic_vector(127 DOWNTO 0);             
SIGNAL H_i_bench : std_logic_vector(15 DOWNTO 0) := X"5555";         
SIGNAL deformed_contribution_output_next : std_logic_vector(127 DOWNTO 0); 
SIGNAL current_sum_output_next : std_logic_vector(127 DOWNTO 0);         

attribute KEEP : string;
attribute DONT_TOUCH : string;

attribute KEEP of deformed_contribution_input_reg : signal is "TRUE";
attribute KEEP of current_sum_input_reg : signal is "TRUE";

attribute DONT_TOUCH of benchmark : label is "TRUE";


begin
    benchmark : multH_16way PORT MAP (
            deformed_contribution_input => deformed_contribution_input_reg, 
            current_sum_input => current_sum_input_reg,          
            H_i => H_i_bench,                        
            deformed_contribution_output => deformed_contribution_output_next, 
			current_sum_output => current_sum_output_next
			);       
    
    process (clk, rst)
    begin
        IF rst = '0' THEN  
            deformed_contribution_input_reg  <= deformed_contribution_input_bench;
            current_sum_input_reg <= current_sum_input_bench; 
        ELSIF rising_edge(clk) THEN
            deformed_contribution_input_reg(127 DOWNTO 1)  <= deformed_contribution_output_next(126 DOWNTO 0);
            deformed_contribution_input_reg(0)  <= deformed_contribution_output_next(127);
            current_sum_input_reg(127 DOWNTO 1) <= current_sum_output_next(126 DOWNTO 0);
            current_sum_input_reg(0) <= current_sum_output_next(127);
        END IF;
    end process;
    void <= current_sum_output_next(3) XOR deformed_contribution_output_next(89);
end behavior;