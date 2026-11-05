library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- ============================================================================
-- 32 steps of a 128 bits multiplication in GF(2 power 128)
-- multiplication of h_i with v_state_in

-- requires 4 of this block (in serial) to perform a full 128 bits multiplication
-- ============================================================================

entity multh_32way is
  port (
    v_state_in  : in    std_logic_vector(127 downto 0);
    z_acc_in    : in    std_logic_vector(127 downto 0);
    h_i         : in    std_logic_vector(31 downto 0);
    v_state_out : out   std_logic_vector(127 downto 0);
    z_acc_out   : out   std_logic_vector(127 downto 0)
  );
end entity multh_32way;

architecture behavior of multh_32way is

  component xtime_128 is
    port (
      in_1  : in    std_logic_vector(127 downto 0);
      out_1 : out   std_logic_vector(127 downto 0)
    );
  end component xtime_128;

  type v_state_t is array (0 to 32) of std_logic_vector(127 downto 0);

  signal v_state : v_state_t;

  type z_acc_t is array (0 to 31) of std_logic_vector(127 downto 0);

  signal z_acc : z_acc_t;

begin

  v_state(0) <= v_state_in;

  v_state_out <= v_state(32);
  z_acc_out   <= z_acc(31);

  z_acc(0) <= v_state(0) xor z_acc_in when h_i(0) = '1' else
              z_acc_in;

  gen_z_acc : for i in 1 to 31 generate
    z_acc(i) <= v_state(i) xor z_acc(i - 1) when h_i(i) = '1' else
                z_acc(i - 1);
  end generate gen_z_acc;

  gen_xtimers : for i in 0 to 31 generate
  begin

    xtimers : component xtime_128
      port map (
        in_1  => v_state(i),
        out_1 => v_state(i + 1)
      );

  end generate gen_xtimers;

end architecture behavior;
