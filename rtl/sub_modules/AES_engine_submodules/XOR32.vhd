library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity xor32 is
  port (
    a       : in    std_logic_vector(31 downto 0);
    b       : in    std_logic_vector(31 downto 0);
    a_xor_b : out   std_logic_vector(31 downto 0)
  );
end entity xor32;

architecture behavior of xor32 is

begin

  a_xor_b <= a xor b;

end architecture behavior;
