library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- takes one 32-bits "column" of an AES state, and returns a byte-wise rotation
-- of this column
-- ============================================================================

entity rotword is
  port (
    column        : in    std_logic_vector(31 downto 0);
    output_column : out   std_logic_vector(31 downto 0)
  );
end entity rotword;

architecture behavior of rotword is

begin

  output_column (31 DOWNTO 24) <= column(23 downto 16);
  output_column (23 DOWNTO 16) <= column(15 downto 8);
  output_column (15 DOWNTO 8)  <= column(7 downto 0);
  output_column (7 DOWNTO 0)   <= column(31 downto 24);

end architecture behavior;
