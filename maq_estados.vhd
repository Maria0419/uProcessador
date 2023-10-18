library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
    port( 
        clk,rst: in std_logic;
          estado: out std_logic
    );
end entity;

architecture a_maq_estados of maq_estados is
    signal estado_s: std_logic:='0';
begin
    process(clk,rst)
    begin
        if rst='1' then
            estado_s <= '0';
        elsif rising_edge(clk) then
            if estado_s='1' then -- se esta no segundo estado
                estado_s <= '0'; -- o proximo vai voltar ao primeiro
            else
                estado_s <= not estado_s; -- senao avanca
            end if;
        end if;
    end process;
    estado <= estado_s;
end architecture;