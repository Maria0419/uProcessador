library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2x1_3bits is
    port(
        sel    : in std_logic;
        i0, i1 : in unsigned (2 downto 0);
        saida  : out unsigned (2 downto 0)
    );
end entity;

architecture a_mux2x1_3bits of mux2x1_3bits is
begin
    saida <= i0 when sel = '0' else
             i1 when sel = '1' else
             "000";

end architecture;