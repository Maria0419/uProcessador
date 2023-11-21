library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4x1_16bits is
    port(
        sel : in unsigned (1 downto 0);
        i0, i1, i2, i3 : in unsigned (15 downto 0);
        saida : out unsigned (15 downto 0)
    );
end entity;

architecture a_mux4x1_16bits of mux4x1_16bits is
begin
    saida <= i0 when sel = "00" else
             i1 when sel = "01" else
             i2 when sel = "10" else
             i3 when sel = "11" else
             X"0000";

end architecture;