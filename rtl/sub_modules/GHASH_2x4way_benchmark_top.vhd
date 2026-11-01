library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.utils_pkg.all;

entity GHASH_2x4way_benchmark_top is
	port(
		clk : IN std_logic;
		rst : IN std_logic;
		start : IN std_logic;
		load_A : IN std_logic;
		load_B : IN std_logic;
		swap : IN std_logic;
		counter : IN std_logic_vector(1 DOWNTO 0);
		void : OUT std_logic_vector(127 DOWNTO 0)
	);
end GHASH_2x4way_benchmark_top;

architecture behavior of GHASH_2x4way_benchmark_top is

COMPONENT GHASH_2x4way is
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
		valid_A : IN std_logic;
		valid_B : IN std_logic;
		swap : IN std_logic;
		final_block : IN std_logic;
		counter : IN std_logic_vector(1 DOWNTO 0);
		new_AD : OUT std_logic_vector(127 DOWNTO 0);
		valid_AD : OUT std_logic
	);
end COMPONENT;

SIGNAL CI_A : STD_LOGIC_VECTOR(127 DOWNTO 0) := X"0123456789ABCDEF0123456789ABCDEF";
SIGNAL CI_B : STD_LOGIC_VECTOR(127 DOWNTO 0) := X"0123456789ABCDEF0123456789ABCDEF";
SIGNAL H : STD_LOGIC_VECTOR(127 DOWNTO 0) := X"0123456789ABCDEF0123456789ABCDEF";
SIGNAL prev_AD : STD_LOGIC_VECTOR(127 DOWNTO 0) := X"0123456789ABCDEF0123456789ABCDEF";
SIGNAL new_AD : STD_LOGIC_VECTOR(127 DOWNTO 0);

begin
    GHASH : GHASH_2x4way PORT MAP(
        CI_A => CI_A,
        CI_B => CI_B,
        H => H,
        prev_AD => prev_AD,
        clk => clk,
        rst => rst,
        start => start,
        load_A => load_A,
        load_B => load_B,
        valid_A => '1',
        valid_B => '1',
        swap => swap,     
        final_block => '0',
        counter => counter,
        new_AD => new_AD
    );
    
    process (clk, rst)
    begin
        if rst = '0' THEN
            CI_A <= X"0123456789ABCDEF0123456789ABCDEF";
            CI_B <= X"0123456789ABCDEF0123456789ABCDEF";
            H <= X"0123456789ABCDEF0123456789ABCDEF";
            prev_AD <= X"0123456789ABCDEF0123456789ABCDEF";
        elsif rising_edge(clk) then
            CI_A(126 DOWNTO 0) <= CI_A(127 DOWNTO 1);
            CI_B(126 DOWNTO 0) <= CI_B(127 DOWNTO 1);
            H(126 DOWNTO 0) <= H(127 DOWNTO 1);
            prev_AD(126 DOWNTO 0) <= prev_AD(127 DOWNTO 1);
                        
            CI_A(127) <= CI_A(0);
            CI_B(127) <= CI_B(0);
            H(127) <= H(0);
            prev_AD(127) <= prev_AD(0);
        end if;
    end process;
    
    void <= new_AD;
end behavior;