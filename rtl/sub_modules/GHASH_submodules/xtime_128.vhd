library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- multiplication by two in GF(2)
-- consists of a right shift followed eventually by a XORING with 0001 1011
-- defined in 4.7 of the NIST.FIPS.197 "announcing Advanced encryption standard"

entity xtime_128 is
  port (
    in_1  : in    std_logic_vector(127 downto 0);
    out_1 : out   std_logic_vector(127 downto 0)
  );
end entity xtime_128;

architecture behavior of xtime_128 is

  signal polynom_lsb : std_logic_vector(7 downto 0) := x"87";

  signal in_times_2 : std_logic_vector(128 downto 0);

begin

  in_times_2 <= in_1 & '0'; -- "equivalent of a logical left shift"

  out_1 <= in_times_2(127 downto 8) & (in_times_2(7 downto 0) xor polynom_lsb) when in_times_2(128) = '1' else
           in_times_2(127 downto 0);

end architecture behavior;
