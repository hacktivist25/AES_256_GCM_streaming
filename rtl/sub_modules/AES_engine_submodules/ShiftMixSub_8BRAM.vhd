library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)
entity ShiftMixSub_8BRAM is
	port(
		state : IN std_logic_vector(127 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		last_round : IN std_logic;
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end ShiftMixSub_8BRAM;

architecture behavior of ShiftMixSub_8BRAM is

type addr_array_t is array (0 to 7) of std_logic_vector(9 downto 0);
signal ADDRA, ADDRB : addr_array_t;

type do_array_t is array (0 to 7) of std_logic_vector(31 downto 0);
signal DOA, DOB : do_array_t;

SIGNAL A0_0, A1_0, A2_0, A3_0 : std_logic_vector(7 DOWNTO 0);
SIGNAL A0_1, A1_1, A2_1, A3_1 : std_logic_vector(7 DOWNTO 0);
SIGNAL A0_2, A1_2, A2_2, A3_2 : std_logic_vector(7 DOWNTO 0);
SIGNAL A0_3, A1_3, A2_3, A3_3 : std_logic_vector(7 DOWNTO 0);

type temp_array_t is array (0 to 7) of std_logic_vector(31 downto 0);
signal temp : temp_array_t;

type column_array_t is array (0 to 3) of std_logic_vector(31 downto 0);
signal final_column : column_array_t;

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

-- instanciate BRAMs
gen_t_tables_bram : for i in 0 to 7 generate
begin
    BRAM_TDP_MACRO_inst : BRAM_36_true_dual_port
    port map (
        DOA => DOA(i),
        DOB => DOB(i),
        ADDRA => ADDRA(i),
        ADDRB => ADDRB(i),
        clk => clk,
        rst => rst
    );
end generate;

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

-- instanciate XORS temporaty results
gen_xors_bram : for i in 0 to 7 generate
    begin
    XORING_T : XOR32 PORT MAP(
        A => DOA(i),
        B => DOB(i),
        A_XOR_B => temp(i));
end generate;
    
-- instanciate columns results
gen_columns_bram : for i in 0 to 3 generate
    begin
    COLUMN_FINAL : XOR32 PORT MAP(
        A => temp(2*i),
        B => temp((2*i)+1),
        A_XOR_B => final_column(i));
end generate;

process(clk, rst)
begin
    IF rst = '0' THEN
        ADDRA(0) <= (OTHERS => '0');
        ADDRB(0) <= (OTHERS => '0');
        ADDRA(1) <= (OTHERS => '0');
        ADDRB(1) <= (OTHERS => '0');
        ADDRA(2) <= (OTHERS => '0');
        ADDRB(2) <= (OTHERS => '0');
        ADDRA(3) <= (OTHERS => '0');
        ADDRB(3) <= (OTHERS => '0');
        ADDRA(4) <= (OTHERS => '0');
        ADDRB(4) <= (OTHERS => '0');
        ADDRA(5) <= (OTHERS => '0');
        ADDRB(5) <= (OTHERS => '0');
        ADDRA(6) <= (OTHERS => '0');
        ADDRB(6) <= (OTHERS => '0');
        ADDRA(7) <= (OTHERS => '0');
        ADDRB(7) <= (OTHERS => '0');
    ELSIF rising_edge(clk) then
        -- 4th / last column
        ADDRA(0)(9 DOWNTO 8) <= "11";
        ADDRB(0)(9 DOWNTO 8) <= "10";
        ADDRA(0)(7 DOWNTO 0) <= A3_2;
        ADDRB(0)(7 DOWNTO 0) <= A2_1;
        ADDRA(1)(9 DOWNTO 8) <= "01";
        ADDRB(1)(9 DOWNTO 8) <= "00";
        ADDRA(1)(7 DOWNTO 0) <= A1_0;
        ADDRB(1)(7 DOWNTO 0) <= A0_3;
        -- 3rd column
        ADDRA(2)(9 DOWNTO 8) <= "11";
        ADDRB(2)(9 DOWNTO 8) <= "10";
        ADDRA(2)(7 DOWNTO 0) <= A3_1;
        ADDRB(2)(7 DOWNTO 0) <= A2_0;
        ADDRA(3)(9 DOWNTO 8) <= "01";
        ADDRB(3)(9 DOWNTO 8) <= "00";
        ADDRA(3)(7 DOWNTO 0) <= A1_3;
        ADDRB(3)(7 DOWNTO 0) <= A0_2;
        -- 2nd column
        ADDRA(4)(9 DOWNTO 8) <= "11";
        ADDRB(4)(9 DOWNTO 8) <= "10";
        ADDRA(4)(7 DOWNTO 0) <= A3_0;
        ADDRB(4)(7 DOWNTO 0) <= A2_3;
        ADDRA(5)(9 DOWNTO 8) <= "01";
        ADDRB(5)(9 DOWNTO 8) <= "00";
        ADDRA(5)(7 DOWNTO 0) <= A1_2;
        ADDRB(5)(7 DOWNTO 0) <= A0_1;
        -- 1st column
        ADDRA(6)(9 DOWNTO 8) <= "11";
        ADDRB(6)(9 DOWNTO 8) <= "10";
        ADDRA(6)(7 DOWNTO 0) <= A3_3;
        ADDRB(6)(7 DOWNTO 0) <= A2_2;
        ADDRA(7)(9 DOWNTO 8) <= "01";
        ADDRB(7)(9 DOWNTO 8) <= "00";
        ADDRA(7)(7 DOWNTO 0) <= A1_1;
        ADDRB(7)(7 DOWNTO 0) <= A0_0;
    END IF;
end process;

output_state (127 DOWNTO 96) <= final_column(0) WHEN last_round = '0'
   ELSE
   DOA(0)(31 downto 24) &
   DOB(0)(7 downto 0) &
   DOA(1)(15 downto 8) &
   DOB(1)(23 downto 16);
   
output_state (95 DOWNTO 64) <= final_column(1) WHEN last_round = '0'
   ELSE
   DOA(2)(31 downto 24) &
   DOB(2)(7 downto 0) &
   DOA(3)(15 downto 8) &
   DOB(3)(23 downto 16);
   
output_state (63 DOWNTO 32) <= final_column(2) WHEN last_round = '0'
   ELSE
   DOA(4)(31 downto 24) &
   DOB(4)(7 downto 0) &
   DOA(5)(15 downto 8) &
   DOB(5)(23 downto 16);
   
output_state (31 DOWNTO 0) <= final_column(3) WHEN last_round = '0'
   ELSE
   DOA(6)(31 downto 24) &
   DOB(6)(7 downto 0) &
   DOA(7)(15 downto 8) &
   DOB(7)(23 downto 16);


end behavior;