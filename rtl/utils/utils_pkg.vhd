library ieee;
use ieee.std_logic_1164.all;

package utils_pkg is

    function clog2(n : natural) return natural;

end package;

package body utils_pkg is

    function clog2(n : natural) return natural is
        variable v : natural := n ;
        variable r : natural := 0;
    begin
        while v > 0 loop
            v := v / 2;
            r := r + 1;
        end loop;

        if r = 0 then
            return 1;
        else
            return r;
        end if;
    end function;

end package body;