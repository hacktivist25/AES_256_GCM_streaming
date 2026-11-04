library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)

entity subword is
  port (
    column        : in    std_logic_vector(31 downto 0);
    clk           : in    std_logic;
    rst           : in    std_logic;
    output_column : out   std_logic_vector(31 downto 0)
  );
end entity subword;

architecture behavior of subword is

  component bram_18_true_dual_port is
    port (
      addra : in    std_logic_vector(10 downto 0);
      addrb : in    std_logic_vector(10 downto 0);
      clk   : in    std_logic;
      rst   : in    std_logic;
      doa   : out   std_logic_vector(7 downto 0);
      dob   : out   std_logic_vector(7 downto 0)
    );
  end component bram_18_true_dual_port;

begin

  bram_1 : component bram_18_true_dual_port
    port map (
      addra => "000" & column(31 downto 24),
      addrb => "000" & column(23 downto 16),
      clk   => clk,
      rst   => rst,
      doa   => output_column(31 downto 24),
      dob   => output_column(23 downto 16)
    );

  bram_2 : component bram_18_true_dual_port
    port map (
      addra => "000" & column(15 downto 8),
      addrb => "000" & column(7 downto 0),
      clk   => clk,
      rst   => rst,
      doa   => output_column(15 downto 8),
      dob   => output_column(7 downto 0)
    );

end architecture behavior;
