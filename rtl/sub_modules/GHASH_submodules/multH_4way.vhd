library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity multh_4way is
  port (
    deformed_contribution_input  : in    std_logic_vector(127 downto 0);
    current_sum_input            : in    std_logic_vector(127 downto 0);
    h_i                          : in    std_logic_vector(3 downto 0);
    deformed_contribution_output : out   std_logic_vector(127 downto 0);
    current_sum_output           : out   std_logic_vector(127 downto 0)
  );
end entity multh_4way;

architecture behavior of multh_4way is

  component xtime_128 is
    port (
      in_1  : in    std_logic_vector(127 downto 0);
      out_1 : out   std_logic_vector(127 downto 0)
    );
  end component xtime_128;

  type deformed_contribution_t is array (0 to 4) of std_logic_vector(127 downto 0);

  signal deformed_contribution : deformed_contribution_t;

  type current_sum_t is array (0 to 3) of std_logic_vector(127 downto 0);

  signal current_sum : current_sum_t;

begin

  deformed_contribution(0) <= deformed_contribution_input;

  deformed_contribution_output <= deformed_contribution(4);
  current_sum_output           <= current_sum(3);

  current_sum(0) <= deformed_contribution(0) xor current_sum_input when h_i(0) = '1' else
                    current_sum_input;
  current_sum(1) <= deformed_contribution(1) xor current_sum(0) when h_i(1) = '1' else
                    current_sum(0);
  current_sum(2) <= deformed_contribution(2) xor current_sum(1) when h_i(2) = '1' else
                    current_sum(1);
  current_sum(3) <= deformed_contribution(3) xor current_sum(2) when h_i(3) = '1' else
                    current_sum(2);

  gen_xtimers : for i in 0 to 3 generate
  begin

    xtimers : component xtime_128
      port map (
        in_1  => deformed_contribution(i),
        out_1 => deformed_contribution(i + 1)
      );

  end generate gen_xtimers;

end architecture behavior;
