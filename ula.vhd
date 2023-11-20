library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        x, y : in unsigned(15 downto 0);
        op : in unsigned(1 downto 0);
        saida : out unsigned(15 downto 0);
        carry : out std_logic;
        overflow : out std_logic
    );
end ula;

architecture a_ula of ula is

    signal x_tmp, y_tmp, soma_tmp, subt_tmp : unsigned (16 downto 0);

begin

    x_tmp <= '0' & x;
    y_tmp <= '0' & y;
    soma_tmp <= x_tmp + y_tmp;
    subt_tmp <= x_tmp - y_tmp;

    saida <= soma_tmp(15 downto 0) when op = "00" else
             subt_tmp(15 downto 0) when op = "01" else
             x and y when op = "10" else
             x xor y when op = "11" else
             "0000000000000000";
    
    carry <= soma_tmp(16) when op = "00" else
             '0' when op = "01" and y <= x else
             '1' when op = "01" and y > x else
             '0';

    overflow <= '1' when op = "00" and x(15) = '0' and y(15) = '0' and soma_tmp(15) = '1' else
                '1' when op = "00" and x(15) = '1' and y(15) = '1' and soma_tmp(15) = '0' else
                '1' when op = "01" and x(15) = '0' and y(15) = '1' and subt_tmp(15) = '1' else
                '1' when op = "01" and x(15) = '1' and y(15) = '0' and subt_tmp(15) = '0' else
                '0';

end architecture;