library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.utils_pkg.all;

entity GHASH_2x4way is
	port(
		CI_A : IN std_logic_vector(127 DOWNTO 0);
		CI_B : IN std_logic_vector(127 DOWNTO 0);
		H : IN std_logic_vector(127 DOWNTO 0);
		prev_AD : IN std_logic_vector(127 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		start : IN std_logic;
		load_A : IN std_logic;
		load_B : IN std_logic;
		swap : IN std_logic;
		counter : IN std_logic_vector(1 DOWNTO 0);
		new_AD : OUT std_logic_vector(127 DOWNTO 0)
	);
end GHASH_2x4way;

architecture behavior of GHASH_2x4way is

SIGNAL stock_A_reg, stock_B_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);


COMPONENT H_init is
	port(
		H : IN std_logic_vector(127 DOWNTO 0); -- H for the first one
		start : IN std_logic;
		clk : IN std_logic;
		rst: IN std_logic;
		valid: OUT std_logic;
		H_out: OUT std_logic_vector(127 DOWNTO 0)
	);
end COMPONENT;
SIGNAL valid_s : std_logic;
SIGNAL H_out_s : std_logic_vector(127 DOWNTO 0);


COMPONENT multH_32way is
	port(
		deformed_contribution_input : IN std_logic_vector(127 DOWNTO 0);
		current_sum_input : IN std_logic_vector(127 DOWNTO 0);
		H_i : IN std_logic_vector(31 DOWNTO 0);
		deformed_contribution_output : OUT std_logic_vector(127 DOWNTO 0);
		current_sum_output : OUT std_logic_vector(127 DOWNTO 0)
	);
end COMPONENT;
Type multH_reg_t is array (0 to 2) of STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL multH_contrib_reg_A, multH_contrib_reg_B: multH_reg_t;
SIGNAL multH_current_sum_reg_A, multH_current_sum_reg_B: multH_reg_t;
Type multH_s_t is array (0 to 7) of STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL multH_contrib_s_A, multH_contrib_s_B: multH_s_t;
SIGNAL multH_current_sum_s_A, multH_current_sum_s_B: multH_s_t;

SIGNAL multH_initial_sum : STD_LOGIC_VECTOR(127 DOWNTO 0):=X"00000000000000000000000000000000";
SIGNAL multH_final_contrib_sig_A, multH_final_contrib_sig_B: STD_LOGIC_VECTOR(127 DOWNTO 0);


COMPONENT H_power_bank IS
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
END COMPONENT;
SIGNAL enable_HPOW_A : STD_LOGIC;
SIGNAL enable_HPOW_B : STD_LOGIC;
Type HPOW_col_t is array (0 to 3) of STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL HPOW_col_A, HPOW_col_B: HPOW_col_t;


SIGNAL tag_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);

Type HPOW_counter_t is array (0 to 2) of STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL counter_delay_reg : HPOW_counter_t;

Type HPOW_counter_s_t is array (0 to 3) of STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL counter_s : HPOW_counter_s_t;



begin

    
    enable_HPOW_A <= load_A AND valid_s;
    enable_HPOW_B <= (load_B AND valid_s) OR start;
    
    counter_s(0) <= counter;
    counter_s(1) <= counter_delay_reg(0) WHEN (load_A = '0' AND load_B = '0') ELSE counter;
    counter_s(2) <= counter_delay_reg(1) WHEN (load_A = '0' AND load_B = '0') ELSE counter;
    counter_s(3) <= counter_delay_reg(2) WHEN (load_A = '0' AND load_B = '0') ELSE counter;
    
    multH_contrib_s_A(0) <= stock_A_reg WHEN counter = "00" AND swap = '1'
    ELSE stock_A_reg XOR prev_AD WHEN counter = "00" AND swap = '0'
    ELSE CI_A;
    multH_contrib_s_A(2) <= multH_contrib_reg_A(0);
    multH_contrib_s_A(4) <= multH_contrib_reg_A(1);
    multH_contrib_s_A(6) <= multH_contrib_reg_A(2);
    
    multH_contrib_s_B(0) <= stock_B_reg WHEN counter = "00" AND swap = '0'
    ELSE stock_B_reg XOR prev_AD WHEN counter = "00" AND swap = '1'
    ELSE CI_B;
    multH_contrib_s_B(2) <= multH_contrib_reg_B(0);
    multH_contrib_s_B(4) <= multH_contrib_reg_B(1);
    multH_contrib_s_B(6) <= multH_contrib_reg_B(2);
    
    multH_current_sum_s_A(0) <= multH_initial_sum;   
    multH_current_sum_s_A(2) <= multH_current_sum_reg_A(0);     
    multH_current_sum_s_A(4) <= multH_current_sum_reg_A(1);     
    multH_current_sum_s_A(6) <= multH_current_sum_reg_A(2); 
      
    multH_current_sum_s_B(0) <= multH_initial_sum;   
    multH_current_sum_s_B(2) <= multH_current_sum_reg_B(0);     
    multH_current_sum_s_B(4) <= multH_current_sum_reg_B(1);     
    multH_current_sum_s_B(6) <= multH_current_sum_reg_B(2);       

    H_inititialiser : H_init PORT MAP (
        H => H,
		start => start,
		clk => clk,
		rst => rst,
		valid => valid_s,
		H_out => H_out_s
    );
    
    module_generation:
    for i in 0 to 3 generate
    begin
        multH_A : multH_32way PORT MAP (
            deformed_contribution_input => multH_contrib_s_A(2*i),
            current_sum_input  => multH_current_sum_s_A(2*i),
            H_i => HPOW_col_A(i),
            deformed_contribution_output => multH_contrib_s_A(2*i+1),
            current_sum_output => multH_current_sum_s_A(2*i+1)
        );
        
        multH_B : multH_32way PORT MAP (
            deformed_contribution_input => multH_contrib_s_B(2*i),
            current_sum_input  => multH_current_sum_s_B(2*i),
            H_i => HPOW_col_B(i),
            deformed_contribution_output => multH_contrib_s_B(2*i+1),
            current_sum_output => multH_current_sum_s_B(2*i+1)
        );

        POWH_A : H_power_bank PORT MAP (
            H_4_in 	=>   H_out_s(32*(i+1)-1 DOWNTO 32*i),
            load 	=>   enable_HPOW_A,
            clk 	=>   clk,
            counter =>   counter_s(i),
            output	=>   HPOW_col_A(i)
        );
        
        POWH_B : H_power_bank PORT MAP (
            H_4_in 	=>   H_out_s(32*(i+1)-1 DOWNTO 32*i),
            load 	=>   enable_HPOW_B,
            clk 	=>   clk,
            counter =>   counter_s(i),
            output	=>   HPOW_col_B(i)
        );
    end generate;
    
    
    process (clk, rst)
    begin
        IF rst = '0' THEN
        
        ELSIF rising_edge(clk) THEN
            counter_delay_reg(0) <= counter;
            counter_delay_reg(1) <= counter_delay_reg(0);
            counter_delay_reg(2) <= counter_delay_reg(1);
            
            
            If counter = "00" THEN
                stock_A_reg <= CI_A;
                stock_B_reg <= CI_B;
            ELSE
                stock_A_reg <= stock_A_reg;
                stock_B_reg <= stock_B_reg;
            END IF;
            
            for i in 0 to 2 loop
                multH_contrib_reg_A(i) <= multH_contrib_s_A(2*i+1);
                multH_contrib_reg_B(i) <= multH_contrib_s_B(2*i+1);
                multH_current_sum_reg_A(i) <= multH_current_sum_s_A(2*i+1);
                multH_current_sum_reg_B(i) <= multH_current_sum_s_B(2*i+1);
            end loop;
            
            tag_reg <= multH_current_sum_s_A(7) XOR multH_current_sum_s_B(7) XOR tag_reg;
        END IF;
    end process;
    
    new_AD <= tag_reg; 
end behavior;