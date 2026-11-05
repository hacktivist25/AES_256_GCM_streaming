library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- 8 steps of a 128 bits multiplication in GF(2 power 128)
-- multiplication of h_i with v_state_in

-- requires 16 of this block (in serial) to perform a full 128 bits multiplication

-- old signals name, but replacing thoses isn't necessary, see multH32
-- ============================================================================

entity multh_8way is
  port (
    deformed_contribution_input  : in    std_logic_vector(127 downto 0);
    current_sum_input            : in    std_logic_vector(127 downto 0);
    h_i                          : in    std_logic_vector(7 downto 0);
    deformed_contribution_output : out   std_logic_vector(127 downto 0);
    current_sum_output           : out   std_logic_vector(127 downto 0)
  );
end entity multh_8way;

architecture behavior of multh_8way is

  component xtime_128 is
    port (
      in_1  : in    std_logic_vector(127 downto 0);
      out_1 : out   std_logic_vector(127 downto 0)
    );
  end component xtime_128;

  type deformed_contribution_t is array (0 to 8) of std_logic_vector(127 downto 0);

  signal deformed_contribution : deformed_contribution_t;

  type current_sum_t is array (0 to 7) of std_logic_vector(127 downto 0);

  signal current_sum : current_sum_t;

begin

  deformed_contribution(0) <= deformed_contribution_input;

  deformed_contribution_output <= deformed_contribution(8);
  current_sum_output           <= current_sum(7);

  current_sum(0) <= deformed_contribution(0) xor current_sum_input when h_i(0) = '1' else
                    current_sum_input;

  gen_current_cum : for i in 1 to 7 generate
    current_sum(i) <= deformed_contribution(i) xor current_sum(i - 1) when h_i(i) = '1' else
                      current_sum(i - 1);
  end generate gen_current_cum;

  gen_xtimers : for i in 0 to 7 generate
  begin

    xtimers : component xtime_128
      port map (
        in_1  => deformed_contribution(i),
        out_1 => deformed_contribution(i + 1)
      );

  end generate gen_xtimers;

end architecture behavior;
