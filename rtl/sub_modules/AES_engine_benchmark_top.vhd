library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- Testbench for the AES engine
--
-- Fully pipelined AES engine, performing the 14 rounds of AES 256
--
-- Initiation Interval = 1 cycle
-- Latency : 14 cycles
-- ============================================================================

entity aes_engine_benchmark_top is
  port (
    clk  : in    std_logic;
    rst  : in    std_logic;
    void : out   std_logic_vector(127 downto 0)
  );
end entity aes_engine_benchmark_top;

architecture behavior of aes_engine_benchmark_top is

  component aes_engine is
    port (
      valid_in      : in    std_logic;
      plaintext     : in    std_logic_vector(127 downto 0);
      key_scheduled : in    std_logic_vector(1919 downto 0);
      clk           : in    std_logic;
      rst           : in    std_logic;
      ciphertext    : out   std_logic_vector(127 downto 0);
      valid_out     : out   std_logic
    );
  end component aes_engine;

  signal key_scheduled_s : std_logic_vector(1919 downto 0) := x"0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF";
  signal plaintext_s     : std_logic_vector(127 downto 0)  := x"0123456789ABCDEF0123456789ABCDEF";
  signal ciphertext_s    : std_logic_vector(127 downto 0);
  signal valid_out_s     : std_logic;

begin

  aes : component aes_engine
    port map (
      valid_in      => '1',
      plaintext     => plaintext_s,
      key_scheduled => key_scheduled_s,
      clk           => clk,
      rst           => rst,
      ciphertext    => ciphertext_s,
      valid_out     => valid_out_s
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      key_scheduled_s <= x"0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF";
      plaintext_s     <= x"0123456789ABCDEF0123456789ABCDEF";
    elsif rising_edge(clk) then
      plaintext_s(126 DOWNTO 0)      <= plaintext_s(127 downto 1);
      key_scheduled_s(1918 DOWNTO 0) <= key_scheduled_s(1919 downto 1);
      plaintext_s(127)               <= plaintext_s(0);
      key_scheduled_s(1919)          <= key_scheduled_s(0);
    end if;

  end process;

  void <= ciphertext_s;

end architecture behavior;
