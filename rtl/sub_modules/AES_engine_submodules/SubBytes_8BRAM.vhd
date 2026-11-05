library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- uses 8 BRAMS (each with 2 8bits output)
-- takes the state in input (128 bits) and returns sbox(state)

-- Latency : 1 cycle
-- Initiation Interval = 1 cycle
-- ============================================================================

entity subbytes_8bram is
  port (
    state        : in    std_logic_vector(127 downto 0);
    clk          : in    std_logic;
    rst          : in    std_logic;
    output_state : out   std_logic_vector(127 downto 0)
  );
end entity subbytes_8bram;

architecture behavior of subbytes_8bram is

  component bram_18_true_dual_port_no_inference is
    port (
      addra : in    std_logic_vector(10 downto 0);
      addrb : in    std_logic_vector(10 downto 0);
      clk   : in    std_logic;
      doa   : out   std_logic_vector(7 downto 0);
      dob   : out   std_logic_vector(7 downto 0)
    );
  end component bram_18_true_dual_port_no_inference;

  type addr_array_t is array (0 to 7) of std_logic_vector(10 downto 0);

  signal addra, addrb : addr_array_t;

  type do_array_t is array (0 to 7) of std_logic_vector(7 downto 0);

  signal doa,   dob : do_array_t;

  signal shift_reg_output : unsigned (127 downto 0);

begin

  -- instanciate BRAMs

  gen_sbox_bram : for i in 0 to 7 generate
  begin

    bram_tdp_macro_inst : component bram_18_true_dual_port_no_inference
      port map (
        addra => addra(i),
        addrb => addrb(i),
        clk   => clk,
        doa   => doa(i),
        dob   => dob(i)
      );

  end generate gen_sbox_bram;

  process (clk, rst) is

    variable shift_reg_output_var : unsigned(127 downto 0);

  begin

    if (rst = '0') then
      shift_reg_output <= (others => '0');
    elsif rising_edge(clk) then
      -- LSB to MSB
      addra(0)(7 DOWNTO 0) <= state( 15 downto 8);
      addrb(0)(7 DOWNTO 0) <= state( 7 downto 0);
      addra(1)(7 DOWNTO 0) <= state( 31 downto 24);
      addrb(1)(7 DOWNTO 0) <= state( 23 downto 16);
      addra(2)(7 DOWNTO 0) <= state( 47 downto 40);
      addrb(2)(7 DOWNTO 0) <= state( 39 downto 32);
      addra(3)(7 DOWNTO 0) <= state( 63 downto 56);
      addrb(3)(7 DOWNTO 0) <= state( 55 downto 48);
      addra(4)(7 DOWNTO 0) <= state( 79 downto 72);
      addrb(4)(7 DOWNTO 0) <= state( 71 downto 64);
      addra(5)(7 DOWNTO 0) <= state( 95 downto 88);
      addrb(5)(7 DOWNTO 0) <= state( 87 downto 80);
      addra(6)(7 DOWNTO 0) <= state( 111 downto 104);
      addrb(6)(7 DOWNTO 0) <= state( 103 downto 96);
      addra(7)(7 DOWNTO 0) <= state( 127 downto 120);
      addrb(7)(7 DOWNTO 0) <= state( 119 downto 112);
    end if;

  end process;

  addra(0) (10 DOWNTO 8) <= (others => '0');
  addrb(0) (10 DOWNTO 8) <= (others => '0');
  addra(1) (10 DOWNTO 8) <= (others => '0');
  addrb(1) (10 DOWNTO 8) <= (others => '0');
  addra(2) (10 DOWNTO 8) <= (others => '0');
  addrb(2) (10 DOWNTO 8) <= (others => '0');
  addra(3) (10 DOWNTO 8) <= (others => '0');
  addrb(3) (10 DOWNTO 8) <= (others => '0');
  addra(4) (10 DOWNTO 8) <= (others => '0');
  addrb(4) (10 DOWNTO 8) <= (others => '0');
  addra(5) (10 DOWNTO 8) <= (others => '0');
  addrb(5) (10 DOWNTO 8) <= (others => '0');
  addra(6) (10 DOWNTO 8) <= (others => '0');
  addrb(6) (10 DOWNTO 8) <= (others => '0');
  addra(7) (10 DOWNTO 8) <= (others => '0');
  addrb(7) (10 DOWNTO 8) <= (others => '0');

  output_state <= doa(7) & dob(7)
                  & doa(6) & dob(6)
                  & doa(5) & dob(5)
                  & doa(4) & dob(4)
                  & doa(3) & dob(3)
                  & doa(2) & dob(2)
                  & doa(1) & dob(1)
                  & doa(0) & dob(0);

end architecture behavior;
