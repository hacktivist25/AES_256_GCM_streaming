library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.utils_pkg.all;

-- ============================================================================
-- receives H (AES(0)) and calculates the 7 others powers of H (up to H power 8)
-- needed to perform G_HASH algorithm (used to calculate authentification tag)

-- Latency : 28 cycles : 4 cycles per powers of H (Hpower 2 to H power 8)
-- ============================================================================

entity h_init is
  port (
    h     : in    std_logic_vector(127 downto 0); -- H for the first one
    start : in    std_logic;
    clk   : in    std_logic;
    rst   : in    std_logic;
    valid : out   std_logic;
    h_out : out   std_logic_vector(127 downto 0)
  );
end entity h_init;

architecture behavior of h_init is

  component multh_32way is
    port (
      v_state_in  : in    std_logic_vector(127 downto 0);
      z_acc_in    : in    std_logic_vector(127 downto 0);
      h_i         : in    std_logic_vector(31 downto 0);
      v_state_out : out   std_logic_vector(127 downto 0);
      z_acc_out   : out   std_logic_vector(127 downto 0)
    );
  end component multh_32way;

  signal v_state_in_s  : std_logic_vector(127 downto 0);
  signal z_acc_in_s    : std_logic_vector(127 downto 0);
  signal h_i_s         : std_logic_vector(31 downto 0);
  signal v_state_out_s : std_logic_vector(127 downto 0);
  signal z_acc_out_s   : std_logic_vector(127 downto 0);

  component counter is
    generic (
      limit : natural := 32
    );
    port (
      start : in    std_logic;
      clk   : in    std_logic;
      rst   : in    std_logic;
      count : out   std_logic_vector(clog2(LIMIT) - 1 downto 0);
      valid : out   std_logic
    );
  end component counter;

  constant limit_s : natural := 3;
  signal   count_s : std_logic_vector(clog2(limit_s) - 1 downto 0);
  signal   valid_s : std_logic;

  signal h_reg : std_logic_vector(127 downto 0);

begin

  init_h_counter : component counter
    generic map (
      limit => limit_s
    )
    port map (
      start => start,
      clk   => clk,
      rst   => rst,
      count => count_s,
      valid => valid_s
    );

  init_h_multh : component multh_32way
    port map (
      v_state_in  => v_state_in_s,
      z_acc_in    => z_acc_in_s,
      h_i         => h_i_s,
      v_state_out => v_state_out_s,
      z_acc_out   => z_acc_out_s
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      v_state_in_s <= (others => '0');
      z_acc_in_s   <= (others => '0');
      h_reg        <= (others => '0');
    elsif rising_edge(clk) then
      if (start = '1') then
        h_reg        <= h;
        v_state_in_s <= h;
        z_acc_in_s   <= (others => '0');
      else
        h_reg <= h_reg;

        z_acc_in_s <= z_acc_out_s;
        if (valid_s = '1') then
          v_state_in_s <= z_acc_out_s;
          z_acc_in_s   <= (others => '0');
        else
          v_state_in_s <= v_state_out_s;
          z_acc_in_s   <= z_acc_out_s;
        end if;
      end if;
    end if;

  end process;

  -- output of the mulH block calculating H_power_i
  h_out <= z_acc_out_s;

  h_i_s <= h_reg(31 downto 0) when count_s = "00" else
           h_reg(63 downto 32) when count_s = "01" else
           h_reg(95 downto 64) when count_s = "10" else
           h_reg(127 downto 96) when count_s = "11";

  valid <= valid_s;

end architecture behavior;
