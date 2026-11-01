library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AES_engine is
	port(
		valid_in : IN std_logic; 
		plaintext : IN std_logic_vector(127 DOWNTO 0);
		key_scheduled : IN std_logic_vector(1919 DOWNTO 0);
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		ciphertext : OUT std_logic_vector(127 DOWNTO 0);
		valid_out : OUT std_logic
	);
end AES_engine;

architecture behavior of AES_engine is

COMPONENT AddRoundKey is
	port(
		round_key : IN std_logic_vector(127 DOWNTO 0);
		state : IN std_logic_vector(127 DOWNTO 0);
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end COMPONENT;


COMPONENT MixColumns is
	port(
		state_column : IN std_logic_vector(31 DOWNTO 0);
		output_state_column : OUT std_logic_vector(31 DOWNTO 0)
	);
end COMPONENT;


COMPONENT ShiftRows is
	port (
		state : IN std_logic_vector(127 DOWNTO 0);
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end COMPONENT;


COMPONENT SubBytes_8BRAM is
	port (
		state : IN std_logic_vector(127 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		output_state : OUT std_logic_vector(127 DOWNTO 0)
	);
end COMPONENT;

type array_output_addround_key_t is array(0 to 14) of std_logic_vector(127 downto 0);
signal addroundkey_output : array_output_addround_key_t;

type array_output_t is array(0 to 13) of std_logic_vector(127 downto 0);
signal subbytes_output : array_output_t;
signal shiftrows_output : array_output_t;
signal mixcolumns_output : array_output_t;

type following_registers_t is array(0 to 13) of std_logic;
signal valid_reg : following_registers_t;


begin

-- round 0
    add_round_key_inst_init : AddRoundKey
    PORT MAP(
        round_key => key_scheduled(127 DOWNTO 0),
        state => plaintext,
        output_state => addroundkey_output(0)
    );

-- rounds 1 to 13
    module_generation:
    for i in 0 to 12 generate
    begin
        add_round_key_inst : AddRoundKey PORT MAP(
            round_key => key_scheduled(128*(i+2) - 1 DOWNTO 128*(i+1)),
            state => mixcolumns_output(i),
            output_state => addroundkey_output(i+1)
        );
        
        mix_columns_inst_0 : MixColumns PORT MAP(
            state_column => shiftrows_output(i)(31 DOWNTO 0),
            output_state_column => mixcolumns_output(i)(31 DOWNTO 0)
        );
        mix_columns_inst_1 : MixColumns PORT MAP(
            state_column => shiftrows_output(i)(63 DOWNTO 32),
            output_state_column => mixcolumns_output(i)(63 DOWNTO 32)
        );
        mix_columns_inst_2 : MixColumns PORT MAP(
            state_column => shiftrows_output(i)(95 DOWNTO 64),
            output_state_column => mixcolumns_output(i)(95 DOWNTO 64)
        );
        mix_columns_inst_3 : MixColumns PORT MAP(
            state_column => shiftrows_output(i)(127 DOWNTO 96),
            output_state_column => mixcolumns_output(i)(127 DOWNTO 96)
        );
        
        shift_rows_inst : ShiftRows PORT MAP(
            state => subbytes_output(i),
            output_state => shiftrows_output(i)
        );
        
        sub_bytes_inst : SubBytes_8BRAM PORT MAP(
            state => addroundkey_output(i),
            clk => clk,
            rst => rst,
            output_state => subbytes_output(i)
        );
    end generate;
    -- final round
    add_round_key_inst_final : AddRoundKey PORT MAP(
        round_key => key_scheduled(1919 DOWNTO 1792),
        state => shiftrows_output(13),
        output_state => addroundkey_output(14)
    );
    
    shift_rows_inst_final : ShiftRows PORT MAP(
        state => subbytes_output(13),
        output_state => shiftrows_output(13)
    );
    
    sub_bytes_inst_final : SubBytes_8BRAM PORT MAP(
        state => addroundkey_output(13),
        clk => clk,
        rst => rst,
        output_state => subbytes_output(13)
    );
        

    process(clk, rst)
    begin
        if rst = '0' then
            valid_reg(0) <= '0';
        elsif rising_edge(clk) then
            valid_reg(0) <= valid_in;
            for i in 0 to 12 loop
                valid_reg(i+1) <= valid_reg(i);
            end loop;
        end if;
    end process;
    
    valid_out <= valid_reg(13);
    ciphertext <= addroundkey_output(14);

end behavior;