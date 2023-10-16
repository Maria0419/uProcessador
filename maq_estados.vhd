library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
    port (
        estado           : out std_logic;
        clk, rst, enable : in std_logic
    );
end maq_estados;

architecture a_maq_estados of maq_estados is

    signal estado_s : std_logic := '0';

begin

    process
    begin
        if (rst = '1') then
            estado_s <= '0';
        elsif (enable = '1') then
            if (rising_edge(clk)) then
                estado_s <= not estado_s;
            end if;
        end if;
    end process;

    estado <= estado_s;
    
end architecture;