library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.utils_pkg.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)

entity counter is
  generic (
    limit : natural := 32
  );
  port (
    start : in    std_logic;
    clk   : in    std_logic;
    rst   : in    std_logic;
    count : out   std_logic_vector(clog2(limit) - 1 downto 0);
    valid : out   std_logic
  );
end entity counter;

architecture behavior of counter is

  signal count_s : natural range 0 to limit;

begin

  process (clk, rst) is
  begin

    if (rst = '0') then
      count_s <= 0;
    elsif rising_edge(clk) then
      if (start = '1') then
        count_s <= 0;
      else
        if (count_s < limit) then
          count_s <= count_s + 1;
        else
          count_s <= 0;
        end if;
      end if;
    end if;

  end process;

  valid <= '1' when count_s = 3 else
           '0';
  count <= std_logic_vector(to_unsigned(count_s, clog2(limit)));

end architecture behavior;
