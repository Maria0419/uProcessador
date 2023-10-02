library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_8x1 is
    port (
        data0, data1, data2, data3, data4, data5, data6, data7 : in unsigned (15 downto 0);
        sel : in unsigned (2 downto 0);
        data_out : out unsigned (15 downto 0)
    );
end mux_8x1;

architecture a_mux_8x1 of mux_8x1 is

begin

    data_out <= data0 when sel = "000" else
                data1 when sel = "001" else
                data2 when sel = "010" else
                data3 when sel = "011" else
                data4 when sel = "100" else
                data5 when sel = "101" else
                data6 when sel = "110" else
                data7 when sel = "111" else
                "0000000000000000";

end architecture;