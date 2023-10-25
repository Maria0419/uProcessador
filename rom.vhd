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
        0  => B"0101_00000101_011", --MOV R3, #5
        1  => B"0101_00001000_100", --MOV R4, #8
        2  => B"0001_00000_011_000", --ADD A, R3
        3  => B"0001_00000_100_000", --ADD A, R4
        4  => B"0110_00000000_101", --MOV R5, A
        5  => B"0101_00000001_001", --MOV R1, #1
        6  => B"0010_00000_001_000", -- SUB A, R1
        7  => B"0110_00000000_101", --MOV R5, A
        8  => B"1111_010_00010100", --JMP 20
        9  => "000000001000000", --NOP
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
        20 => B"0101_00000000_111", --MOV R7(A), #0
        21 => B"0001_00000_101_000", --ADD A, R5
        22 => B"0110_00000000_111", --MOV R3, A
        23 => B"0101_00001000_000", --MOV R7(A), #0
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