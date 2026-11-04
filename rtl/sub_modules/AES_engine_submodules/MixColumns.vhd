library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)

entity mixcolumns is
  port (
    state_column        : in    std_logic_vector(31 downto 0);
    output_state_column : out   std_logic_vector(31 downto 0)
  );
end entity mixcolumns;

architecture behavior of mixcolumns is

  signal a0     : std_logic_vector(7 downto 0);
  signal a1     : std_logic_vector(7 downto 0);
  signal a2     : std_logic_vector(7 downto 0);
  signal a3     : std_logic_vector(7 downto 0);
  signal two_a0 : std_logic_vector(7 downto 0);
  signal two_a1 : std_logic_vector(7 downto 0);
  signal two_a2 : std_logic_vector(7 downto 0);
  signal two_a3 : std_logic_vector(7 downto 0);

  component xtime is
    port (
      in_1  : in    std_logic_vector(7 downto 0);
      out_1 : out   std_logic_vector(7 downto 0)
    );
  end component xtime;

begin

  a0 <= state_column(31 downto 24);
  a1 <= state_column(23 downto 16);
  a2 <= state_column(15 downto 8);
  a3 <= state_column(7 downto 0);

  xtime_0 : component xtime
    port map (
      in_1  => a0,
      out_1 => two_a0
    );

  xtime_1 : component xtime
    port map (
      in_1  => a1,
      out_1 => two_a1
    );

  xtime_2 : component xtime
    port map (
      in_1  => a2,
      out_1 => two_a2
    );

  xtime_3 : component xtime
    port map (
      in_1  => a3,
      out_1 => two_a3
    );

  -- A(0,j)
  output_state_column(31 DOWNTO 24) <= two_a0 xor two_a1 xor a1 xor a2 xor a3;
  -- A(1,j)
  output_state_column(23 DOWNTO 16) <= two_a1 xor two_a2 xor a2 xor a3 xor a0;
  -- A(2,j)
  output_state_column(15 DOWNTO 8) <= two_a2 xor two_a3 xor a3 xor a0 xor a1;
  -- A(3,j)
  output_state_column(7 DOWNTO 0) <= two_a3 xor two_a0 xor a0 xor a1 xor a2;

end architecture behavior;
