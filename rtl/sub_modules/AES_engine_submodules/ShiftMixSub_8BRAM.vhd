library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)

entity shiftmixsub_8bram is
  port (
    state        : in    std_logic_vector(127 downto 0);
    clk          : in    std_logic;
    rst          : in    std_logic;
    last_round   : in    std_logic;
    output_state : out   std_logic_vector(127 downto 0)
  );
end entity shiftmixsub_8bram;

architecture behavior of shiftmixsub_8bram is

  type addr_array_t is array (0 to 7) of std_logic_vector(9 downto 0);

  signal addra, addrb : addr_array_t;

  type do_array_t is array (0 to 7) of std_logic_vector(31 downto 0);

  signal doa,   dob : do_array_t;

  signal a0_0 : std_logic_vector(7 downto 0);
  signal a1_0 : std_logic_vector(7 downto 0);
  signal a2_0 : std_logic_vector(7 downto 0);
  signal a3_0 : std_logic_vector(7 downto 0);
  signal a0_1 : std_logic_vector(7 downto 0);
  signal a1_1 : std_logic_vector(7 downto 0);
  signal a2_1 : std_logic_vector(7 downto 0);
  signal a3_1 : std_logic_vector(7 downto 0);
  signal a0_2 : std_logic_vector(7 downto 0);
  signal a1_2 : std_logic_vector(7 downto 0);
  signal a2_2 : std_logic_vector(7 downto 0);
  signal a3_2 : std_logic_vector(7 downto 0);
  signal a0_3 : std_logic_vector(7 downto 0);
  signal a1_3 : std_logic_vector(7 downto 0);
  signal a2_3 : std_logic_vector(7 downto 0);
  signal a3_3 : std_logic_vector(7 downto 0);

  type temp_array_t is array (0 to 7) of std_logic_vector(31 downto 0);

  signal temp : temp_array_t;

  type column_array_t is array (0 to 3) of std_logic_vector(31 downto 0);

  signal final_column : column_array_t;

  component xor32 is
    port (
      a       : in    std_logic_vector(31 downto 0);
      b       : in    std_logic_vector(31 downto 0);
      a_xor_b : out   std_logic_vector(31 downto 0)
    );
  end component xor32;

  -- contains T-tables
  component bram_36_true_dual_port is
    port (
      addra : in    std_logic_vector(9 downto 0);
      addrb : in    std_logic_vector(9 downto 0);
      clk   : in    std_logic;
      rst   : in    std_logic;
      doa   : out   std_logic_vector(31 downto 0);
      dob   : out   std_logic_vector(31 downto 0)
    );
  end component bram_36_true_dual_port;

begin

  -- instanciate BRAMs

  gen_t_tables_bram : for i in 0 to 7 generate
  begin

    bram_tdp_macro_inst : component bram_36_true_dual_port
      port map (
        doa   => doa(i),
        dob   => dob(i),
        addra => addra(i),
        addrb => addrb(i),
        clk   => clk,
        rst   => rst
      );

  end generate gen_t_tables_bram;

  a0_0 <= state(127 downto 120);
  a1_0 <= state(119 downto 112);
  a2_0 <= state(111 downto 104);
  a3_0 <= state(103 downto 96);
  a0_1 <= state(95 downto 88);
  a1_1 <= state(87 downto 80);
  a2_1 <= state(79 downto 72);
  a3_1 <= state(71 downto 64);
  a0_2 <= state(63 downto 56);
  a1_2 <= state(55 downto 48);
  a2_2 <= state(47 downto 40);
  a3_2 <= state(39 downto 32);
  a0_3 <= state(31 downto 24);
  a1_3 <= state(23 downto 16);
  a2_3 <= state(15 downto 8);
  a3_3 <= state(7 downto 0);

  -- instanciate XORS temporaty results

  gen_xors_bram : for i in 0 to 7 generate
  begin

    xoring_t : component xor32
      port map (
        a       => doa(i),
        b       => dob(i),
        a_xor_b => temp(i)
      );

  end generate gen_xors_bram;

  -- instanciate columns results

  gen_columns_bram : for i in 0 to 3 generate
  begin

    column_final : component xor32
      port map (
        a       => temp(2 * i),
        b       => temp((2 * i) + 1),
        a_xor_b => final_column(i)
      );

  end generate gen_columns_bram;

  process (clk, rst) is
  begin

    if (rst = '0') then
      addra(0) <= (others => '0');
      addrb(0) <= (others => '0');
      addra(1) <= (others => '0');
      addrb(1) <= (others => '0');
      addra(2) <= (others => '0');
      addrb(2) <= (others => '0');
      addra(3) <= (others => '0');
      addrb(3) <= (others => '0');
      addra(4) <= (others => '0');
      addrb(4) <= (others => '0');
      addra(5) <= (others => '0');
      addrb(5) <= (others => '0');
      addra(6) <= (others => '0');
      addrb(6) <= (others => '0');
      addra(7) <= (others => '0');
      addrb(7) <= (others => '0');
    elsif rising_edge(clk) then
      -- 4th / last column
      addra(0)(9 DOWNTO 8) <= "11";
      addrb(0)(9 DOWNTO 8) <= "10";
      addra(0)(7 DOWNTO 0) <= a3_2;
      addrb(0)(7 DOWNTO 0) <= a2_1;
      addra(1)(9 DOWNTO 8) <= "01";
      addrb(1)(9 DOWNTO 8) <= "00";
      addra(1)(7 DOWNTO 0) <= a1_0;
      addrb(1)(7 DOWNTO 0) <= a0_3;
      -- 3rd column
      addra(2)(9 DOWNTO 8) <= "11";
      addrb(2)(9 DOWNTO 8) <= "10";
      addra(2)(7 DOWNTO 0) <= a3_1;
      addrb(2)(7 DOWNTO 0) <= a2_0;
      addra(3)(9 DOWNTO 8) <= "01";
      addrb(3)(9 DOWNTO 8) <= "00";
      addra(3)(7 DOWNTO 0) <= a1_3;
      addrb(3)(7 DOWNTO 0) <= a0_2;
      -- 2nd column
      addra(4)(9 DOWNTO 8) <= "11";
      addrb(4)(9 DOWNTO 8) <= "10";
      addra(4)(7 DOWNTO 0) <= a3_0;
      addrb(4)(7 DOWNTO 0) <= a2_3;
      addra(5)(9 DOWNTO 8) <= "01";
      addrb(5)(9 DOWNTO 8) <= "00";
      addra(5)(7 DOWNTO 0) <= a1_2;
      addrb(5)(7 DOWNTO 0) <= a0_1;
      -- 1st column
      addra(6)(9 DOWNTO 8) <= "11";
      addrb(6)(9 DOWNTO 8) <= "10";
      addra(6)(7 DOWNTO 0) <= a3_3;
      addrb(6)(7 DOWNTO 0) <= a2_2;
      addra(7)(9 DOWNTO 8) <= "01";
      addrb(7)(9 DOWNTO 8) <= "00";
      addra(7)(7 DOWNTO 0) <= a1_1;
      addrb(7)(7 DOWNTO 0) <= a0_0;
    end if;

  end process;

  output_state (127 DOWNTO 96) <= final_column(0) when last_round = '0' else
                                  doa(0)(31 downto 24) &
                                  dob(0)(7 downto 0) &
                                  doa(1)(15 downto 8) &
                                  dob(1)(23 downto 16);

  output_state (95 DOWNTO 64) <= final_column(1) when last_round = '0' else
                                 doa(2)(31 downto 24) &
                                 dob(2)(7 downto 0) &
                                 doa(3)(15 downto 8) &
                                 dob(3)(23 downto 16);

  output_state (63 DOWNTO 32) <= final_column(2) when last_round = '0' else
                                 doa(4)(31 downto 24) &
                                 dob(4)(7 downto 0) &
                                 doa(5)(15 downto 8) &
                                 dob(5)(23 downto 16);

  output_state (31 DOWNTO 0) <= final_column(3) when last_round = '0' else
                                doa(6)(31 downto 24) &
                                dob(6)(7 downto 0) &
                                doa(7)(15 downto 8) &
                                dob(7)(23 downto 16);

end architecture behavior;
