library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity multh_8way_benchmark_top is
  port (
    clk  : in    std_logic;
    rst  : in    std_logic;
    void : out   std_logic
  );
end entity multh_8way_benchmark_top;

architecture behavior of multh_8way_benchmark_top is

  component multh_8way is
    port (
      deformed_contribution_input  : in    std_logic_vector(127 downto 0);
      current_sum_input            : in    std_logic_vector(127 downto 0);
      h_i                          : in    std_logic_vector(7 downto 0);
      deformed_contribution_output : out   std_logic_vector(127 downto 0);
      current_sum_output           : out   std_logic_vector(127 downto 0)
    );
  end component multh_8way;

  signal deformed_contribution_input_bench : std_logic_vector(127 downto 0) := x"11223344112233441122334411223344";
  signal current_sum_input_bench           : std_logic_vector(127 downto 0) := x"11223344112233441122334411223344";

  signal deformed_contribution_input_reg   : std_logic_vector(127 downto 0);
  signal current_sum_input_reg             : std_logic_vector(127 downto 0);
  signal h_i_bench                         : std_logic_vector(7 downto 0) := x"55";
  signal deformed_contribution_output_next : std_logic_vector(127 downto 0);
  signal current_sum_output_next           : std_logic_vector(127 downto 0);

  attribute keep : string;
  attribute dont_touch : string;

  attribute keep of deformed_contribution_input_reg : signal is "TRUE";
  attribute keep of current_sum_input_reg           : signal is "TRUE";

  attribute dont_touch of benchmark : label is "TRUE";

begin

  benchmark : component multh_8way
    port map (
      deformed_contribution_input  => deformed_contribution_input_reg,
      current_sum_input            => current_sum_input_reg,
      h_i                          => h_i_bench,
      deformed_contribution_output => deformed_contribution_output_next,
      current_sum_output           => current_sum_output_next
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      deformed_contribution_input_reg <= deformed_contribution_input_bench;
      current_sum_input_reg           <= current_sum_input_bench;
    elsif rising_edge(clk) then
      deformed_contribution_input_reg(127 DOWNTO 1) <= deformed_contribution_output_next(126 downto 0);
      deformed_contribution_input_reg(0)            <= deformed_contribution_output_next(127);
      current_sum_input_reg(127 DOWNTO 1)           <= current_sum_output_next(126 downto 0);
      current_sum_input_reg(0)                      <= current_sum_output_next(127);
    end if;

  end process;

  void <= current_sum_output_next(3) xor deformed_contribution_output_next(89);

end architecture behavior;
