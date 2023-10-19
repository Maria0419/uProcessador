library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Maquina de estados de 3 estados => fetch (0), decode (1), execute (2)
entity maq_estados is
    port( 
        clk,rst: in std_logic;
          estado: out unsigned (1 downto 0)
    );
end entity;

architecture a_maq_estados of maq_estados is
    signal estado_s: unsigned (1 downto 0);
begin
    process(clk,rst)
    begin
        if rst='1' then
            estado_s <= "00";
        elsif rising_edge(clk) then
            if estado_s="10" then -- se esta no estado 2
                estado_s <= "00"; -- o proximo vai voltar ao 0
            else
                estado_s <= estado_s + 1; -- senao avanca
            end if;
        end if;
    end process;
    estado <= estado_s;
end architecture;