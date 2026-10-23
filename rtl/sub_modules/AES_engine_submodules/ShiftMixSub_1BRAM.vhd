library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)
entity ShiftMixSub_1BRAM is
	port(
		state : IN std_logic_vector(127 DOWNTO 0);
		counter : IN NATURAL range 0 to 8;
		clk : IN std_logic;
		rst : IN std_logic;
		last_round : IN std_logic;
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end ShiftMixSub_1BRAM;

architecture behavior of ShiftMixSub_1BRAM is

SIGNAL ADDRA, ADDRB : std_logic_vector(9 DOWNTO 0);
SIGNAL DOA, DOB : std_logic_vector(31 DOWNTO 0);

SIGNAL A0_0, A1_0, A2_0, A3_0 : std_logic_vector(7 DOWNTO 0);
SIGNAL A0_1, A1_1, A2_1, A3_1 : std_logic_vector(7 DOWNTO 0);
SIGNAL A0_2, A1_2, A2_2, A3_2 : std_logic_vector(7 DOWNTO 0);
SIGNAL A0_3, A1_3, A2_3, A3_3 : std_logic_vector(7 DOWNTO 0);

SIGNAL temp_0, temp_1 : std_logic_vector(31 DOWNTO 0);
SIGNAL final_column : std_logic_vector(31 DOWNTO 0);

COMPONENT XOR32 IS
  PORT (
    A 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    B 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    A_XOR_B	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END COMPONENT;

-- contains T-tables
COMPONENT BRAM_36_true_dual_port is
	port (
		ADDRA : IN std_logic_vector(9 DOWNTO 0);
		ADDRB : IN std_logic_vector(9 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		DOA : OUT std_logic_vector(31 DOWNTO 0);
		DOB : OUT std_logic_vector(31 DOWNTO 0)
	);
end COMPONENT;

begin

T_table : BRAM_36_true_dual_port PORT MAP (         
                ADDRA => ADDRA,
                ADDRB => ADDRB,
                clk => clk,
                rst => rst,
                DOA => DOA,
                DOB => DOB );

A0_0 <= state(127 DOWNTO 120);
A1_0 <= state(119 DOWNTO 112);
A2_0 <= state(111 DOWNTO 104);
A3_0 <= state(103 DOWNTO 96);
A0_1 <= state(95 DOWNTO 88);
A1_1 <= state(87 DOWNTO 80);
A2_1 <= state(79 DOWNTO 72);
A3_1 <= state(71 DOWNTO 64);
A0_2 <= state(63 DOWNTO 56);
A1_2 <= state(55 DOWNTO 48);
A2_2 <= state(47 DOWNTO 40);
A3_2 <= state(39 DOWNTO 32);
A0_3 <= state(31 DOWNTO 24);
A1_3 <= state(23 DOWNTO 16);
A2_3 <= state(15 DOWNTO 8);
A3_3 <= state(7 DOWNTO 0);

XORING_T : XOR32 PORT MAP(
    A => DOA,
    B => DOB,
    A_XOR_B => temp_0);
    
COLUMN_FINAL : XOR32 PORT MAP(
    A => temp_0,
    B => temp_1,
    A_XOR_B => final_column);

process(clk, rst)
begin
    IF rst = '0' THEN
        output_state <= (OTHERS => '0');
    ELSIF rising_edge(clk) then
        temp_1 <= temp_0;        
        CASE counter is
            WHEN 0 => -- "setup"
                ADDRA(9 DOWNTO 8) <= "11"; -- T3
                ADDRB(9 DOWNTO 8) <= "10"; -- T2
                ADDRA(7 DOWNTO 0) <= A3_2;
                ADDRB(7 DOWNTO 0) <= A2_1;
                
            WHEN 1 =>
                ADDRA(9 DOWNTO 8) <= "01"; -- T1
                ADDRB(9 DOWNTO 8) <= "00"; -- T0
                ADDRA(7 DOWNTO 0) <= A1_0;
                ADDRB(7 DOWNTO 0) <= A0_3;
                IF last_round = '1' THEN
                    output_state(127 DOWNTO 120) <= DOA(31 DOWNTO 24);
                    output_state(119 DOWNTO 112) <= DOB(7 DOWNTO 0);
                END IF;
            WHEN 2 =>
                ADDRA(9 DOWNTO 8) <= "11";
                ADDRB(9 DOWNTO 8) <= "10";
                ADDRA(7 DOWNTO 0) <= A3_1;
                ADDRB(7 DOWNTO 0) <= A2_0;
                
                IF last_round = '1' THEN
                    output_state(111 DOWNTO 104) <= DOA(15 DOWNTO 8);
                    output_state(103 DOWNTO 96) <= DOB(23 DOWNTO 16);
                ELSE 
                    output_state(127 DOWNTO 96) <= final_column;
                END IF;
            WHEN 3 =>
                ADDRA(9 DOWNTO 8) <= "01";
                ADDRB(9 DOWNTO 8) <= "00";
                ADDRA(7 DOWNTO 0) <= A1_3;
                ADDRB(7 DOWNTO 0) <= A0_2;
                IF last_round = '1' THEN
                    output_state(95 DOWNTO 88) <= DOA(31 DOWNTO 24);
                    output_state(87 DOWNTO 80) <= DOB(7 DOWNTO 0);
                END IF;
            WHEN 4 =>
                ADDRA(9 DOWNTO 8) <= "11";
                ADDRB(9 DOWNTO 8) <= "10";
                ADDRA(7 DOWNTO 0) <= A3_0;
                ADDRB(7 DOWNTO 0) <= A2_3;
                IF last_round = '1' THEN
                    output_state(79 DOWNTO 72) <= DOA(15 DOWNTO 8);
                    output_state(71 DOWNTO 64) <= DOB(23 DOWNTO 16);
                ELSE
                    output_state(95 DOWNTO 64) <= final_column;
                END IF;
            WHEN 5 =>
                ADDRA(9 DOWNTO 8) <= "01";
                ADDRB(9 DOWNTO 8) <= "00";
                ADDRA(7 DOWNTO 0) <= A1_2;
                ADDRB(7 DOWNTO 0) <= A0_1;
                IF last_round = '1' THEN
                    output_state(63 DOWNTO 56) <= DOA(31 DOWNTO 24);
                    output_state(55 DOWNTO 48) <= DOB(7 DOWNTO 0);
                END IF;
            WHEN 6 =>
                ADDRA(9 DOWNTO 8) <= "11";
                ADDRB(9 DOWNTO 8) <= "10";
                ADDRA(7 DOWNTO 0) <= A3_3;
                ADDRB(7 DOWNTO 0) <= A2_2;
                IF last_round = '1' THEN
                    output_state(47 DOWNTO 40) <= DOA(15 DOWNTO 8);
                    output_state(39 DOWNTO 32) <= DOB(23 DOWNTO 16);
                ELSE
                    output_state(63 DOWNTO 32) <= final_column;
                END IF;
            WHEN 7 =>
                ADDRA(9 DOWNTO 8) <= "01";
                ADDRB(9 DOWNTO 8) <= "00";
                ADDRA(7 DOWNTO 0) <= A1_1;
                ADDRB(7 DOWNTO 0) <= A0_0;
                IF last_round = '1' THEN
                    output_state(31 DOWNTO 24) <= DOA(31 DOWNTO 24);
                    output_state(23 DOWNTO 16) <= DOB(7 DOWNTO 0);
                END IF;
            WHEN 8 => 
                ADDRA(9 DOWNTO 8) <= "11";
                ADDRB(9 DOWNTO 8) <= "10";
                ADDRA(7 DOWNTO 0) <= A3_2;
                ADDRB(7 DOWNTO 0) <= A2_1;
                IF last_round = '1' THEN
                    output_state(15 DOWNTO 8) <= DOA(15 DOWNTO 8);
                    output_state(7 DOWNTO 0) <= DOB(23 DOWNTO 16);
                ELSE
                    output_state(31 DOWNTO 0) <= final_column;
                END IF;
        END CASE;
    END IF;
end process;



end behavior;