library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- state column is presented as (MSB) A0, A1, A2, A3 (LSB)

entity shiftmixsub_1bram is
  port (
    state        : in    std_logic_vector(127 downto 0);
    counter      : in    natural range 0 to 8;
    clk          : in    std_logic;
    rst          : in    std_logic;
    last_round   : in    std_logic;
    output_state : out   std_logic_vector(127 downto 0)
  );
end entity shiftmixsub_1bram;

architecture behavior of shiftmixsub_1bram is

  signal addra,  addrb : std_logic_vector(9 downto 0);
  signal doa,    dob   : std_logic_vector(31 downto 0);

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

  signal temp_0, temp_1 : std_logic_vector(31 downto 0);
  signal final_column   : std_logic_vector(31 downto 0);

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

  t_table : component bram_36_true_dual_port
    port map (
      addra => addra,
      addrb => addrb,
      clk   => clk,
      rst   => rst,
      doa   => doa,
      dob   => dob
    );

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

  xoring_t : component xor32
    port map (
      a       => doa,
      b       => dob,
      a_xor_b => temp_0
    );

  column_final : component xor32
    port map (
      a       => temp_0,
      b       => temp_1,
      a_xor_b => final_column
    );

  process (clk, rst) is
  begin

    if (rst = '0') then
      output_state <= (others => '0');
    elsif rising_edge(clk) then
      temp_1 <= temp_0;

      case counter is

        when 0 =>                                              -- "setup"

          addra(9 DOWNTO 8) <= "11";                           -- T3
          addrb(9 DOWNTO 8) <= "10";                           -- T2
          addra(7 DOWNTO 0) <= a3_2;
          addrb(7 DOWNTO 0) <= a2_1;

        when 1 =>

          addra(9 DOWNTO 8) <= "01";                           -- T1
          addrb(9 DOWNTO 8) <= "00";                           -- T0
          addra(7 DOWNTO 0) <= a1_0;
          addrb(7 DOWNTO 0) <= a0_3;
          if (last_round = '1') then
            output_state(127 DOWNTO 120) <= doa(31 downto 24);
            output_state(119 DOWNTO 112) <= dob(7 downto 0);
          end if;

        when 2 =>

          addra(9 DOWNTO 8) <= "11";
          addrb(9 DOWNTO 8) <= "10";
          addra(7 DOWNTO 0) <= a3_1;
          addrb(7 DOWNTO 0) <= a2_0;

          if (last_round = '1') then
            output_state(111 DOWNTO 104) <= doa(15 downto 8);
            output_state(103 DOWNTO 96)  <= dob(23 downto 16);
          else
            output_state(127 DOWNTO 96) <= final_column;
          end if;

        when 3 =>

          addra(9 DOWNTO 8) <= "01";
          addrb(9 DOWNTO 8) <= "00";
          addra(7 DOWNTO 0) <= a1_3;
          addrb(7 DOWNTO 0) <= a0_2;
          if (last_round = '1') then
            output_state(95 DOWNTO 88) <= doa(31 downto 24);
            output_state(87 DOWNTO 80) <= dob(7 downto 0);
          end if;

        when 4 =>

          addra(9 DOWNTO 8) <= "11";
          addrb(9 DOWNTO 8) <= "10";
          addra(7 DOWNTO 0) <= a3_0;
          addrb(7 DOWNTO 0) <= a2_3;
          if (last_round = '1') then
            output_state(79 DOWNTO 72) <= doa(15 downto 8);
            output_state(71 DOWNTO 64) <= dob(23 downto 16);
          else
            output_state(95 DOWNTO 64) <= final_column;
          end if;

        when 5 =>

          addra(9 DOWNTO 8) <= "01";
          addrb(9 DOWNTO 8) <= "00";
          addra(7 DOWNTO 0) <= a1_2;
          addrb(7 DOWNTO 0) <= a0_1;
          if (last_round = '1') then
            output_state(63 DOWNTO 56) <= doa(31 downto 24);
            output_state(55 DOWNTO 48) <= dob(7 downto 0);
          end if;

        when 6 =>

          addra(9 DOWNTO 8) <= "11";
          addrb(9 DOWNTO 8) <= "10";
          addra(7 DOWNTO 0) <= a3_3;
          addrb(7 DOWNTO 0) <= a2_2;
          if (last_round = '1') then
            output_state(47 DOWNTO 40) <= doa(15 downto 8);
            output_state(39 DOWNTO 32) <= dob(23 downto 16);
          else
            output_state(63 DOWNTO 32) <= final_column;
          end if;

        when 7 =>

          addra(9 DOWNTO 8) <= "01";
          addrb(9 DOWNTO 8) <= "00";
          addra(7 DOWNTO 0) <= a1_1;
          addrb(7 DOWNTO 0) <= a0_0;
          if (last_round = '1') then
            output_state(31 DOWNTO 24) <= doa(31 downto 24);
            output_state(23 DOWNTO 16) <= dob(7 downto 0);
          end if;

        when 8 =>

          addra(9 DOWNTO 8) <= "11";
          addrb(9 DOWNTO 8) <= "10";
          addra(7 DOWNTO 0) <= a3_2;
          addrb(7 DOWNTO 0) <= a2_1;
          if (last_round = '1') then
            output_state(15 DOWNTO 8) <= doa(15 downto 8);
            output_state(7 DOWNTO 0)  <= dob(23 downto 16);
          else
            output_state(31 DOWNTO 0) <= final_column;
          end if;

      end case;

    end if;

  end process;

end architecture behavior;
