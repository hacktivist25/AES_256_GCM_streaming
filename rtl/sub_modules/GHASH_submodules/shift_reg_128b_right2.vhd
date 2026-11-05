library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- takes a 128 bits input, and delivers the 2 LSbits per clock cycles by shifting it
-- ============================================================================

entity shift_reg_128b_right2 is
  port (
    input  : in    std_logic_vector(127 downto 0);
    load   : in    std_logic;
    clk    : in    std_logic;
    rst    : in    std_logic;
    output : out   std_logic_vector(1 downto 0)
  );
end entity shift_reg_128b_right2;

architecture behavior of shift_reg_128b_right2 is

  signal shift_register : std_logic_vector(127 downto 0);

begin

  output <= shift_register(1 downto 0) when rst = '1' else
            "00";

  process (clk, rst) is
  begin

    if (rst = '0') then
      shift_register <= (others => '0');
    elsif rising_edge(clk) then
      if (load = '1') then
        shift_register <= input;
      else
        shift_register(125 DOWNTO 0) <= shift_register(127 downto 2);
      end if;
    end if;

  end process;

end architecture behavior;
