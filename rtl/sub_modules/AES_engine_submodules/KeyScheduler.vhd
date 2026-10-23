library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- scheduler takes 13 clock cycles to produce fully expanded key
entity KeyScheduler is
	port(
		key : IN std_logic_vector(255 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		start : IN std_logic;
		done : OUT std_logic;
		round_key : OUT std_logic_vector(127 DOWNTO 0)
	);
end KeyScheduler;

architecture behavior of KeyScheduler is

COMPONENT RotWord is
	port(
		column : IN std_logic_vector(31 DOWNTO 0);
		output_column : OUT std_logic_vector(31 DOWNTO 0)
	);
end COMPONENT;

COMPONENT SubWord is
	port(
		column : IN std_logic_vector(31 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		output_column : OUT std_logic_vector(31 DOWNTO 0)
	);
end COMPONENT;

COMPONENT XOR32 IS
  PORT (
    A 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    B 	: IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    A_XOR_B	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END COMPONENT;


SIGNAL counter :  NATURAL range 0 to 15;
SIGNAL even_s : STD_LOGIC;

SIGNAL Rcon : STD_LOGIC_VECTOR(55 DOWNTO 0) := X"01020408102040";
SIGNAL Rcon_i : STD_LOGIC_VECTOR(7 DOWNTO 0);


SIGNAL operating :  STD_LOGIC;

-- previous Wi stored
type Wi_prev_t is array (0 to 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL W_i : Wi_prev_t;

-- calculated W_i
type Wi_calc_t is array (0 to 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL W_i_calc : Wi_calc_t;
SIGNAL W_i_temp_0, W_i_temp_1, W_i_temp_2, W_i_temp_3, W_i_temp_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

-- Rcon_i distribution
Rcon_i <= Rcon (55 DOWNTO 48) WHEN (counter = 0 OR counter = 1 OR counter = 2 OR counter = 3) 
ELSE Rcon (47 DOWNTO 40) WHEN (counter = 4 OR counter = 5) 
ELSE Rcon (39 DOWNTO 32) WHEN (counter = 6 OR counter = 7) 
ELSE Rcon (31 DOWNTO 24) WHEN (counter = 8 OR counter = 9) 
ELSE Rcon (23 DOWNTO 16) WHEN (counter = 10 OR counter = 11) 
ELSE Rcon (15 DOWNTO 8) WHEN (counter = 12 OR counter = 13) 
ELSE Rcon (7 DOWNTO 0);

even_s <= TO_UNSIGNED(counter, 4)(0);
W_i_temp_1 <= W_i_temp_0 WHEN even_s = '0' ELSE W_i(3);
W_i_temp_4 <= (W_i_temp_3(31 DOWNTO 24) XOR rcon_i) & W_i_temp_3(23 DOWNTO 0);

Rotword_0 : RotWord PORT MAP(
        column => W_i(3),
        output_column => W_i_temp_0
);

Subword_0 : SubWord PORT MAP(
        column => W_i_temp_1,
        clk => clk,
        rst => rst,
        output_column => W_i_temp_2
);

XOR_0 : XOR32 PORT MAP(
        A => W_i(0),
        B => W_i_temp_2,
        A_XOR_B => W_i_temp_3
);
XOR_1 : XOR32 PORT MAP(
        A => W_i_calc(0),
        B => W_i(1),
        A_XOR_B => W_i_calc(1)
);
XOR_2 : XOR32 PORT MAP(
        A => W_i_calc(1),
        B => W_i(2),
        A_XOR_B => W_i_calc(2)
);
XOR_3 : XOR32 PORT MAP(
        A => W_i_calc(2),
        B => W_i(3),
        A_XOR_B => W_i_calc(3)
);

W_i_calc(0) <= W_i_temp_4 WHEN even_s = '0' ELSE W_i_temp_3;

process (clk, rst)
begin
    IF rst = '0' then
        W_i(0) <= (OTHERS => '0');
        W_i(1) <= (OTHERS => '0');
        W_i(2) <= (OTHERS => '0');
        W_i(3) <= (OTHERS => '0');
        counter <= 0;
        operating <= '0';
        done <= '0';
    ELSIF RISING_EDGE(clk) THEN
        -- counter
        IF operating = '1' THEN
            IF counter <= 15 THEN
                counter <= counter + 1;
             ELSE
                counter <= 0;
             END IF;
        END IF;
        done <= '0';
        
        IF counter = 0 then
            W_i(0) <= key(127 DOWNTO 96);
            W_i(1) <= key(95 DOWNTO 64);
            W_i(2) <= key(63 DOWNTO 32);
            W_i(3) <= key(31 DOWNTO 0);
        ELSE
            W_i(0) <= W_i_calc(0);
            W_i(1) <= W_i_calc(1);
            W_i(2) <= W_i_calc(2);
            W_i(3) <= W_i_calc(3);

        END IF;
        
        IF start = '1' THEN
            W_i(0) <= key(255 DOWNTO 224);
            W_i(1) <= key(223 DOWNTO 192);
            W_i(2) <= key(191 DOWNTO 160);
            W_i(3) <= key(159 DOWNTO 128);
            operating <= '1';
        END IF;
        
        IF counter = 15 THEN
            operating <= '0';
            done <= '1';
        END IF;
        
    END IF;
end process;

round_key <= W_i(0) & W_i(1) & W_i(2) & W_i(3); 

end behavior;