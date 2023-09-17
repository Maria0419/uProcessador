library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        x, y : in unsigned(15 downto 0);
        op : in unsigned(1 downto 0);
        saida : out unsigned(15 downto 0)
    );
end ula;

architecture rtl of a_ula is
begin
    saida <= x + y when op = "00" else
             x - y when op = "01" else
             "00000001" when op = "10" and x>=y else
             x * y when op = "11" else
                "00000000";


end architecture;