library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port 
    (
        clk  : in std_logic;
        addr : in unsigned (7 downto 0);
        data : out unsigned (14 downto 0)
    );
end rom;

architecture a_rom of rom is

    type mem is array (0 to 255) of unsigned (14 downto 0);

    constant conteudo_rom : mem := 
    (
        0  => "000000000000001",
        1  => "000000000000010",
        2  => "000000000000100",
        3  => "000000000001000",
        4  => "000000000010000",
        5  => "000000000100000",
        6  => "000000001000000",
        7  => "000000010000000",
        8  => "000000100000000",
        9  => "000001000000000",
        10 => "000010000000000",
        others => (others=>'0')
    );

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            data <= conteudo_rom(to_integer(addr));
        end if;
    end process;
end architecture;