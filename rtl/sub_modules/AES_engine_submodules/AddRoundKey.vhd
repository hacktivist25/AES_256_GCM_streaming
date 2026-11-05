library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- Add round key step in AES protocol :
-- round_key XOR state

-- input :
-- - key (128bits)
-- - state (128bits)
-- output :
-- - new state (128 bits)
-- ============================================================================

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
