library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incrementador is
    port (
        data_i : in unsigned (7 downto 0);
        data_o : out unsigned (7 downto 0)
    );
end incrementador;

architecture a_incrementador of incrementador is

begin

    data_o <= data_i + 1;
    
end architecture;