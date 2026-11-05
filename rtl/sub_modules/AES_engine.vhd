library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- Fully pipelined AES engine, performing the 14 rounds of AES 256
--
-- Initiation Interval = 1 cycle
-- Latency : 14 cycles
-- ============================================================================

entity aes_engine is
  port (
    valid_in      : in    std_logic;
    plaintext     : in    std_logic_vector(127 downto 0);
    key_scheduled : in    std_logic_vector(1919 downto 0);
    clk           : in    std_logic;
    rst           : in    std_logic;
    ciphertext    : out   std_logic_vector(127 downto 0);
    valid_out     : out   std_logic
  );
end entity aes_engine;

architecture behavior of aes_engine is

  component addroundkey is
    port (
      round_key    : in    std_logic_vector(127 downto 0);
      state        : in    std_logic_vector(127 downto 0);
      output_state : out   std_logic_vector(127 downto 0)
    );
  end component addroundkey;

  component mixcolumns is
    port (
      state_column        : in    std_logic_vector(31 downto 0);
      output_state_column : out   std_logic_vector(31 downto 0)
    );
  end component mixcolumns;

  component shiftrows is
    port (
      state        : in    std_logic_vector(127 downto 0);
      output_state : out   std_logic_vector(127 downto 0)
    );
  end component shiftrows;

  component subbytes_8bram is
    port (
      state        : in    std_logic_vector(127 downto 0);
      clk          : in    std_logic;
      rst          : in    std_logic;
      output_state : out   std_logic_vector(127 downto 0)
    );
  end component subbytes_8bram;

  type array_output_addround_key_t is array(0 to 14) of std_logic_vector(127 downto 0);

  signal addroundkey_output : array_output_addround_key_t;

  type array_output_t is array(0 to 13) of std_logic_vector(127 downto 0);

  signal subbytes_output   : array_output_t;
  signal shiftrows_output  : array_output_t;
  signal mixcolumns_output : array_output_t;

  type following_registers_t is array(0 to 13) of std_logic;

  signal valid_reg : following_registers_t;

begin

  -- round 0
  add_round_key_inst_init : component addroundkey
    port map (
      round_key    => key_scheduled(127 downto 0),
      state        => plaintext,
      output_state => addroundkey_output(0)
    );

  -- rounds 1 to 13

  module_generation : for i in 0 to 12 generate
  begin

    add_round_key_inst : component addroundkey
      port map (
        round_key    => key_scheduled(128 * (i + 2) - 1 downto 128 * (i + 1)),
        state        => mixcolumns_output(i),
        output_state => addroundkey_output(i + 1)
      );

    mix_columns_inst_0 : component mixcolumns
      port map (
        state_column        => shiftrows_output(i)(31 downto 0),
        output_state_column => mixcolumns_output(i)(31 downto 0)
      );

    mix_columns_inst_1 : component mixcolumns
      port map (
        state_column        => shiftrows_output(i)(63 downto 32),
        output_state_column => mixcolumns_output(i)(63 downto 32)
      );

    mix_columns_inst_2 : component mixcolumns
      port map (
        state_column        => shiftrows_output(i)(95 downto 64),
        output_state_column => mixcolumns_output(i)(95 downto 64)
      );

    mix_columns_inst_3 : component mixcolumns
      port map (
        state_column        => shiftrows_output(i)(127 downto 96),
        output_state_column => mixcolumns_output(i)(127 downto 96)
      );

    shift_rows_inst : component shiftrows
      port map (
        state        => subbytes_output(i),
        output_state => shiftrows_output(i)
      );

    sub_bytes_inst : component subbytes_8bram
      port map (
        state        => addroundkey_output(i),
        clk          => clk,
        rst          => rst,
        output_state => subbytes_output(i)
      );

  end generate module_generation;

  -- final round
  add_round_key_inst_final : component addroundkey
    port map (
      round_key    => key_scheduled(1919 downto 1792),
      state        => shiftrows_output(13),
      output_state => addroundkey_output(14)
    );

  shift_rows_inst_final : component shiftrows
    port map (
      state        => subbytes_output(13),
      output_state => shiftrows_output(13)
    );

  sub_bytes_inst_final : component subbytes_8bram
    port map (
      state        => addroundkey_output(13),
      clk          => clk,
      rst          => rst,
      output_state => subbytes_output(13)
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      valid_reg(0) <= '0';
    elsif rising_edge(clk) then
      valid_reg(0) <= valid_in;

      for i in 0 to 12 loop

        valid_reg(i + 1) <= valid_reg(i);

      end loop;

    end if;

  end process;

  valid_out  <= valid_reg(13);
  ciphertext <= addroundkey_output(14);

end architecture behavior;
