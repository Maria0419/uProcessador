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
        0  => B"0101_00000000_011", --MOV R3, #0
        1  => B"0101_00000000_100", --MOV R4, #0
        2  => B"1000_00000000_000", --MOV A, #0
        3  => B"0001_00000_011_000", --ADD A, R3
        4  => B"0001_00000_100_000", --ADD A, R4
        5  => B"0110_00000000_100", --MOV R4, A
        6  => B"0101_00000001_111", --MOV A, #1
        7  => B"0001_00000_011_000", --ADD A, R3
        8  => B"0110_00000000_011", --MOV R3, A
        9  => B"0111_00000000000", --CLR C
        10 => B"0101_00011110_001", --MOV R1, #30
        11 => B"0010_00001_001_001", --SUBB A, R1
        12 => B"1110_11111110101", -- JC -11
        13 => B"1000_00000000_000", --MOV A, #0
        14 => B"0001_00000_100_000", --ADD A, R4
        15 => B"0110_00000000_101", --MOV R5, A
        16 => "000000001000000", --NOP
        17 => "000000001000000", --NOP
        18 => "000000001000000", --NOP
        19 => "000000001000000", --NOP

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