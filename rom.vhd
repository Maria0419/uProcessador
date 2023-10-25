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
        0  => "010100000100001", --MOV R1, #4
        1  => "000100000001000", --ADD A, R1
        2  => "111100000000100", --JMP 4
        3  => "000000000001000", --NOP
        4  => "011000000000101", --MOV R5, A
        5  => "111101000001010", --JMP 10
        6  => "000000001000000", --NOP
        7  => "000100000001000", --ADD A, R1
        8  => "011000000000101", -- MOV R5, A
        9  => "000001000000000", --NOP
        10 => "111100000000111", --JMP 7
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