library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2x1_16bits is
    port(
        sel : in std_logic;
        i0, i1 : in unsigned (15 downto 0);
        saida : out unsigned (15 downto 0)
    );
end entity;

architecture a_mux2x1_16bits of mux2x1_16bits is
begin
    saida <= i0 when sel = '0' else
             i1 when sel = '1' else
             X"0000";

end architecture;