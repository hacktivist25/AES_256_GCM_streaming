library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- benchmark for implementation

-- testing the multH32
-- 32 steps of a 128 bits multiplication in GF(2 power 128)
-- multiplication of h_i with v_state_in

-- requires 4 of this block (in serial) to perform a full 128 bits multiplication
-- ============================================================================

entity multh_32way_benchmark_top is
  port (
    clk  : in    std_logic;
    rst  : in    std_logic;
    void : out   std_logic
  );
end entity multh_32way_benchmark_top;

architecture behavior of multh_32way_benchmark_top is

  component multh_32way is
    port (
      v_state_in  : in    std_logic_vector(127 downto 0);
      z_acc_in    : in    std_logic_vector(127 downto 0);
      h_i         : in    std_logic_vector(31 downto 0);
      v_state_out : out   std_logic_vector(127 downto 0);
      z_acc_out   : out   std_logic_vector(127 downto 0)
    );
  end component multh_32way;

  signal v_state_input_bench : std_logic_vector(127 downto 0) := x"11223344112233441122334411223344";
  signal z_acc_input_bench   : std_logic_vector(127 downto 0) := x"11223344112233441122334411223344";

  signal v_state_input_reg   : std_logic_vector(127 downto 0);
  signal z_acc_input_reg     : std_logic_vector(127 downto 0);
  signal h_i_bench           : std_logic_vector(31 downto 0) := x"55555555";
  signal v_state_output_next : std_logic_vector(127 downto 0);
  signal z_acc_output_next   : std_logic_vector(127 downto 0);

  attribute keep : string;
  attribute dont_touch : string;

  attribute keep of v_state_input_reg : signal is "TRUE";
  attribute keep of z_acc_input_reg   : signal is "TRUE";

  attribute dont_touch of benchmark : label is "TRUE";

begin

  benchmark : component multh_32way
    port map (
      deformed_contribution_input  => v_state_input_reg,
      current_sum_input            => z_acc_input_reg,
      h_i                          => h_i_bench,
      deformed_contribution_output => v_state_output_next,
      current_sum_output           => z_acc_output_next
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      v_state_input_reg <= v_state_input_bench;
      z_acc_input_reg   <= z_acc_input_bench;
    elsif rising_edge(clk) then
      v_state_input_reg(127 DOWNTO 1) <= v_state_output_next(126 downto 0);
      v_state_input_reg(0)            <= v_state_output_next(127);
      z_acc_input_reg(127 DOWNTO 1)   <= z_acc_output_next(126 downto 0);
      z_acc_input_reg(0)              <= z_acc_output_next(127);
    end if;

  end process;

  void <= z_acc_output_next(3) xor v_state_output_next(89);

end architecture behavior;
