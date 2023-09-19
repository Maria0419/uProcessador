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

architecture a_ula of ula is

    signal parc : unsigned(31 downto 0);

begin
    parc <= x * y when op = "10" else
            "00000000000000000000000000000000";

    saida <= x + y when op = "00" else
             x - y when op = "01" else
             parc(15 downto 0) when op = "10" else
             x xor y when op = "11" else
             "0000000000000000";

end architecture;