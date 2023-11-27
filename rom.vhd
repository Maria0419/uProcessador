----------------------------------------------
---------------MEMÓRIA ROM--------------------
----------------------------------------------

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
        0   => B"0101_11111110_001",     -- MOV R1, 254
        1   => B"0101_00101101_010",     -- MOV R2, 45
        2   => B"0101_00001001_011",     -- MOV R3, 9
        3   => B"0101_01011001_100",     -- MOV R4, 89
        4   => B"0101_01110000_101",     -- MOV R5, 112
        5   => B"0101_00000000_110",     -- MOV R6, 0
        6   => B"1000_00001010_000",     -- MOV A, 10
        7   => B"1010_00000_001_000",    -- MOV @R1, A
        8   => B"1000_00010100_000",     -- MOV A, 20
        9   => B"1010_00000_010_000",    -- MOV @R2, A
        10  => B"1000_00011110_000",     -- MOV A, 30
        11  => B"1010_00000_011_000",    -- MOV @R3, A
        12  => B"1000_00101000_000",     -- MOV A, 40
        13  => B"1010_00000_100_000",    -- MOV @R4, A
        14  => B"1000_00110010_000",     -- MOV A, 50
        15  => B"1010_00000_101_000",    -- MOV @R5, A
        16  => B"1000_00111100_000",     -- MOV A, 60
        17  => B"1010_00000_110_000",    -- MOV @R6, A
        18  => B"1001_00000_001_000",    -- MOV A, @R1
        19  => B"1001_00000_010_000",    -- MOV A, @R2
        20  => B"1001_00000_011_000",    -- MOV A, @R3
        21  => B"1001_00000_100_000",    -- MOV A, @R4
        22  => B"1001_00000_101_000",    -- MOV A, @R5
        23  => B"1001_00000_110_000",    -- MOV A, @R6

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