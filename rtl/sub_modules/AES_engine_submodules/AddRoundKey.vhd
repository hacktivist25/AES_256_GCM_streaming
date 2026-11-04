library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity addroundkey is
  port (
    round_key    : in    std_logic_vector(127 downto 0);
    state        : in    std_logic_vector(127 downto 0);
    output_state : out   std_logic_vector(127 downto 0)
  );
end entity addroundkey;

architecture behavior of addroundkey is

begin

  output_state <= round_key xor state;

end architecture behavior;
