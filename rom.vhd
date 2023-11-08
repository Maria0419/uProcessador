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
        0  => B"0101_00000110_011", --MOV R3, #6
        1  => "000000001000000", --NOP
        2  => "000000001000000", --NOP
        3  => "000000001000000", --NOP
        4  => "000000001000000", --NOP
        5  => B"1101_00101_011_010", --CJNE R3, #5, 3
        6  => "000000001000000", --NOP
        7  => B"0101_00000000_111", --MOV A, #0
        8  => B"0010_00001_011_011", --SUBB A, R3
        9  => B"1110_00000000100", -- jc 4
        10 => "000000001000000", --NOP
        11 => "000000001000000", --NOP
        12 => "000000001000000", --NOP
        13 => "000000001000000", --NOP
        14 => "000000001000000", --NOP
        15 => "000000001000000", --NOP
        16 => "000000001000000", --NOP
        17 => "000000001000000", --NOP
        18 => "000000001000000", --NOP
        19 => "000000001000000", --NOP
        20 => B"0101_00000000_111", --MOV A, #0
        21 => B"0001_00000_101_000", --ADD A, R5
        22 => B"0110_00000000_111", --MOV R3, A
        23 => B"0101_00001000_000", --MOV A, #0
        24 => B"1111_000_00000010", --JMP 2

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