library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_3to8 is
    port (
        in_bus  : in unsigned (2 downto 0);
        out_bus : out unsigned (7 downto 0)
    );
end decoder_3to8;

architecture a_decoder_3to8 of decoder_3to8 is

begin
    out_bus <= "00000001" when in_bus = "000" else
               "00000010" when in_bus = "001" else
               "00000100" when in_bus = "010" else
               "00001000" when in_bus = "011" else
               "00010000" when in_bus = "100" else
               "00100000" when in_bus = "101" else
               "01000000" when in_bus = "110" else
               "10000000" when in_bus = "111" else
               "00000000"

end architecture;