library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- shift the "rows" of an 128-bits input state
-- ============================================================================

entity shiftrows is
  port (
    state        : in    std_logic_vector(127 downto 0);
    output_state : out   std_logic_vector(127 downto 0)
  );
end entity shiftrows;

architecture behavior of shiftrows is

begin

  output_state( 7 DOWNTO 0 )     <= state( 7 downto 0);     -- b(0, 0) = a( 0,  0)
  output_state( 39 DOWNTO 32 )   <= state( 39 downto 32);
  output_state( 71 DOWNTO 64 )   <= state( 71 downto 64);
  output_state( 103 DOWNTO 96 )  <= state( 103 downto 96);
  output_state( 15 DOWNTO 8 )    <= state( 47 downto 40);   -- b(1, 0) = a( 1,  1)
  output_state( 47 DOWNTO 40 )   <= state( 79 downto 72);
  output_state( 79 DOWNTO 72 )   <= state( 111 downto 104);
  output_state( 111 DOWNTO 104 ) <= state( 15 downto 8);
  output_state( 23 DOWNTO 16 )   <= state( 87 downto 80);   -- b(2, 0) = a( 2,  2)
  output_state( 55 DOWNTO 48 )   <= state( 119 downto 112);
  output_state( 87 DOWNTO 80 )   <= state( 23 downto 16);
  output_state( 119 DOWNTO 112 ) <= state( 55 downto 48);
  output_state( 31 DOWNTO 24 )   <= state( 127 downto 120); -- b(3, 0) = a( 3,  3)
  output_state( 63 DOWNTO 56 )   <= state( 31 downto 24);
  output_state( 95 DOWNTO 88 )   <= state( 63 downto 56);
  output_state( 127 DOWNTO 120 ) <= state( 95 downto 88);

end architecture behavior;
