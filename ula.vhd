library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        x, y : in unsigned(15 downto 0);
        op : in unsigned(1 downto 0);
        saida : out unsigned(15 downto 0);
        carry : out std_logic
    );
end ula;

architecture a_ula of ula is

    signal x_17, y_17, soma_17 : unsigned (16 downto 0);

begin

    x_17 <= '0' & x;
    y_17 <= '0' & y;
    soma_17 <= x_17 + y_17;

    saida <= soma_17(15 downto 0) when op = "00" else
             x - y when op = "01" else
             x and y when op = "10" else
             x xor y when op = "11" else
             "0000000000000000";
    
    carry <= soma_17(16) when op = "00" else
             '0' when op = "01" and y <= x else
             '1' when op = "01" and y > x else
             '0';


end architecture;