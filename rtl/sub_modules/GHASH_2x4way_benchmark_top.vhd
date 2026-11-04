library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.utils_pkg.all;

entity ghash_2x4way_benchmark_top is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;
    start   : in    std_logic;
    load_a  : in    std_logic;
    load_b  : in    std_logic;
    swap    : in    std_logic;
    counter : in    std_logic_vector(1 downto 0);
    void    : out   std_logic_vector(127 downto 0)
  );
end entity ghash_2x4way_benchmark_top;

architecture behavior of ghash_2x4way_benchmark_top is

  component ghash_2x4way is
    port (
      ci_a        : in    std_logic_vector(127 downto 0);
      ci_b        : in    std_logic_vector(127 downto 0);
      h           : in    std_logic_vector(127 downto 0);
      prev_ad     : in    std_logic_vector(127 downto 0);
      clk         : in    std_logic;
      rst         : in    std_logic;
      start       : in    std_logic;
      load_a      : in    std_logic;
      load_b      : in    std_logic;
      valid_a     : in    std_logic;
      valid_b     : in    std_logic;
      swap        : in    std_logic;
      final_block : in    std_logic;
      counter     : in    std_logic_vector(1 downto 0);
      new_ad      : out   std_logic_vector(127 downto 0);
      valid_ad    : out   std_logic
    );
  end component ghash_2x4way;

  signal ci_a    : std_logic_vector(127 downto 0) := x"0123456789ABCDEF0123456789ABCDEF";
  signal ci_b    : std_logic_vector(127 downto 0) := x"0123456789ABCDEF0123456789ABCDEF";
  signal h       : std_logic_vector(127 downto 0) := x"0123456789ABCDEF0123456789ABCDEF";
  signal prev_ad : std_logic_vector(127 downto 0) := x"0123456789ABCDEF0123456789ABCDEF";
  signal new_ad  : std_logic_vector(127 downto 0);

begin

  ghash : component ghash_2x4way
    port map (
      ci_a        => ci_a,
      ci_b        => ci_b,
      h           => h,
      prev_ad     => prev_ad,
      clk         => clk,
      rst         => rst,
      start       => start,
      load_a      => load_a,
      load_b      => load_b,
      valid_a     => '1',
      valid_b     => '1',
      swap        => swap,
      final_block => '0',
      counter     => counter,
      new_ad      => new_ad
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      ci_a    <= x"0123456789ABCDEF0123456789ABCDEF";
      ci_b    <= x"0123456789ABCDEF0123456789ABCDEF";
      h       <= x"0123456789ABCDEF0123456789ABCDEF";
      prev_ad <= x"0123456789ABCDEF0123456789ABCDEF";
    elsif rising_edge(clk) then
      ci_a(126 DOWNTO 0)    <= ci_a(127 downto 1);
      ci_b(126 DOWNTO 0)    <= ci_b(127 downto 1);
      h(126 DOWNTO 0)       <= h(127 downto 1);
      prev_ad(126 DOWNTO 0) <= prev_ad(127 downto 1);

      ci_a(127)    <= ci_a(0);
      ci_b(127)    <= ci_b(0);
      h(127)       <= h(0);
      prev_ad(127) <= prev_ad(0);
    end if;

  end process;

  void <= new_ad;

end architecture behavior;
