library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.utils_pkg.all;

entity h_power_bank is
  generic (
    n : natural := 3
  );
  port (
    h_4_in  : in    std_logic_vector(31 downto 0);
    load    : in    std_logic;
    clk     : in    std_logic;
    counter : in    std_logic_vector(clog2(n) - 1 downto 0);
    output  : out   std_logic_vector(31 downto 0)
  );
end entity h_power_bank;

architecture behavior of h_power_bank is

  type h4_t is array (0 to N) of std_logic_vector(31 downto 0);

  signal h4_power : h4_t;

begin

  process (clk) is
  begin

    if rising_edge(clk) then
      if (load = '1') then
        h4_power(to_integer(unsigned(counter))) <= h_4_in;
      end if;
    end if;

  end process;

  output <= h4_power(to_integer(unsigned(counter)));

end architecture behavior;
