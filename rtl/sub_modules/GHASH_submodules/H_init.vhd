library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.utils_pkg.all;

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
      deformed_contribution_input  : in    std_logic_vector(127 downto 0);
      current_sum_input            : in    std_logic_vector(127 downto 0);
      h_i                          : in    std_logic_vector(31 downto 0);
      deformed_contribution_output : out   std_logic_vector(127 downto 0);
      current_sum_output           : out   std_logic_vector(127 downto 0)
    );
  end component multh_32way;

  signal deformed_contribution_input_s  : std_logic_vector(127 downto 0);
  signal current_sum_input_s            : std_logic_vector(127 downto 0);
  signal h_i_s                          : std_logic_vector(31 downto 0);
  signal deformed_contribution_output_s : std_logic_vector(127 downto 0);
  signal current_sum_output_s           : std_logic_vector(127 downto 0);

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
      deformed_contribution_input  => deformed_contribution_input_s,
      current_sum_input            => current_sum_input_s,
      h_i                          => h_i_s,
      deformed_contribution_output => deformed_contribution_output_s,
      current_sum_output           => current_sum_output_s
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      deformed_contribution_input_s <= (others => '0');
      current_sum_input_s           <= (others => '0');
      h_reg                         <= (others => '0');
    elsif rising_edge(clk) then
      if (start = '1') then
        h_reg                         <= h;
        deformed_contribution_input_s <= h;
        current_sum_input_s           <= (others => '0');
      else
        h_reg <= h_reg;

        current_sum_input_s <= current_sum_output_s;
        if (valid_s = '1') then
          deformed_contribution_input_s <= current_sum_output_s;
          current_sum_input_s           <= (others => '0');
        else
          deformed_contribution_input_s <= deformed_contribution_output_s;
          current_sum_input_s           <= current_sum_output_s;
        end if;
      end if;
    end if;

  end process;

  -- output of the mulH block calculating H_power_i
  h_out <= current_sum_output_s;

  h_i_s <= h_reg(31 downto 0) when count_s = "00" else
           h_reg(63 downto 32) when count_s = "01" else
           h_reg(95 downto 64) when count_s = "10" else
           h_reg(127 downto 96) when count_s = "11";

  valid <= valid_s;

end architecture behavior;
