library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- takes a 256-bits key, and use it to create the 13 other "round_keys" (128 bits each)

-- produces one round_key each cycle
-- Latency : 13 clocks
-- ============================================================================

entity keyscheduler is
  port (
    key       : in    std_logic_vector(255 downto 0);
    clk       : in    std_logic;
    rst       : in    std_logic;
    start     : in    std_logic;
    done      : out   std_logic;
    round_key : out   std_logic_vector(127 downto 0)
  );
end entity keyscheduler;

architecture behavior of keyscheduler is

  component rotword is
    port (
      column        : in    std_logic_vector(31 downto 0);
      output_column : out   std_logic_vector(31 downto 0)
    );
  end component rotword;

  component subword is
    port (
      column        : in    std_logic_vector(31 downto 0);
      clk           : in    std_logic;
      rst           : in    std_logic;
      output_column : out   std_logic_vector(31 downto 0)
    );
  end component subword;

  component xor32 is
    port (
      a       : in    std_logic_vector(31 downto 0);
      b       : in    std_logic_vector(31 downto 0);
      a_xor_b : out   std_logic_vector(31 downto 0)
    );
  end component xor32;

  signal counter : natural range 0 to 15;
  signal even_s  : std_logic;

  signal rcon   : std_logic_vector(55 downto 0) := x"01020408102040";
  signal rcon_i : std_logic_vector(7 downto 0);

  signal operating : std_logic;

  -- previous Wi stored

  type wi_prev_t is array (0 to 3) of std_logic_vector(31 downto 0);

  signal w_i : wi_prev_t;

  -- calculated W_i

  type wi_calc_t is array (0 to 3) of std_logic_vector(31 downto 0);

  signal w_i_calc   : wi_calc_t;
  signal w_i_temp_0 : std_logic_vector(31 downto 0);
  signal w_i_temp_1 : std_logic_vector(31 downto 0);
  signal w_i_temp_2 : std_logic_vector(31 downto 0);
  signal w_i_temp_3 : std_logic_vector(31 downto 0);
  signal w_i_temp_4 : std_logic_vector(31 downto 0);

begin

  -- Rcon_i distribution
  rcon_i <= rcon (55 downto 48) when (counter = 0 or counter = 1 or counter = 2 or counter = 3) else
            rcon (47 downto 40) when (counter = 4 or counter = 5) else
            rcon (39 downto 32) when (counter = 6 or counter = 7) else
            rcon (31 downto 24) when (counter = 8 or counter = 9) else
            rcon (23 downto 16) when (counter = 10 or counter = 11) else
            rcon (15 downto 8) when (counter = 12 or counter = 13) else
            rcon (7 downto 0);

  even_s     <= TO_UNSIGNED(counter, 4)(0);
  w_i_temp_1 <= w_i_temp_0 when even_s = '0' else
                w_i(3);
  w_i_temp_4 <= (w_i_temp_3(31 downto 24) xor rcon_i) & w_i_temp_3(23 downto 0);

  rotword_0 : component rotword
    port map (
      column        => w_i(3),
      output_column => w_i_temp_0
    );

  subword_0 : component subword
    port map (
      column        => w_i_temp_1,
      clk           => clk,
      rst           => rst,
      output_column => w_i_temp_2
    );

  xor_0 : component xor32
    port map (
      a       => w_i(0),
      b       => w_i_temp_2,
      a_xor_b => w_i_temp_3
    );

  xor_1 : component xor32
    port map (
      a       => w_i_calc(0),
      b       => w_i(1),
      a_xor_b => w_i_calc(1)
    );

  xor_2 : component xor32
    port map (
      a       => w_i_calc(1),
      b       => w_i(2),
      a_xor_b => w_i_calc(2)
    );

  xor_3 : component xor32
    port map (
      a       => w_i_calc(2),
      b       => w_i(3),
      a_xor_b => w_i_calc(3)
    );

  w_i_calc(0) <= w_i_temp_4 when even_s = '0' else
                 w_i_temp_3;

  process (clk, rst) is
  begin

    if (rst = '0') then
      w_i(0)    <= (others => '0');
      w_i(1)    <= (others => '0');
      w_i(2)    <= (others => '0');
      w_i(3)    <= (others => '0');
      counter   <= 0;
      operating <= '0';
      done      <= '0';
    elsif RISING_EDGE(clk) then
      -- counter
      if (operating = '1') then
        if (counter <= 15) then
          counter <= counter + 1;
        else
          counter <= 0;
        end if;
      end if;
      done <= '0';

      if (counter = 0) then
        w_i(0) <= key(127 downto 96);
        w_i(1) <= key(95 downto 64);
        w_i(2) <= key(63 downto 32);
        w_i(3) <= key(31 downto 0);
      else
        w_i(0) <= w_i_calc(0);
        w_i(1) <= w_i_calc(1);
        w_i(2) <= w_i_calc(2);
        w_i(3) <= w_i_calc(3);
      end if;

      if (start = '1') then
        w_i(0)    <= key(255 downto 224);
        w_i(1)    <= key(223 downto 192);
        w_i(2)    <= key(191 downto 160);
        w_i(3)    <= key(159 downto 128);
        operating <= '1';
      end if;

      if (counter = 15) then
        operating <= '0';
        done      <= '1';
      end if;
    end if;

  end process;

  round_key <= w_i(0) & w_i(1) & w_i(2) & w_i(3);

end architecture behavior;
