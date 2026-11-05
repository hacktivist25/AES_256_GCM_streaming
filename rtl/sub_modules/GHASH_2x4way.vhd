library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.utils_pkg.all;

-- ============================================================================
-- GHASH engine calculates intermediate authentification tags, taking output from 2 AES engines
-- ci_a (ciphertext from AES engine A) and ci_b
-- they have a valid_a or valid_b tag when the output from AES is valid
--
-- uses a start signal to initialize the powers of H (H power 1 to H power 8) which takes 28 cycles (see h_init)
--
-- Initiation Interval = 1 cycle
-- Latency : 4 cycles
-- Produces an output every 4 valid pairs of AES ciphetexts
-- ============================================================================

entity ghash_2x4way is
  port (
    ci_a        : in    std_logic_vector(127 downto 0);
    ci_b        : in    std_logic_vector(127 downto 0);
    h           : in    std_logic_vector(127 downto 0);
    prev_ad     : in    std_logic_vector(127 downto 0);
    clk         : in    std_logic;
    rst         : in    std_logic;
    start       : in    std_logic;
    load_a      : in    std_logic;
    load_b      : in    std_logic;
    valid_a     : in    std_logic;
    valid_b     : in    std_logic;
    swap        : in    std_logic;
    final_block : in    std_logic;
    counter     : in    std_logic_vector(1 downto 0);
    new_ad      : out   std_logic_vector(127 downto 0);
    valid_ad    : out   std_logic
  );
end entity ghash_2x4way;

architecture behavior of ghash_2x4way is

  signal stock_a_reg,         stock_b_reg : std_logic_vector(127 downto 0);
  signal valid_a_reg,         valid_b_reg : std_logic;

  signal valid_a_s,           valid_b_s : std_logic;

  type delayers_registers_t is array (0 to 2) of std_logic;

  signal valid_a_delay_reg,   valid_b_delay_reg : delayers_registers_t;
  signal valid_tag                              : std_logic;

  signal final_block_delay_reg : delayers_registers_t;

  signal swap_reg : std_logic;

  component h_init is
    port (
      h     : in    std_logic_vector(127 downto 0);
      start : in    std_logic;
      clk   : in    std_logic;
      rst   : in    std_logic;
      valid : out   std_logic;
      h_out : out   std_logic_vector(127 downto 0)
    );
  end component h_init;

  signal valid_s   : std_logic;
  signal h_out_s   : std_logic_vector(127 downto 0);
  signal h_out_s_b : std_logic_vector(127 downto 0);

  component multh_32way is
    port (
      v_state_in  : in    std_logic_vector(127 downto 0);
      z_acc_in    : in    std_logic_vector(127 downto 0);
      h_i         : in    std_logic_vector(31 downto 0);
      v_state_out : out   std_logic_vector(127 downto 0);
      z_acc_out   : out   std_logic_vector(127 downto 0)
    );
  end component multh_32way;

  type multh_reg_t is array (0 to 2) of std_logic_vector(127 downto 0);

  signal multh_v_state_reg_a, multh_v_state_reg_b : multh_reg_t;
  signal multh_z_acc_reg_a,   multh_z_acc_reg_b   : multh_reg_t;

  type multh_s_t is array (0 to 7) of std_logic_vector(127 downto 0);

  signal multh_v_state_s_a,   multh_v_state_s_b : multh_s_t;
  signal multh_z_acc_s_a,     multh_z_acc_s_b   : multh_s_t;

  signal multh_initial_z_acc : std_logic_vector(127 downto 0) := x"00000000000000000000000000000000";

  component h_power_bank is
    generic (
      n : natural := 3
    );
    port (
      h_4_in  : in    std_logic_vector(31 downto 0);
      load    : in    std_logic;
      clk     : in    std_logic;
      counter : in    std_logic_vector(clog2(N) - 1 downto 0);
      output  : out   std_logic_vector(31 downto 0)
    );
  end component h_power_bank;

  signal enable_hpow_a : std_logic;
  signal enable_hpow_b : std_logic;

  type hpow_col_t is array (0 to 3) of std_logic_vector(31 downto 0);

  signal hpow_col_a,          hpow_col_b : hpow_col_t;

  signal tag_reg : std_logic_vector(127 downto 0);

  type hpow_counter_t is array (0 to 2) of std_logic_vector(1 downto 0);

  signal counter_delay_reg : hpow_counter_t;

  type hpow_counter_s_t is array (0 to 3) of std_logic_vector(1 downto 0);

  signal counter_s : hpow_counter_s_t;

begin

  valid_a_s <= valid_a_reg when (counter = "11" or final_block = '1') else
               valid_a;
  valid_b_s <= valid_b_reg when (counter = "11" or final_block = '1') else
               valid_b;

  enable_hpow_a <= load_a and valid_s;
  enable_hpow_b <= (load_b and valid_s) or start;

  counter_s(0) <= counter;
  counter_s(1) <= counter_delay_reg(0) when (load_a = '0' and load_b = '0') else
                  counter;
  counter_s(2) <= counter_delay_reg(1) when (load_a = '0' and load_b = '0') else
                  counter;
  counter_s(3) <= counter_delay_reg(2) when (load_a = '0' and load_b = '0') else
                  counter;

  multh_v_state_s_a(0) <= multh_initial_z_acc when valid_a_s = '0' else
                          stock_a_reg when (counter = "11" or final_block = '1') and swap_reg = '1' else
                          stock_a_reg xor prev_ad when (counter = "11" or final_block = '1') and swap_reg = '0' else
                          ci_a;
  multh_v_state_s_a(2) <= multh_v_state_reg_a(0);
  multh_v_state_s_a(4) <= multh_v_state_reg_a(1);
  multh_v_state_s_a(6) <= multh_v_state_reg_a(2);

  multh_v_state_s_b(0) <= multh_initial_z_acc when valid_b_s = '0' else
                          stock_b_reg when (counter = "11" or final_block = '1') and swap_reg = '0' else
                          stock_b_reg xor prev_ad when (counter = "11" or final_block = '1') and swap_reg = '1' else
                          ci_b;
  multh_v_state_s_b(2) <= multh_v_state_reg_b(0);
  multh_v_state_s_b(4) <= multh_v_state_reg_b(1);
  multh_v_state_s_b(6) <= multh_v_state_reg_b(2);

  multh_z_acc_s_a(0) <= multh_initial_z_acc;
  multh_z_acc_s_a(2) <= multh_z_acc_reg_a(0);
  multh_z_acc_s_a(4) <= multh_z_acc_reg_a(1);
  multh_z_acc_s_a(6) <= multh_z_acc_reg_a(2);

  multh_z_acc_s_b(0) <= multh_initial_z_acc;
  multh_z_acc_s_b(2) <= multh_z_acc_reg_b(0);
  multh_z_acc_s_b(4) <= multh_z_acc_reg_b(1);
  multh_z_acc_s_b(6) <= multh_z_acc_reg_b(2);

  h_inititialiser : component h_init
    port map (
      h     => h,
      start => start,
      clk   => clk,
      rst   => rst,
      valid => valid_s,
      h_out => h_out_s
    );

  h_out_s_b <= h when start = '1' else
               h_out_s;

  module_generation : for i in 0 to 3 generate
  begin

    multh_a : component multh_32way
      port map (
        v_state_in  => multh_v_state_s_a(2 * i),
        z_acc_in    => multh_z_acc_s_a(2 * i),
        h_i         => hpow_col_a(i),
        v_state_out => multh_v_state_s_a(2 * i + 1),
        z_acc_out   => multh_z_acc_s_a(2 * i + 1)
      );

    multh_b : component multh_32way
      port map (
        v_state_in  => multh_v_state_s_b(2 * i),
        z_acc_in    => multh_z_acc_s_b(2 * i),
        h_i         => hpow_col_b(i),
        v_state_out => multh_v_state_s_b(2 * i + 1),
        z_acc_out   => multh_z_acc_s_b(2 * i + 1)
      );

    powh_a : component h_power_bank
      port map (
        h_4_in  => h_out_s(32 * (i + 1) - 1 downto 32 * i),
        load    => enable_hpow_a,
        clk     => clk,
        counter => counter_s(i),
        output  => hpow_col_a(i)
      );

    powh_b : component h_power_bank
      port map (
        h_4_in  => h_out_s_b(32 * (i + 1) - 1 downto 32 * i),
        load    => enable_hpow_b,
        clk     => clk,
        counter => counter_s(i),
        output  => hpow_col_b(i)
      );

  end generate module_generation;

  valid_tag <= valid_a_delay_reg(2) or valid_b_delay_reg(2);

  process (clk, rst) is
  begin

    if (rst = '0') then
      stock_a_reg <= (others => '0');
      stock_b_reg <= (others => '0');
      tag_reg     <= (others => '0');
      valid_a_reg <= '0';
      valid_b_reg <= '0';
      swap_reg    <= '0';

      for i in 0 to 2 loop

        multh_v_state_reg_a(i)   <= (others => '0');
        multh_v_state_reg_b(i)   <= (others => '0');
        multh_z_acc_reg_a(i)     <= (others => '0');
        multh_z_acc_reg_b(i)     <= (others => '0');
        valid_a_delay_reg(i)     <= '0';
        valid_b_delay_reg(i)     <= '0';
        final_block_delay_reg(i) <= '0';
        counter_delay_reg(i)     <= (others => '0');

      end loop;

    elsif rising_edge(clk) then
      counter_delay_reg(0) <= counter;
      counter_delay_reg(1) <= counter_delay_reg(0);
      counter_delay_reg(2) <= counter_delay_reg(1);

      valid_a_delay_reg(0) <= valid_a_s;
      valid_a_delay_reg(1) <= valid_a_delay_reg(0);
      valid_a_delay_reg(2) <= valid_a_delay_reg(1);

      valid_b_delay_reg(0) <= valid_b_s;
      valid_b_delay_reg(1) <= valid_b_delay_reg(0);
      valid_b_delay_reg(2) <= valid_b_delay_reg(1);

      final_block_delay_reg(0) <= final_block;
      final_block_delay_reg(1) <= final_block_delay_reg(0);
      final_block_delay_reg(2) <= final_block_delay_reg(1);

      swap_reg <= swap;

      if (counter = "11" or final_block = '1') then
        valid_a_reg <= valid_a;
        valid_b_reg <= valid_b;
      else
        valid_a_reg <= valid_a_reg;
        valid_b_reg <= valid_b_reg;
      end if;

      if (counter = "11") then
        stock_a_reg <= ci_a;
        stock_b_reg <= ci_b;
      else
        stock_a_reg <= stock_a_reg;
        stock_b_reg <= stock_b_reg;
      end if;

      for i in 0 to 2 loop

        multh_v_state_reg_a(i) <= multh_v_state_s_a(2 * i + 1);
        multh_v_state_reg_b(i) <= multh_v_state_s_b(2 * i + 1);
        multh_z_acc_reg_a(i)   <= multh_z_acc_s_a(2 * i + 1);
        multh_z_acc_reg_b(i)   <= multh_z_acc_s_b(2 * i + 1);

      end loop;

      if (valid_tag = '1') then
        if (counter_delay_reg(2) = "11" or final_block_delay_reg(2) = '1') then
          tag_reg <= (others => '0');
        else
          tag_reg <= multh_z_acc_s_a(7) xor multh_z_acc_s_b(7) xor tag_reg;
        end if;
      else
        tag_reg <= tag_reg;
      end if;
    end if;

  end process;

  new_ad   <= multh_z_acc_s_a(7) xor multh_z_acc_s_b(7) xor tag_reg;
  valid_ad <= '1' when (counter_delay_reg(2) = "11" and valid_tag = '1') or final_block_delay_reg(2) = '1' else
              '0';

end architecture behavior;
