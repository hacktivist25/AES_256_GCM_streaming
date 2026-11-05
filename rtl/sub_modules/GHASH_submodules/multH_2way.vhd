library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- 2 steps of a 128 bits multiplication in GF(2 power 128)
-- multiplication of h_i with v_state_in

-- requires 64 of this block (in serial) to perform a full 128 bits multiplication

-- old signals name, but replacing thoses isn't necessary, see multH32
-- ============================================================================

entity multh_2way is
  port (
    deformed_contribution_input  : in    std_logic_vector(127 downto 0); -- ititial H
    current_sum_input            : in    std_logic_vector(127 downto 0);
    h_i                          : in    std_logic_vector(1 downto 0);
    deformed_contribution_output : out   std_logic_vector(127 downto 0);
    current_sum_output_0         : out   std_logic_vector(127 downto 0);
    current_sum_output_1         : out   std_logic_vector(127 downto 0)
  );
end entity multh_2way;

architecture behavior of multh_2way is

  component xtime_128 is
    port (
      in_1  : in    std_logic_vector(127 downto 0);
      out_1 : out   std_logic_vector(127 downto 0)
    );
  end component xtime_128;

  type deformed_contribution_t is array (0 to 2) of std_logic_vector(127 downto 0);

  signal deformed_contribution : deformed_contribution_t;

  type current_sum_t is array (0 to 1) of std_logic_vector(127 downto 0);

  signal current_sum : current_sum_t;

begin

  deformed_contribution(0) <= deformed_contribution_input;

  deformed_contribution_output <= deformed_contribution(2);
  current_sum_output_0         <= current_sum(0);
  current_sum_output_1         <= current_sum(1);

  current_sum(0) <= deformed_contribution(0) xor current_sum_input when h_i(0) = '1' else
                    current_sum_input;
  current_sum(1) <= deformed_contribution(1) xor current_sum(0) when h_i(1) = '1' else
                    current_sum(0);

  gen_xtimers : for i in 0 to 1 generate
  begin

    xtimers : component xtime_128
      port map (
        in_1  => deformed_contribution(i),
        out_1 => deformed_contribution(i + 1)
      );

  end generate gen_xtimers;

end architecture behavior;
